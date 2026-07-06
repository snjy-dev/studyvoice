import 'dart:io';

/// Interface for handling Optical Character Recognition (OCR) operations.
abstract class OcrService {
  /// Picks an image from the gallery.
  /// 
  /// Returns the picked [File] or null if the operation was cancelled.
  Future<File?> pickImage();

  /// Captures an image using the camera.
  /// 
  /// Returns the captured [File] or null if the operation was cancelled.
  Future<File?> scanCamera();

  /// Extracts text from the provided [imageFile].
  /// 
  /// Returns the extracted [String].
  Future<String> extractText(File imageFile);

  /// Disposes of any resources held by the service.
  void dispose();
}
