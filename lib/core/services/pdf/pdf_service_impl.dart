import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;
import 'package:study_voice/core/services/pdf/pdf_service.dart';

class PdfServiceImpl implements PdfService {
  @override
  Future<File?> pickPdf() async {
    // Attempting instance access for FilePicker in 11.0.2
    final result = await FilePicker.platform.pickFiles(
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
    return '';
  }

  @override
  Future<int> getPageCount(File pdfFile) async {
    final bytes = await pdfFile.readAsBytes();
    final document = sf.PdfDocument(inputBytes: bytes);
    final count = document.pages.count;
    document.dispose();
    return count;
  }

  @override
  Future<String?> getDocumentTitle(File pdfFile) async {
    final bytes = await pdfFile.readAsBytes();
    final document = sf.PdfDocument(inputBytes: bytes);
    final title = document.documentInformation.title;
    document.dispose();
    return title;
  }

  @override
  void dispose() {}
}
