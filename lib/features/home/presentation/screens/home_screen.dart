import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study_voice/core/theme/app_spacing.dart';
import 'package:study_voice/core/theme/app_typography.dart';
import 'package:study_voice/core/widgets/app_scaffold.dart';
import 'package:study_voice/core/widgets/empty_state.dart';
import 'package:study_voice/core/widgets/feature_tile.dart';
import 'package:study_voice/core/widgets/section_header.dart';
import 'package:study_voice/core/widgets/study_card.dart';
import 'package:study_voice/features/library/domain/entities/recent_document.dart';
import 'package:study_voice/features/library/presentation/providers/library_provider.dart';
import 'package:study_voice/features/ocr/presentation/widgets/ocr_scan_button.dart';
import 'package:study_voice/features/pdf/domain/entities/study_document.dart';
import 'package:study_voice/features/pdf/presentation/widgets/pdf_import_button.dart';
import 'package:study_voice/features/reader/presentation/providers/reader_provider.dart';
import 'package:study_voice/l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final recentDocsAsync = ref.watch(recentDocumentsProvider);

    return AppScaffold(
      appBar: AppBar(
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.l),
          child: Center(
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
              radius: 20,
              child: Icon(
                Icons.auto_stories_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
        title: Text(
          l10n.appTitle,
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Notifications',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
          ),
          const SizedBox(width: AppSpacing.m),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: AppSpacing.huge),
        children: [
          AppSpacing.gapXl,
          const _GreetingHeader(),
          AppSpacing.gapXl,
          const _ContinueReadingSection(),
          AppSpacing.gapXl,
          const _QuickActionsGrid(),
          AppSpacing.gapXl,
          SectionHeader(
            title: l10n.recentDocuments,
            trailing: TextButton(
              onPressed: () => context.pushNamed('history'),
              child: Text(l10n.seeAll),
            ),
          ),
          recentDocsAsync.when(
            data: (docs) {
              if (docs.isEmpty) {
                return EmptyState(
                  icon: Icons.history_rounded,
                  title: l10n.noRecentDocs,
                  description: l10n.recentDocsDesc,
                );
              }
              return Column(
                children: docs.take(5).map((doc) => _DocumentListTile(doc: doc)).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          ),
          AppSpacing.gapXl,
          SectionHeader(
            title: l10n.favorites,
            trailing: TextButton(
              onPressed: () {},
              child: Text(l10n.seeAll),
            ),
          ),
          EmptyState(
            icon: Icons.star_border_rounded,
            title: l10n.noFavorites,
            description: l10n.favoritesDesc,
          ),
        ],
      ),
    );
  }
}

class _DocumentListTile extends ConsumerWidget {
  final RecentDocument doc;

  const _DocumentListTile({required this.doc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final timeStr = _formatTime(doc.lastOpened);
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.s),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.s),
        ),
        child: Icon(
          doc.source == DocumentType.pdf ? Icons.picture_as_pdf_rounded : Icons.image_rounded,
          color: theme.colorScheme.primary,
        ),
      ),
      title: Text(doc.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('${l10n.completedPercent((doc.progress * 100).toInt())} • $timeStr'),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {
        ref.read(currentDocumentProvider.notifier).state = doc.toStudyDocument();
        context.pushNamed('reader');
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    return formatRelativeTime(dateTime);
  }
}

String formatRelativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else {
    return '${dateTime.day}/${dateTime.month}';
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_getGreeting(l10n)},',
          style: AppTypography.headlineMedium.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          '${l10n.welcome} 👋',
          style: AppTypography.displaySmall.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -1.0,
            color: theme.colorScheme.onSurface,
          ),
        ),
        AppSpacing.gapS,
        Text(
          l10n.studySubtitle,
          style: AppTypography.bodyLarge.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _ContinueReadingSection extends ConsumerWidget {
  const _ContinueReadingSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final recentDocs = ref.watch(recentDocumentsProvider).value ?? [];
    
    if (recentDocs.isEmpty) {
      return StudyCard(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                AppSpacing.gapM,
                Text(
                  l10n.continueReading,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.auto_stories_outlined,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                  ),
                  AppSpacing.gapM,
                  Text(
                    l10n.noActiveSession,
                    style: AppTypography.titleMedium.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.gapXs,
                  Text(
                    l10n.activeSessionDesc,
                    style: AppTypography.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: null,
                style: FilledButton.styleFrom(
                  disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  disabledForegroundColor: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                child: Text(l10n.startReading),
              ),
            ),
          ],
        ),
      );
    }

    final latestDoc = recentDocs.first;
    final timeStr = formatRelativeTime(latestDoc.lastOpened);
    final remainingProgress = (1.0 - latestDoc.progress).clamp(0.0, 1.0);
    final totalWords = latestDoc.wordCount > 0 ? latestDoc.wordCount : 1000;
    final remainingWords = (totalWords * remainingProgress).toInt();
    final remainingMinutes = (remainingWords / 200).ceil();

    return StudyCard(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.s),
                ),
                child: Icon(
                  latestDoc.source == DocumentType.pdf ? Icons.picture_as_pdf_rounded : Icons.image_rounded,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
              AppSpacing.gapM,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      latestDoc.title,
                      style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.gapXs,
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          timeStr,
                          style: AppTypography.bodySmall.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.timer_outlined, size: 14, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          '${remainingMinutes}m left',
                          style: AppTypography.bodySmall.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.l),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: AppTypography.labelMedium.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              Text(
                '${(latestDoc.progress * 100).toInt()}%',
                style: AppTypography.labelLarge.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          AppSpacing.gapS,
          LinearProgressIndicator(
            value: latestDoc.progress,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.xs),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: () {
                ref.read(currentDocumentProvider.notifier).state = latestDoc.toStudyDocument();
                context.pushNamed('reader');
              },
              child: Text(l10n.continueReading),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  static void _dummyOnTap() {}

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isTablet ? 3 : 2,
      mainAxisSpacing: AppSpacing.m,
      crossAxisSpacing: AppSpacing.m,
      childAspectRatio: 0.95,
      children: [
        const PdfImportButton(),
        const OcrScanButton(),
        FeatureTile(
          icon: Icons.text_snippet_rounded,
          title: l10n.pasteText,
          subtitle: l10n.fromClipboard,
          onTap: _dummyOnTap,
        ),
        FeatureTile(
          icon: Icons.history_rounded,
          title: l10n.history,
          subtitle: l10n.pastActivity,
          onTap: () => context.pushNamed('history'),
        ),
        FeatureTile(
          icon: Icons.star_rounded,
          title: l10n.favorites,
          subtitle: l10n.savedItems,
          onTap: _dummyOnTap,
        ),
        FeatureTile(
          icon: Icons.bookmark_rounded,
          title: l10n.bookmarks,
          subtitle: l10n.pageMarkers,
          onTap: _dummyOnTap,
        ),
      ],
    );
  }
}
