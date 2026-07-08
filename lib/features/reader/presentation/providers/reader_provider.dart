import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/features/pdf/domain/entities/study_document.dart';

final currentDocumentProvider = StateProvider<StudyDocument?>((ref) => null);
