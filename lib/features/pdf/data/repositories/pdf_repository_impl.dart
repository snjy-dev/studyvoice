import 'dart:io';
import 'package:study_voice/core/services/pdf/pdf_service.dart';
import 'package:study_voice/features/pdf/domain/entities/study_document.dart';
import 'package:study_voice/features/pdf/domain/repositories/pdf_repository.dart';

class PdfRepositoryImpl implements PdfRepository {
  final PdfService _pdfService;

  PdfRepositoryImpl(this._pdfService);

  @override
  Future<StudyDocument?> pickAndValidatePdf() async {
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

    // Validation: Reject non-pdf
    if (!file.path.toLowerCase().endsWith('.pdf')) {
      throw Exception('Selected file is not a PDF');
    }

    final pageCount = await _pdfService.getPageCount(file);
    final name = file.path.split(Platform.pathSeparator).last;

    return StudyDocument(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      path: file.path,
      size: length,
      pageCount: pageCount,
      extractedText: '',
      wordCount: 0,
      characterCount: 0,
      createdAt: DateTime.now(),
      type: DocumentType.pdf,
    );
  }

  @override
  Future<StudyDocument> extractPdfText(File file, StudyDocument partialDoc) async {
    final text = await _pdfService.extractText(file);
    
    if (text.trim().isEmpty) {
      throw Exception('No readable text found in this PDF. It might be a scanned document or image-only.');
    }

    // Basic business logic for word and character count
    final wordCount = text.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
    final charCount = text.length;

    return partialDoc.copyWith(
      extractedText: text,
      wordCount: wordCount,
      characterCount: charCount,
    );
  }
}
