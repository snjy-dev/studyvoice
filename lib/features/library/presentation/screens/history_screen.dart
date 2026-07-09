import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:study_voice/core/theme/app_spacing.dart';
import 'package:study_voice/core/theme/app_typography.dart';
import 'package:study_voice/core/widgets/app_scaffold.dart';
import 'package:study_voice/core/widgets/empty_state.dart';
import 'package:study_voice/features/library/domain/entities/recent_document.dart';
import 'package:study_voice/features/library/presentation/providers/library_provider.dart';
import 'package:study_voice/features/pdf/domain/entities/study_document.dart';
import 'package:study_voice/features/reader/presentation/providers/reader_provider.dart';
import 'package:study_voice/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentDocsAsync = ref.watch(recentDocumentsProvider);
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      appBar: AppBar(
        title: Text(l10n.history),
      ),
      body: recentDocsAsync.when(
        data: (docs) {
          if (docs.isEmpty) {
            return EmptyState(
              icon: Icons.history_rounded,
              title: l10n.noRecentDocs,
              description: l10n.recentDocsDesc,
            );
          }

          final groupedDocs = _groupDocuments(docs, l10n);

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: groupedDocs.length,
            itemBuilder: (context, index) {
              final group = groupedDocs[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.m, AppSpacing.l, AppSpacing.m, AppSpacing.s),
                    child: Text(
                      group.title,
                      style: AppTypography.labelLarge.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...group.items.map((doc) => _HistoryItem(doc: doc)),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  List<_DocumentGroup> _groupDocuments(List<RecentDocument> docs, AppLocalizations l10n) {
    final groups = <_DocumentGroup>[];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayItems = docs.where((d) => d.lastOpened.isAfter(today)).toList();
    final yesterdayItems = docs.where((d) => d.lastOpened.isAfter(yesterday) && d.lastOpened.isBefore(today)).toList();
    final earlierItems = docs.where((d) => d.lastOpened.isBefore(yesterday)).toList();

    if (todayItems.isNotEmpty) groups.add(_DocumentGroup(title: l10n.today, items: todayItems));
    if (yesterdayItems.isNotEmpty) groups.add(_DocumentGroup(title: l10n.yesterday, items: yesterdayItems));
    if (earlierItems.isNotEmpty) groups.add(_DocumentGroup(title: l10n.earlier, items: earlierItems));

    return groups;
  }
}

class _DocumentGroup {
  final String title;
  final List<RecentDocument> items;
  _DocumentGroup({required this.title, required this.items});
}

class _HistoryItem extends ConsumerWidget {
  final RecentDocument doc;
  const _HistoryItem({required this.doc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final timeStr = DateFormat.jm().format(doc.lastOpened);

    return Dismissible(
      key: Key(doc.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.l),
        color: theme.colorScheme.error,
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(recentDocumentsProvider.notifier).deleteDocument(doc.id);
      },
      child: ListTile(
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
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded),
          onPressed: () {
            ref.read(recentDocumentsProvider.notifier).deleteDocument(doc.id);
          },
        ),
        onTap: () {
          ref.read(currentDocumentProvider.notifier).state = doc.toStudyDocument();
          context.pushNamed('reader');
        },
      ),
    );
  }
}
