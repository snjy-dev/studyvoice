import 'package:flutter/material.dart';
import 'package:study_voice/core/theme/app_spacing.dart';
import 'package:study_voice/core/theme/app_typography.dart';
import 'package:study_voice/core/widgets/app_scaffold.dart';
import 'package:study_voice/core/widgets/empty_state.dart';
import 'package:study_voice/core/widgets/feature_tile.dart';
import 'package:study_voice/core/widgets/section_header.dart';
import 'package:study_voice/core/widgets/study_card.dart';
import 'package:study_voice/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
              onPressed: () {},
              child: Text(l10n.seeAll),
            ),
          ),
          EmptyState(
            icon: Icons.history_rounded,
            title: l10n.noRecentDocs,
            description: l10n.recentDocsDesc,
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

class _ContinueReadingSection extends StatelessWidget {
  const _ContinueReadingSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
        FeatureTile(
          icon: Icons.picture_as_pdf_rounded,
          title: l10n.openPdf,
          subtitle: l10n.localStorage,
          onTap: _dummyOnTap,
        ),
        FeatureTile(
          icon: Icons.camera_alt_rounded,
          title: l10n.scanImage,
          subtitle: l10n.captureAndRead,
          onTap: _dummyOnTap,
        ),
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
          onTap: _dummyOnTap,
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
