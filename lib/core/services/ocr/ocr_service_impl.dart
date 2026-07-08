import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_voice/core/services/ocr/ocr_service.dart';

class OcrServiceImpl implements OcrService {
  final ImagePicker _picker = ImagePicker();
  late TextRecognizer _textRecognizer;

  OcrServiceImpl() {
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  @override
  Future<File?> pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    return image != null ? File(image.path) : null;
  }

  @override
  Future<File?> scanCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    return image != null ? File(image.path) : null;
  }

  @override
  Future<String> extractText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      if (recognizedText.text.trim().isEmpty) {
        throw Exception('ocrNoText');
      }
      
      return recognizedText.text;
    } catch (e) {
      if (e.toString().contains('ocrNoText')) rethrow;
      throw Exception('Failed to recognize text: $e');
    }
  }

  @override
  void dispose() {
    _textRecognizer.close();
  }
}
