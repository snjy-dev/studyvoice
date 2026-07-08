import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/core/theme/app_spacing.dart';
import 'package:study_voice/core/theme/app_typography.dart';
import 'package:study_voice/core/widgets/app_scaffold.dart';
import 'package:study_voice/features/reader/presentation/providers/reader_provider.dart';
import 'package:study_voice/l10n/app_localizations.dart';

class ReaderScreen extends ConsumerWidget {
  const ReaderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pdf = ref.watch(currentPdfProvider);
    final l10n = AppLocalizations.of(context)!;

    if (pdf == null) {
      return AppScaffold(
        body: Center(
          child: Text(l10n.noDocumentLoaded),
        ),
      );
    }

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          pdf.name,
          style: AppTypography.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      applyPadding: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MetadataChip(
                  label: l10n.pagesCount(pdf.pageCount),
                  icon: Icons.pages_rounded,
                ),
                _MetadataChip(
                  label: l10n.wordsCount(pdf.wordCount),
                  icon: Icons.text_fields_rounded,
                ),
              ],
            ),
            AppSpacing.gapL,
            SelectableText(
              pdf.extractedText,
              style: AppTypography.bodyLarge.copyWith(
                height: 1.6,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: AppSpacing.huge),
          ],
        ),
      ),
    );
  }
}

class _MetadataChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _MetadataChip({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.s),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.onSecondaryContainer,
          ),
          AppSpacing.gapS,
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
