import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/core/services/pdf/pdf_service_impl.dart';
import 'package:study_voice/features/pdf/data/repositories/pdf_repository_impl.dart';
import 'package:study_voice/features/pdf/domain/entities/study_pdf.dart';
import 'package:study_voice/features/pdf/domain/repositories/pdf_repository.dart';

final pdfServiceProvider = Provider((ref) => PdfServiceImpl());

final pdfRepositoryProvider = Provider<PdfRepository>((ref) {
  final pdfService = ref.watch(pdfServiceProvider);
  return PdfRepositoryImpl(pdfService);
});

final pdfImportProvider = StateNotifierProvider<PdfImportNotifier, AsyncValue<StudyPdf?>>((ref) {
  final repository = ref.watch(pdfRepositoryProvider);
  return PdfImportNotifier(repository);
});

class PdfImportNotifier extends StateNotifier<AsyncValue<StudyPdf?>> {
  final PdfRepository _repository;

  PdfImportNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> importAndParse() async {
    state = const AsyncValue.loading();
    try {
      final partialDoc = await _repository.pickAndValidatePdf();
      
      if (partialDoc == null) {
        state = const AsyncValue.data(null);
        return;
      }

      final fullDoc = await _repository.extractPdfText(File(partialDoc.path), partialDoc);
      
      state = AsyncValue.data(fullDoc);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
