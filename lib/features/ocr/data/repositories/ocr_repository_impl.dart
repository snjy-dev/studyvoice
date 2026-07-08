import 'package:study_voice/core/services/ocr/ocr_service.dart';
import 'package:study_voice/features/pdf/domain/entities/study_document.dart';
import 'package:study_voice/features/ocr/domain/repositories/ocr_repository.dart';

class OcrRepositoryImpl implements OcrRepository {
  final OcrService _ocrService;

  OcrRepositoryImpl(this._ocrService);

  @override
  Future<StudyDocument?> processImage({
    required bool fromCamera,
    required String documentName,
  }) async {
    final file = fromCamera 
        ? await _ocrService.scanCamera() 
        : await _ocrService.pickImage();
    
    if (file == null) return null;

    final length = await file.length();
    if (length == 0) throw Exception('ocrImageEmpty');

    final text = await _ocrService.extractText(file);
    
    final wordCount = text.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
    final charCount = text.length;

    return StudyDocument(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '$documentName ${DateTime.now().hour}:${DateTime.now().minute}',
      path: file.path,
      size: length,
      pageCount: 1,
      extractedText: text,
      wordCount: wordCount,
      characterCount: charCount,
      createdAt: DateTime.now(),
      type: DocumentType.image,
    );
  }
}
