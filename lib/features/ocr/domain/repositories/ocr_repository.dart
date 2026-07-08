import 'package:study_voice/features/pdf/domain/entities/study_document.dart';

abstract class OcrRepository {
  Future<StudyDocument?> processImage({
    required bool fromCamera,
    required String documentName,
  });
}
