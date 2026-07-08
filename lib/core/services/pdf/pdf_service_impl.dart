import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;
import 'package:study_voice/core/services/pdf/pdf_service.dart';

class PdfServiceImpl implements PdfService {
  @override
  Future<File?> pickPdf() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  @override
  Future<String> extractText(File pdfFile) async {
    final bytes = await pdfFile.readAsBytes();
    sf.PdfDocument? document;
    try {
      document = sf.PdfDocument(inputBytes: bytes);
      
      final extractor = sf.PdfTextExtractor(document);
      return extractor.extractText();
    } catch (e) {
      if (e.toString().contains('password') || e.toString().contains('encrypted')) {
        throw Exception('This PDF is encrypted and cannot be read.');
      }
      throw Exception('Failed to extract text from PDF: $e');
    } finally {
      document?.dispose();
    }
  }

  @override
  Future<int> getPageCount(File pdfFile) async {
    final bytes = await pdfFile.readAsBytes();
    sf.PdfDocument? document;
    try {
      document = sf.PdfDocument(inputBytes: bytes);
      return document.pages.count;
    } finally {
      document?.dispose();
    }
  }

  @override
  Future<String?> getDocumentTitle(File pdfFile) async {
    final bytes = await pdfFile.readAsBytes();
    sf.PdfDocument? document;
    try {
      document = sf.PdfDocument(inputBytes: bytes);
      return document.documentInformation.title;
    } finally {
      document?.dispose();
    }
  }

  @override
  void dispose() {}
}
