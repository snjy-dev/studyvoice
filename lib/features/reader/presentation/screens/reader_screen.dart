import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/core/theme/app_spacing.dart';
import 'package:study_voice/core/theme/app_typography.dart';
import 'package:study_voice/core/widgets/app_scaffold.dart';
import 'package:study_voice/features/library/domain/entities/recent_document.dart';
import 'package:study_voice/features/library/presentation/providers/library_provider.dart';
import 'package:study_voice/features/pdf/domain/entities/study_document.dart';
import 'package:study_voice/features/reader/domain/entities/reader_preferences.dart';
import 'package:study_voice/features/reader/presentation/providers/reader_provider.dart';
import 'package:study_voice/features/tts/domain/repositories/tts_repository.dart';
import 'package:study_voice/features/tts/presentation/providers/tts_provider.dart';
import 'package:study_voice/l10n/app_localizations.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({super.key});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> with WidgetsBindingObserver {
  late ScrollController _scrollController;
  Timer? _hideUiTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    var initialOffset = 0.0;
    var initialProgress = 0.0;
    final doc = ref.read(currentDocumentProvider);
    if (doc != null) {
      final recents = ref.read(recentDocumentsProvider).value ?? [];
      final recent = recents.where((e) => e.id == doc.id).firstOrNull;
      if (recent != null) {
        if (recent.scrollOffset > 0) {
          initialOffset = recent.scrollOffset;
        }
        if (recent.progress > 0) {
          initialProgress = recent.progress;
        }
      }
    }

    _scrollController = ScrollController(initialScrollOffset: initialOffset);
    _scrollController.addListener(_onScroll);
    
    // Add to recent documents immediately upon opening, preserving offset/progress
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (doc != null) {
        // Also ensure UI reflects the initial progress
        ref.read(readerUiProvider.notifier).setProgress(initialProgress);
        final recentDoc = RecentDocument.fromStudyDocument(
          doc,
          progress: initialProgress,
          scrollOffset: initialOffset,
        );
        ref.read(recentDocumentsProvider.notifier).addToRecent(recentDoc);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _saveCurrentProgress();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveCurrentProgress();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _hideUiTimer?.cancel();
    ref.read(ttsRepositoryProvider).stop();
    super.dispose();
  }



  void _saveCurrentProgress() {
    final doc = ref.read(currentDocumentProvider);
    if (doc != null && _scrollController.hasClients) {
      final progress = ref.read(readerUiProvider).progress;
      final offset = _scrollController.offset;
      
      final recentDoc = RecentDocument.fromStudyDocument(
        doc,
        progress: progress,
        scrollOffset: offset,
      );
      
      ref.read(recentDocumentsProvider.notifier).addToRecent(recentDoc);
    }
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final progress = maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.0, 1.0) : 0.0;
      ref.read(readerUiProvider.notifier).setProgress(progress);
      
      // Immersive Mode UX: Reveal controls on scroll
      final uiState = ref.read(readerUiProvider);
      if (uiState.isImmersive) {
        ref.read(readerUiProvider.notifier).setImmersive(false);
      }
      _resetHideTimer();
      
      // Save progress if it changes significantly (every 5%)
      final lastSavedProgress = uiState.progress;
      if ((progress - lastSavedProgress).abs() > 0.05) {
         _saveCurrentProgress();
      }
    }
  }

  void _resetHideTimer() {
    _hideUiTimer?.cancel();
    _hideUiTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        ref.read(readerUiProvider.notifier).setImmersive(true);
      }
    });
  }

  Color _getBgColor(ReaderThemeType type) {
    switch (type) {
      case ReaderThemeType.light:
        return Colors.white;
      case ReaderThemeType.sepia:
        return const Color(0xFFF4ECD8);
      case ReaderThemeType.dark:
        return const Color(0xFF1A1A1A);
      case ReaderThemeType.amoled:
        return Colors.black;
    }
  }

  Color _getTextColor(ReaderThemeType type) {
    switch (type) {
      case ReaderThemeType.light:
      case ReaderThemeType.sepia:
        return const Color(0xFF2C2C2C);
      case ReaderThemeType.dark:
      case ReaderThemeType.amoled:
        return const Color(0xFFE0E0E0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc = ref.watch(currentDocumentProvider);
    final l10n = AppLocalizations.of(context)!;
    final ttsState = ref.watch(ttsStateProvider).value ?? TtsState.idle;
    final prefs = ref.watch(readerPreferencesProvider);
    final uiState = ref.watch(readerUiProvider);

    if (doc == null) {
      return AppScaffold(
        body: Center(
          child: Text(l10n.noDocumentLoaded),
        ),
      );
    }

    final bgColor = _getBgColor(prefs.themeType);
    final textColor = _getTextColor(prefs.themeType);

    if (!uiState.isImmersive && _hideUiTimer == null) {
      _resetHideTimer();
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: prefs.themeType == ReaderThemeType.light || prefs.themeType == ReaderThemeType.sepia
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                ref.read(readerUiProvider.notifier).toggleImmersive();
                _hideUiTimer?.cancel();
                _hideUiTimer = null;
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.l,
                  MediaQuery.of(context).padding.top + 80,
                  AppSpacing.l,
                  150,
                ),
                child: SelectableText(
                  doc.extractedText,
                  style: TextStyle(
                    color: textColor,
                    fontSize: prefs.fontSize,
                    height: prefs.lineHeight,
                    letterSpacing: prefs.letterSpacing,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),

            // Top Bar & Progress
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              top: uiState.isImmersive ? -120 : 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: bgColor.withValues(alpha: 0.9),
                    surfaceTintColor: Colors.transparent,
                    title: Text(
                      doc.name,
                      style: AppTypography.titleMedium.copyWith(color: textColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: BackButton(color: textColor),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.info_outline_rounded, color: textColor),
                        onPressed: () => _showStats(context, doc, l10n),
                      ),
                    ],
                  ),
                  LinearProgressIndicator(
                    value: uiState.progress,
                    backgroundColor: textColor.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                    minHeight: 2,
                  ),
                ],
              ),
            ),

            // Bottom Control Bar
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              bottom: uiState.isImmersive ? -150 : 0,
              left: 0,
              right: 0,
              child: _PremiumControlBar(
                state: ttsState,
                text: doc.extractedText,
                textColor: textColor,
                bgColor: bgColor,
                progress: uiState.progress,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStats(BuildContext context, StudyDocument doc, AppLocalizations l10n) {
    final estimatedMinutes = (doc.wordCount / 200).ceil();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.recentDocuments),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Words: ${doc.wordCount}'),
            Text('Characters: ${doc.characterCount}'),
            Text('Estimated reading time: $estimatedMinutes min'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.done)),
        ],
      ),
    );
  }
}

