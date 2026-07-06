import 'dart:io';
import 'package:study_voice/core/services/pdf/pdf_service.dart';
import 'package:study_voice/features/pdf/domain/entities/pdf_document.dart';
import 'package:study_voice/features/pdf/domain/repositories/pdf_repository.dart';

class PdfRepositoryImpl implements PdfRepository {
  final PdfService _pdfService;

  PdfRepositoryImpl(this._pdfService);

  @override
  Future<PdfDocument?> importPdf() async {
    final file = await _pdfService.pickPdf();
    
    if (file == null) return null;

    final length = await file.length();

    // Validation: Reject empty files
    if (length == 0) {
      throw Exception('File is empty');
    }

    // Validation: Reject files over 100 MB
    if (length > 100 * 1024 * 1024) {
      throw Exception('File size exceeds 100 MB');
    }

    // Validation: Reject non-pdf (though picker filters, double check)
    if (!file.path.toLowerCase().endsWith('.pdf')) {
      throw Exception('Selected file is not a PDF');
    }

    final pageCount = await _pdfService.getPageCount(file);
    final name = file.path.split(Platform.pathSeparator).last;

    return PdfDocument(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      path: file.path,
      size: length,
      pageCount: pageCount,
      createdAt: DateTime.now(),
    );
  }
}
