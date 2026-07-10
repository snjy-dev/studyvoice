import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/core/theme/app_spacing.dart';
import 'package:study_voice/core/theme/app_typography.dart';
import 'package:study_voice/core/widgets/app_scaffold.dart';
import 'package:study_voice/features/bookmarks/presentation/providers/bookmarks_provider.dart';
import 'package:study_voice/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:study_voice/features/library/domain/entities/recent_document.dart';
import 'package:study_voice/features/library/presentation/providers/library_provider.dart';
import 'package:study_voice/features/pdf/domain/entities/study_document.dart';
import 'package:study_voice/features/reader/presentation/providers/reader_provider.dart';
import 'package:study_voice/features/tts/presentation/providers/tts_provider.dart';
import 'package:study_voice/features/tts/domain/repositories/tts_repository.dart';
import 'package:study_voice/features/search/presentation/providers/search_provider.dart';
import 'package:study_voice/features/reader/domain/entities/reader_preferences.dart';
import 'package:study_voice/l10n/app_localizations.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({super.key});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> with WidgetsBindingObserver {
  late ScrollController _scrollController;
  Timer? _hideUiTimer;
  Timer? _searchDebounce;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  double _lastSavedProgress = -1.0;

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
    _searchDebounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    ref.read(searchProvider.notifier).clearSearch();
    ref.read(searchProvider.notifier).hideSearchBar();
    ref.read(ttsRepositoryProvider).stop();
    super.dispose();
  }



  void _saveCurrentProgress() {
    final doc = ref.read(currentDocumentProvider);
    if (doc != null && _scrollController.hasClients) {
      final progress = ref.read(readerUiProvider).progress;
      final offset = _scrollController.offset;
      
      _lastSavedProgress = progress;
      
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
      if (_lastSavedProgress < 0 || (progress - _lastSavedProgress).abs() > 0.05) {
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

  void _scrollToMatch(int textOffset, String text, TextStyle textStyle) {
    if (textOffset < 0 || textOffset > text.length) {
      textOffset = 0;
    }

    const padding = AppSpacing.l * 2; // Left and right padding
    final maxWidth = MediaQuery.of(context).size.width - padding;

    final textSpan = TextSpan(
      text: text.substring(0, textOffset),
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: maxWidth);
    final yOffset = textPainter.size.height;

    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top + 80;
    
    // Center the match on screen
    final targetOffset = yOffset - (screenHeight / 2) + topPadding;

    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  TextSpan _buildHighlightedText(String text, SearchState searchState, TtsProgress? ttsProgress, TextStyle baseStyle) {
    if ((searchState.matches.isEmpty || !searchState.isSearchBarVisible) && ttsProgress == null) {
      return TextSpan(text: text, style: baseStyle);
    }
    
    // To keep it simple and highly performant, we will build a list of "events" (start/end of highlights)
    // But since TTS is just one word, we can just overlay it.
    
    final spans = <InlineSpan>[];
    var lastOffset = 0;

    void addSpan(int start, int end, {bool isSearch = false, bool isCurrentSearch = false, bool isTts = false}) {
      if (start < 0 || start > text.length || end < start || end > text.length) {
        return; // Discard invalid highlight ranges completely
      }

      if (start > lastOffset) {
        spans.add(TextSpan(text: text.substring(lastOffset, start)));
      }
      if (start < end) {
        Color? bgColor;
        Color? fgColor;
        
        if (isTts) {
          bgColor = Theme.of(context).colorScheme.primary.withValues(alpha: 0.3);
          fgColor = Theme.of(context).colorScheme.onSurface;
        } else if (isSearch) {
          bgColor = isCurrentSearch ? Colors.orange : Colors.yellow.withValues(alpha: 0.5);
          fgColor = Colors.black;
        }
        
        spans.add(TextSpan(
          text: text.substring(start, end),
          style: baseStyle.copyWith(backgroundColor: bgColor, color: fgColor),
        ));
      }
      lastOffset = end;
    }

    if (ttsProgress != null && (!searchState.isSearchBarVisible || searchState.matches.isEmpty)) {
      // Only TTS
      addSpan(ttsProgress.startOffset, ttsProgress.endOffset, isTts: true);
    } else if (ttsProgress == null && searchState.isSearchBarVisible && searchState.matches.isNotEmpty) {
      // Only Search
      for (var i = 0; i < searchState.matches.length; i++) {
        final match = searchState.matches[i];
        addSpan(match.startOffset, match.endOffset, isSearch: true, isCurrentSearch: i == searchState.currentMatchIndex);
      }
    } else {
      // Both (fallback to search priority to avoid complex overlap logic for now, or just render both sequentially if they don't overlap)
      // For a robust offline reader, usually they don't overlap. We'll just render search for simplicity.
      for (var i = 0; i < searchState.matches.length; i++) {
        final match = searchState.matches[i];
        addSpan(match.startOffset, match.endOffset, isSearch: true, isCurrentSearch: i == searchState.currentMatchIndex);
      }
    }
    
    if (lastOffset < text.length) {
      spans.add(TextSpan(text: text.substring(lastOffset)));
    }
    
    return TextSpan(children: spans, style: baseStyle);
  }

  @override
  Widget build(BuildContext context) {
    final doc = ref.watch(currentDocumentProvider);
    final l10n = AppLocalizations.of(context)!;
    final ttsState = ref.watch(ttsStateProvider).value ?? TtsState.idle;
    final ttsProgress = ref.watch(ttsProgressProvider).value;
    final prefs = ref.watch(readerPreferencesProvider);
    final uiState = ref.watch(readerUiProvider);
    final searchState = ref.watch(searchProvider);

    // Auto-scroll to TTS spoken word
    ref.listen(ttsProgressProvider, (previous, next) {
      if (next.value != null && ttsState == TtsState.playing) {
        final textStyle = TextStyle(
          color: _getTextColor(prefs.themeType),
          fontSize: prefs.fontSize,
          height: prefs.lineHeight,
          letterSpacing: prefs.letterSpacing,
          fontFamily: 'Roboto',
        );
        _scrollToMatch(next.value!.startOffset, doc?.extractedText ?? '', textStyle);
      }
    });

    ref.listen(searchProvider, (previous, next) {
      if (previous?.currentMatchIndex != next.currentMatchIndex && next.matches.isNotEmpty) {
        final match = next.matches[next.currentMatchIndex];
        final textStyle = TextStyle(
          color: _getTextColor(prefs.themeType),
          fontSize: prefs.fontSize,
          height: prefs.lineHeight,
          letterSpacing: prefs.letterSpacing,
          fontFamily: 'Roboto',
        );
        _scrollToMatch(match.startOffset, doc?.extractedText ?? '', textStyle);
      }
      
      if (!previous!.isSearchBarVisible && next.isSearchBarVisible) {
        _searchFocus.requestFocus();
      }
    });

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
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Top Bar & Progress
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: uiState.isImmersive ? 0 : null,
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
                              icon: Icon(Icons.search_rounded, color: textColor),
                              onPressed: () => ref.read(searchProvider.notifier).toggleSearchBar(),
                            ),
                            _AnimatedFavoriteButton(doc: doc, textColor: textColor),
                            _BookmarkButton(doc: doc, textColor: textColor, scrollController: _scrollController),
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
                      // Search Bar
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: searchState.isSearchBarVisible ? 60 : 0,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Container(
                            height: 60,
                            color: bgColor,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    focusNode: _searchFocus,
                                    style: TextStyle(color: textColor),
                                    decoration: InputDecoration(
                                      hintText: l10n.searchDocument,
                                      hintStyle: TextStyle(color: textColor.withValues(alpha: 0.5)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: textColor.withValues(alpha: 0.05),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                                    ),
                                    onChanged: (val) {
                                      _searchDebounce?.cancel();
                                      _searchDebounce = Timer(const Duration(milliseconds: 250), () {
                                        ref.read(searchProvider.notifier).search(val, doc.extractedText);
                                      });
                                    },
                                  ),
                                ),
                                if (searchState.isSearching) ...[
                                  const SizedBox(width: AppSpacing.s),
                                  SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: textColor)),
                                ] else if (searchState.matches.isNotEmpty) ...[
                                  const SizedBox(width: AppSpacing.s),
                                  Text(
                                    l10n.matchCount(searchState.currentMatchIndex + 1, searchState.matches.length),
                                    style: TextStyle(color: textColor, fontSize: 12),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.keyboard_arrow_up_rounded, color: textColor),
                                    onPressed: () => ref.read(searchProvider.notifier).previousMatch(),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: textColor),
                                    onPressed: () => ref.read(searchProvider.notifier).nextMatch(),
                                  ),
                                ] else if (searchState.query.isNotEmpty) ...[
                                  const SizedBox(width: AppSpacing.s),
                                  Text(l10n.noMatchesFound, style: TextStyle(color: textColor, fontSize: 12)),
                                ],
                                IconButton(
                                  icon: Icon(Icons.close_rounded, color: textColor),
                                  onPressed: () {
                                    _searchController.clear();
                                    ref.read(searchProvider.notifier).hideSearchBar();
                                    _searchFocus.unfocus();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Document
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(readerUiProvider.notifier).toggleImmersive();
                    _hideUiTimer?.cancel();
                    _hideUiTimer = null;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.l),
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: SelectableText.rich(
                  _buildHighlightedText(
                    doc.extractedText,
                    searchState,
                    ttsProgress,
                    TextStyle(
                      color: textColor,
                      fontSize: prefs.fontSize,
                      height: prefs.lineHeight,
                      letterSpacing: prefs.letterSpacing,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  onSelectionChanged: (selection, cause) {
                    if (cause == SelectionChangedCause.tap) {
                      ref.read(ttsRepositoryProvider).speak(doc.extractedText, startOffset: selection.baseOffset);
                    }
                  },
                ),
              ),
            ),
          ),
        ),

          // Bottom Control Bar
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: uiState.isImmersive ? 0 : null,
              child: _PremiumControlBar(
                state: ttsState,
                text: doc.extractedText,
                textColor: textColor,
                bgColor: bgColor,
                progress: uiState.progress,
              ),
            ),
          ),
        ],
      ),
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
                Tooltip(
                  message: AppLocalizations.of(context)!.rewindWords(30),
                  child: IconButton(
                    icon: Icon(Icons.replay_30_rounded, color: textColor),
                    onPressed: () => repo.seekWords(-30),
                    tooltip: AppLocalizations.of(context)!.rewindWords(30),
                  ),
                ),
                FloatingActionButton(
                  elevation: 0,
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  onPressed: () {
                    if (state == TtsState.playing) {
                      repo.pause();
                    } else if (state == TtsState.paused) {
                      repo.seekWords(0); // This just triggers resume from current offset
                    } else {
                      repo.speak(text);
                    }
                  },
                  child: Icon(state == TtsState.playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
                ),
                Tooltip(
                  message: AppLocalizations.of(context)!.forwardWords(30),
                  child: IconButton(
                    icon: Icon(Icons.forward_30_rounded, color: textColor),
                    onPressed: () => repo.seekWords(30),
                    tooltip: AppLocalizations.of(context)!.forwardWords(30),
                  ),
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

class _AnimatedFavoriteButton extends ConsumerWidget {
  final StudyDocument doc;
  final Color textColor;

  const _AnimatedFavoriteButton({required this.doc, required this.textColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Actually we should watch the provider itself to rebuild when it changes.
    // The previous line was reading the notifier without watching state changes.
    final favorites = ref.watch(favoriteIdsProvider).value ?? [];
    final currentlyFavorite = favorites.contains(doc.id);

    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
        child: Icon(
          currentlyFavorite ? Icons.star_rounded : Icons.star_border_rounded,
          key: ValueKey(currentlyFavorite),
          color: currentlyFavorite ? Colors.amber : textColor,
        ),
      ),
      onPressed: () {
        ref.read(favoriteIdsProvider.notifier).toggleFavorite(doc.id);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(currentlyFavorite ? 'Removed from Favorites' : 'Added to Favorites'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }
}

class _BookmarkButton extends ConsumerStatefulWidget {
  final StudyDocument doc;
  final Color textColor;
  final ScrollController scrollController;

  const _BookmarkButton({required this.doc, required this.textColor, required this.scrollController});

  @override
  ConsumerState<_BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends ConsumerState<_BookmarkButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addBookmark() async {
    if (!widget.scrollController.hasClients) return;

    unawaited(_controller.forward(from: 0.0)); // Play animation

    final uiState = ref.read(readerUiProvider);
    final offset = widget.scrollController.offset;
    final progress = uiState.progress;

    final success = await ref.read(bookmarksProvider.notifier).addBookmark(
      documentId: widget.doc.id,
      documentTitle: widget.doc.name,
      scrollOffset: offset,
      progress: progress,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Bookmark Added' : 'Bookmark already exists near here'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        icon: Icon(Icons.bookmark_add_outlined, color: widget.textColor),
        onPressed: _addBookmark,
      ),
    );
  }
}
