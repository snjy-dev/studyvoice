import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study_voice/core/theme/app_radius.dart';
import 'package:study_voice/core/widgets/feature_tile.dart';
import 'package:study_voice/features/ocr/presentation/providers/ocr_provider.dart';
import 'package:study_voice/features/reader/presentation/providers/reader_provider.dart';
import 'package:study_voice/l10n/app_localizations.dart';

class OcrScanButton extends ConsumerWidget {
  const OcrScanButton({super.key});

  void _showSourcePicker(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: Text(l10n.camera),
              onTap: () {
                Navigator.pop(context);
                ref.read(ocrImportProvider.notifier).scanImage(
                  fromCamera: true,
                  documentName: l10n.ocrCameraScan,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text(l10n.gallery),
              onTap: () {
                Navigator.pop(context);
                ref.read(ocrImportProvider.notifier).scanImage(
                  fromCamera: false,
                  documentName: l10n.ocrGalleryImage,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedError(String error, AppLocalizations l10n) {
    if (error.contains('ocrNoText')) return l10n.ocrNoText;
    if (error.contains('ocrImageEmpty')) return l10n.ocrImageEmpty;
    return error;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(ocrImportProvider);

    ref.listen(ocrImportProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getLocalizedError(error.toString(), l10n)),
              behavior: SnackBarBehavior.floating,
            ),
          );
          ref.read(ocrImportProvider.notifier).reset();
        },
        data: (doc) {
          if (doc != null) {
            ref.read(currentDocumentProvider.notifier).state = doc;
            context.pushNamed('reader');
            ref.read(ocrImportProvider.notifier).reset();
          }
        },
      );
    });

    return Stack(
      children: [
        FeatureTile(
          icon: Icons.camera_alt_rounded,
          title: l10n.scanImage,
          subtitle: l10n.captureAndRead,
          onTap: state.isLoading ? () {} : () => _showSourcePicker(context, ref, l10n),
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