class _PremiumControlBar extends ConsumerWidget {
  final TtsState state;
  final String text;
  final Color textColor;
  final Color bgColor;
  final double progress;

  const _PremiumControlBar({
    required this.state,
    required this.text,
    required this.textColor,
    required this.bgColor,
    required this.progress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(ttsRepositoryProvider);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: textColor.withValues(alpha: 0.1))),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).toInt()}%',
                  style: AppTypography.labelSmall.copyWith(color: textColor.withValues(alpha: 0.6)),
                ),
                IconButton(
                  icon: Icon(Icons.text_fields_rounded, color: textColor),
                  onPressed: () => _showTypographySettings(context),
                ),
                IconButton(
                  icon: Icon(Icons.palette_outlined, color: textColor),
                  onPressed: () => _showThemeSettings(context),
                ),
                IconButton(
                  icon: Icon(Icons.tune_rounded, color: textColor),
                  onPressed: () => _showTtsSettings(context),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.replay_10_rounded, color: textColor.withValues(alpha: 0.3)),
                  onPressed: null, // Disabled until implemented
                ),
                FloatingActionButton(
                  elevation: 0,
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  onPressed: () {
                    if (state == TtsState.playing) {
                      repo.pause();
                    } else {
                      repo.speak(text);
                    }
                  },
                  child: Icon(state == TtsState.playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
                ),
                IconButton(
                  icon: Icon(Icons.forward_30_rounded, color: textColor.withValues(alpha: 0.3)),
                  onPressed: null, // Disabled until implemented
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTypographySettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const _TypographySettingsSheet(),
    );
  }

  void _showThemeSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const _ThemeSettingsSheet(),
    );
  }

  void _showTtsSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const _TtsQuickSettingsSheet(),
    );
  }
}

