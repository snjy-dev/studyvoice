import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study_voice/core/theme/app_spacing.dart';
import 'package:study_voice/core/theme/app_typography.dart';
import 'package:study_voice/core/widgets/app_scaffold.dart';
import 'package:study_voice/features/bookmarks/presentation/providers/bookmarks_provider.dart';
import 'package:study_voice/features/home/presentation/screens/home_screen.dart' show formatRelativeTime;
import 'package:study_voice/features/library/domain/entities/recent_document.dart';
import 'package:study_voice/features/library/presentation/providers/library_provider.dart';
import 'package:study_voice/features/reader/presentation/providers/reader_provider.dart';
import 'package:study_voice/l10n/app_localizations.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final theme = Theme.of(context);

    return AppScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(l10n.bookmarks, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
            floating: true,
            centerTitle: false,
          ),
          bookmarksAsync.when(
            data: (bookmarks) {
              if (bookmarks.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark_border_rounded, size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                        AppSpacing.gapL,
                        Text(
                          l10n.noBookmarks,
                          style: AppTypography.titleMedium.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        AppSpacing.gapS,
                        Text(
                          l10n.bookmarksDesc,
                          style: AppTypography.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final b = bookmarks[index];
                      return Dismissible(
                        key: Key(b.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: AppSpacing.l),
                          color: theme.colorScheme.error,
                          child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          ref.read(bookmarksProvider.notifier).deleteBookmark(b.id);
                        },
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(AppSpacing.s),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppSpacing.s),
                            ),
                            child: Icon(Icons.bookmark_rounded, color: theme.colorScheme.primary),
                          ),
                          title: Text(b.documentTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${l10n.completedPercent((b.progress * 100).toInt())} • ${formatRelativeTime(b.createdAt)}'),
                              if (b.previewText != null && b.previewText!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    '"${b.previewText}"',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.bodySmall.copyWith(fontStyle: FontStyle.italic),
                                  ),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () {
                              ref.read(bookmarksProvider.notifier).deleteBookmark(b.id);
                            },
                          ),
                          isThreeLine: b.previewText != null && b.previewText!.isNotEmpty,
                          onTap: () {
                            final recents = ref.read(recentDocumentsProvider).value ?? [];
                            final recent = recents.where((e) => e.id == b.documentId).firstOrNull;
                            if (recent != null) {
                              final doc = recent.toStudyDocument();
                              ref.read(currentDocumentProvider.notifier).state = doc;
                              
                              // Update recent documents so ReaderScreen picks up the exact offset
                              ref.read(recentDocumentsProvider.notifier).addToRecent(
                                RecentDocument.fromStudyDocument(
                                  doc,
                                  progress: b.progress,
                                  scrollOffset: b.scrollOffset,
                                )
                              );
                              context.pushNamed('reader');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Document not found in library')),
                              );
                            }
                          },
                        ),
                      );
                    },
                    childCount: bookmarks.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            error: (e, _) => SliverFillRemaining(child: Center(child: Text('Error: $e'))),
          ),
        ],
      ),
    );
  }
}
