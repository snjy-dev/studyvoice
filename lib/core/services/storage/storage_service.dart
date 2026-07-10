/// Interface for handling local persistent storage operations.
abstract class StorageService {
  /// Saves the list of bookmarks, overwriting existing ones.
  Future<void> saveBookmarks(List<Map<String, dynamic>> bookmarks);

  /// Loads all saved bookmarks.
  Future<List<Map<String, dynamic>>> loadBookmarks();

  /// Saves an entry to the history.
  Future<void> saveHistory(Map<String, dynamic> historyEntry);

  /// Loads the history entries.
  Future<List<Map<String, dynamic>>> loadHistory();

  /// Saves the list of favorite document IDs.
  Future<void> saveFavoriteIds(List<String> favoriteIds);

  /// Loads all favorite document IDs.
  Future<List<String>> loadFavoriteIds();

  /// Saves application settings.
  Future<void> saveSettings(Map<String, dynamic> settings);

  /// Loads application settings.
  Future<Map<String, dynamic>> loadSettings();

  /// Saves general app settings (notifications, language).
  Future<void> saveAppSettings(Map<String, dynamic> settings);

  /// Loads general app settings.
  Future<Map<String, dynamic>> loadAppSettings();

  /// Saves the list of recent documents.
  Future<void> saveRecentDocuments(List<Map<String, dynamic>> documents);

  /// Loads the list of recent documents.
  Future<List<Map<String, dynamic>>> loadRecentDocuments();

  /// Clears all stored data.
  Future<void> clear();
}
