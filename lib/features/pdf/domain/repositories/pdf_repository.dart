import 'dart:io';
import 'package:study_voice/features/pdf/domain/entities/study_pdf.dart';

abstract class PdfRepository {
  Future<StudyPdf?> pickAndValidatePdf();
  Future<StudyPdf> extractPdfText(File file, StudyPdf partialDoc);
}
