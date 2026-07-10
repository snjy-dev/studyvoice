import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study_voice/core/theme/app_spacing.dart';
import 'package:study_voice/core/theme/app_typography.dart';
import 'package:study_voice/core/widgets/app_scaffold.dart';
import 'package:study_voice/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:study_voice/features/home/presentation/screens/home_screen.dart' show formatRelativeTime;
import 'package:study_voice/features/pdf/domain/entities/study_document.dart';
import 'package:study_voice/features/reader/presentation/providers/reader_provider.dart';
import 'package:study_voice/l10n/app_localizations.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final favorites = ref.watch(favoriteDocumentsProvider);
    final theme = Theme.of(context);

    return AppScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(l10n.favorites, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
            floating: true,
            centerTitle: false,
          ),
          if (favorites.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_border_rounded, size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                    AppSpacing.gapL,
                    Text(
                      l10n.noFavorites,
                      style: AppTypography.titleMedium.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    AppSpacing.gapS,
                    Text(
                      l10n.favoritesDesc,
                      style: AppTypography.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final doc = favorites[index];
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
                      subtitle: Text('${l10n.completedPercent((doc.progress * 100).toInt())} • ${formatRelativeTime(doc.lastOpened)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.star_rounded, color: Colors.amber),
                        onPressed: () {
                          ref.read(favoriteIdsProvider.notifier).toggleFavorite(doc.id);
                        },
                      ),
                      onTap: () {
                        ref.read(currentDocumentProvider.notifier).state = doc.toStudyDocument();
                        context.pushNamed('reader');
                      },
                    );
                  },
                  childCount: favorites.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
