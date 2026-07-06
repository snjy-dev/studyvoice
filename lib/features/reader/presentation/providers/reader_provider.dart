import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/features/pdf/domain/entities/study_pdf.dart';

final currentPdfProvider = StateProvider<StudyPdf?>((ref) => null);
