import 'dart:io';
import 'package:study_voice/features/pdf/domain/entities/study_document.dart';

abstract class PdfRepository {
  Future<StudyDocument?> pickAndValidatePdf();
  Future<StudyDocument> extractPdfText(File file, StudyDocument partialDoc);
}
