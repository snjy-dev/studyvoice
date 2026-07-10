import 'package:study_voice/features/bookmarks/domain/entities/bookmark.dart';

abstract class BookmarkRepository {
  Future<List<Bookmark>> getBookmarks();
  Future<void> saveBookmarks(List<Bookmark> bookmarks);
}