class _TypographySettingsSheet extends ConsumerWidget {
  const _TypographySettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(readerPreferencesProvider);
    final notifier = ref.read(readerPreferencesProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Typography', style: AppTypography.titleLarge),
          AppSpacing.gapL,
          _ControlSlider(
            label: 'Font Size',
            value: prefs.fontSize,
            min: 12,
            max: 32,
            onChanged: notifier.setFontSize,
          ),
          _ControlSlider(
            label: 'Line Height',
            value: prefs.lineHeight,
            min: 1.0,
            max: 2.5,
            onChanged: notifier.setLineHeight,
          ),
          _ControlSlider(
            label: 'Letter Spacing',
            value: prefs.letterSpacing,
            min: -1.0,
            max: 2.0,
            onChanged: notifier.setLetterSpacing,
          ),
        ],
      ),
    );
  }
}

class _ThemeSettingsSheet extends ConsumerWidget {
  const _ThemeSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(readerPreferencesProvider);
    final notifier = ref.read(readerPreferencesProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Reader Theme', style: AppTypography.titleLarge),
          AppSpacing.gapL,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ReaderThemeType.values.map((type) {
              return GestureDetector(
                onTap: () => notifier.setThemeType(type),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getPreviewColor(type),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: prefs.themeType == type ? Colors.blue : Colors.grey.withValues(alpha: 0.3),
                      width: 3,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          AppSpacing.gapL,
        ],
      ),
    );
  }

  Color _getPreviewColor(ReaderThemeType type) {
    switch (type) {
      case ReaderThemeType.light:
        return Colors.white;
      case ReaderThemeType.sepia:
        return const Color(0xFFF4ECD8);
      case ReaderThemeType.dark:
        return const Color(0xFF1A1A1A);
      case ReaderThemeType.amoled:
        return Colors.black;
    }
  }
}

class _TtsQuickSettingsSheet extends ConsumerWidget {
  const _TtsQuickSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(ttsSettingsProvider);
    final notifier = ref.read(ttsSettingsProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Voice Settings', style: AppTypography.titleLarge),
          AppSpacing.gapL,

          // Language
          Text(l10n.voiceLanguage, style: AppTypography.labelLarge),
          AppSpacing.gapS,
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'en-US', label: Text('English')),
              ButtonSegment(value: 'ta-IN', label: Text('தமிழ்')),
            ],
            selected: {settings.language},
            onSelectionChanged: (val) => notifier.setLanguage(val.first),
          ),
          AppSpacing.gapL,

          _ControlSlider(
            label: 'Speech Rate',
            value: settings.rate,
            min: 0.1,
            max: 1.0,
            onChanged: notifier.setRate,
          ),
          _ControlSlider(
            label: 'Pitch',
            value: settings.pitch,
            min: 0.5,
            max: 2.0,
            onChanged: notifier.setPitch,
          ),
          const SizedBox(height: AppSpacing.huge),
        ],
      ),
    );
  }
}

class _ControlSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _ControlSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.labelLarge),
            Text(value.toStringAsFixed(1)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
