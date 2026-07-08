import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study_voice/core/theme/app_radius.dart';
import 'package:study_voice/core/widgets/feature_tile.dart';
import 'package:study_voice/features/pdf/presentation/providers/pdf_provider.dart';
import 'package:study_voice/features/reader/presentation/providers/reader_provider.dart';
import 'package:study_voice/l10n/app_localizations.dart';

class PdfImportButton extends ConsumerWidget {
  const PdfImportButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(pdfImportProvider);

    ref.listen(pdfImportProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString().replaceAll('Exception: ', '')),
              behavior: SnackBarBehavior.floating,
            ),
          );
          ref.read(pdfImportProvider.notifier).reset();
        },
        data: (doc) {
          if (doc != null) {
            // Set as current document and navigate
            ref.read(currentDocumentProvider.notifier).state = doc;
            context.pushNamed('reader');
            ref.read(pdfImportProvider.notifier).reset();
          }
        },
      );
    });

    return Stack(
      children: [
        FeatureTile(
          icon: Icons.picture_as_pdf_rounded,
          title: l10n.openPdf,
          subtitle: l10n.localStorage,
          onTap: state.isLoading 
            ? () {} 
            : () => ref.read(pdfImportProvider.notifier).importAndParse(),
        ),
        if (state.isLoading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.05),
                borderRadius: AppRadius.large,
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
