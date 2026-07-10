import 'package:hive_flutter/hive_flutter.dart';
import 'package:study_voice/core/services/storage/storage_service.dart';

class StorageServiceImpl implements StorageService {
  static const String _settingsBox = 'settings';
  static const String _historyBox = 'history';
  static const String _bookmarksBox = 'bookmarks';
  static const String _favoritesBox = 'favorites';
  static const String _recentDocumentsBox = 'recent_documents';
  static const String _appSettingsBox = 'app_settings';

  Future<Box<dynamic>> _getBox(String name) async {
    return await Hive.openBox<dynamic>(name);
  }

  @override
  Future<void> saveRecentDocuments(List<Map<String, dynamic>> documents) async {
    final box = await _getBox(_recentDocumentsBox);
    await box.clear();
    await box.addAll(documents);
  }

  @override
  Future<List<Map<String, dynamic>>> loadRecentDocuments() async {
    final box = await _getBox(_recentDocumentsBox);
    return box.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  @override
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final box = await _getBox(_settingsBox);
    await box.putAll(settings);
  }

  @override
  Future<Map<String, dynamic>> loadSettings() async {
    final box = await _getBox(_settingsBox);
    return Map<String, dynamic>.from(box.toMap());
  }

  @override
  Future<void> saveAppSettings(Map<String, dynamic> settings) async {
    final box = await _getBox(_appSettingsBox);
    await box.putAll(settings);
  }

  @override
  Future<Map<String, dynamic>> loadAppSettings() async {
    final box = await _getBox(_appSettingsBox);
    return Map<String, dynamic>.from(box.toMap());
  }

  @override
  Future<void> saveBookmarks(List<Map<String, dynamic>> bookmarks) async {
    final box = await _getBox(_bookmarksBox);
    await box.clear();
    await box.addAll(bookmarks);
  }

  @override
  Future<List<Map<String, dynamic>>> loadBookmarks() async {
    final box = await _getBox(_bookmarksBox);
    return box.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  @override
  Future<void> saveHistory(Map<String, dynamic> historyEntry) async {
    final box = await _getBox(_historyBox);
    await box.add(historyEntry);
  }

  @override
  Future<List<Map<String, dynamic>>> loadHistory() async {
    final box = await _getBox(_historyBox);
    return box.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  @override
  Future<void> saveFavoriteIds(List<String> favoriteIds) async {
    final box = await _getBox(_favoritesBox);
    await box.clear();
    await box.addAll(favoriteIds);
  }

  @override
  Future<List<String>> loadFavoriteIds() async {
    final box = await _getBox(_favoritesBox);
    return box.values.map((e) => e.toString()).toList();
  }

  @override
  Future<void> clear() async {
    await Hive.deleteBoxFromDisk(_settingsBox);
    await Hive.deleteBoxFromDisk(_historyBox);
    await Hive.deleteBoxFromDisk(_bookmarksBox);
    await Hive.deleteBoxFromDisk(_favoritesBox);
  }
}
