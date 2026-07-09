/// Interface for handling local persistent storage operations.
abstract class StorageService {
  /// Saves a bookmark entry.
  Future<void> saveBookmark(Map<String, dynamic> bookmark);

  /// Loads all saved bookmarks.
  Future<List<Map<String, dynamic>>> loadBookmarks();

  /// Saves an entry to the history.
  Future<void> saveHistory(Map<String, dynamic> historyEntry);

  /// Loads the history entries.
  Future<List<Map<String, dynamic>>> loadHistory();

  /// Saves a favorite item.
  Future<void> saveFavorites(Map<String, dynamic> favorite);

  /// Loads all favorite items.
  Future<List<Map<String, dynamic>>> loadFavorites();

  /// Saves application settings.
  Future<void> saveSettings(Map<String, dynamic> settings);

  /// Loads application settings.
  Future<Map<String, dynamic>> loadSettings();

  /// Saves the list of recent documents.
  Future<void> saveRecentDocuments(List<Map<String, dynamic>> documents);

  /// Loads the list of recent documents.
  Future<List<Map<String, dynamic>>> loadRecentDocuments();

  /// Clears all stored data.
  Future<void> clear();
}
