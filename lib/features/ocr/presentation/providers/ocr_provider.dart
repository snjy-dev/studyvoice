import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/core/services/ocr/ocr_service_impl.dart';
import 'package:study_voice/features/ocr/data/repositories/ocr_repository_impl.dart';
import 'package:study_voice/features/ocr/domain/repositories/ocr_repository.dart';
import 'package:study_voice/features/pdf/domain/entities/study_document.dart';

final ocrServiceProvider = Provider((ref) {
  final service = OcrServiceImpl();
  ref.onDispose(() => service.dispose());
  return service;
});

final ocrRepositoryProvider = Provider<OcrRepository>((ref) {
  final ocrService = ref.watch(ocrServiceProvider);
  return OcrRepositoryImpl(ocrService);
});

final ocrImportProvider = StateNotifierProvider<OcrImportNotifier, AsyncValue<StudyDocument?>>((ref) {
  final repository = ref.watch(ocrRepositoryProvider);
  return OcrImportNotifier(repository);
});

class OcrImportNotifier extends StateNotifier<AsyncValue<StudyDocument?>> {
  final OcrRepository _repository;

  OcrImportNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> scanImage({
    required bool fromCamera,
    required String documentName,
  }) async {
    state = const AsyncValue.loading();
    try {
      final document = await _repository.processImage(
        fromCamera: fromCamera,
        documentName: documentName,
      );
      state = AsyncValue.data(document);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
