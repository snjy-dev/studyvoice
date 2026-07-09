import 'package:study_voice/core/services/storage/storage_service.dart';
import 'package:study_voice/features/reader/domain/entities/reader_preferences.dart';
import 'package:study_voice/features/reader/domain/repositories/reader_repository.dart';

class ReaderRepositoryImpl implements ReaderRepository {
  final StorageService _storageService;
  static const String _storageKey = 'reader_preferences';

  ReaderRepositoryImpl(this._storageService);

  @override
  Future<void> savePreferences(ReaderPreferences preferences) async {
    final settings = await _storageService.loadSettings();
    settings[_storageKey] = preferences.toMap();
    await _storageService.saveSettings(settings);
  }

  @override
  Future<ReaderPreferences> loadPreferences() async {
    final settings = await _storageService.loadSettings();
    final prefMap = settings[_storageKey];
    if (prefMap != null) {
      return ReaderPreferences.fromMap(Map<String, dynamic>.from(prefMap as Map));
    }
    return const ReaderPreferences();
  }
}
