import 'dart:io';

/// Interface for handling PDF related operations.
abstract class PdfService {
  /// Picks a PDF file from the local storage.
  /// 
  /// Returns the picked [File] or null if the operation was cancelled.
  Future<File?> pickPdf();

  /// Extracts text content from a given [pdfFile].
  /// 
  /// Returns the extracted [String].
  Future<String> extractText(File pdfFile);

  /// Retrieves the total number of pages in the [pdfFile].
  Future<int> getPageCount(File pdfFile);

  /// Retrieves the title of the [pdfFile].
  Future<String?> getDocumentTitle(File pdfFile);

  /// Disposes of any resources held by the service.
  void dispose();
}
