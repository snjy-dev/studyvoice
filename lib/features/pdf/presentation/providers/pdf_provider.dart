import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/core/services/pdf/pdf_service_impl.dart';
import 'package:study_voice/features/pdf/data/repositories/pdf_repository_impl.dart';
import 'package:study_voice/features/pdf/domain/entities/pdf_document.dart';
import 'package:study_voice/features/pdf/domain/repositories/pdf_repository.dart';

final pdfServiceProvider = Provider((ref) => PdfServiceImpl());

final pdfRepositoryProvider = Provider<PdfRepository>((ref) {
  final pdfService = ref.watch(pdfServiceProvider);
  return PdfRepositoryImpl(pdfService);
});

final pdfImportProvider = StateNotifierProvider<PdfImportNotifier, AsyncValue<PdfDocument?>>((ref) {
  final repository = ref.watch(pdfRepositoryProvider);
  return PdfImportNotifier(repository);
});

class PdfImportNotifier extends StateNotifier<AsyncValue<PdfDocument?>> {
  final PdfRepository _repository;

  PdfImportNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> importPdf() async {
    state = const AsyncValue.loading();
    try {
      final document = await _repository.importPdf();
      state = AsyncValue.data(document);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
