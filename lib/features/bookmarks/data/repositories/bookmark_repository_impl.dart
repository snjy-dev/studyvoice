import 'package:study_voice/core/services/storage/storage_service.dart';
import 'package:study_voice/features/bookmarks/domain/entities/bookmark.dart';
import 'package:study_voice/features/bookmarks/domain/repositories/bookmark_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final StorageService _storageService;

  BookmarkRepositoryImpl(this._storageService);

  @override
  Future<List<Bookmark>> getBookmarks() async {
    final maps = await _storageService.loadBookmarks();
    final bookmarks = maps.map((map) => Bookmark.fromMap(map)).toList();
    bookmarks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return bookmarks;
  }

  @override
  Future<void> saveBookmarks(List<Bookmark> bookmarks) async {
    final maps = bookmarks.map((b) => b.toMap()).toList();
    await _storageService.saveBookmarks(maps);
  }
}
