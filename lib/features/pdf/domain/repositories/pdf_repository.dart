import 'package:study_voice/features/pdf/domain/entities/pdf_document.dart';

abstract class PdfRepository {
  Future<PdfDocument?> importPdf();
}
