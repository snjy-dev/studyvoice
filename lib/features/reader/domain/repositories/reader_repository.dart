import 'package:study_voice/features/reader/domain/entities/reader_preferences.dart';

abstract class ReaderRepository {
  Future<void> savePreferences(ReaderPreferences preferences);
  Future<ReaderPreferences> loadPreferences();
}
