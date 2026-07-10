import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/features/bookmarks/data/repositories/bookmark_repository_impl.dart';
import 'package:study_voice/features/bookmarks/domain/entities/bookmark.dart';
import 'package:study_voice/features/bookmarks/domain/repositories/bookmark_repository.dart';
import 'package:study_voice/features/tts/presentation/providers/tts_provider.dart';
import 'package:uuid/uuid.dart';

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return BookmarkRepositoryImpl(storage);
});

final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, AsyncValue<List<Bookmark>>>((ref) {
  final repository = ref.watch(bookmarkRepositoryProvider);
  return BookmarksNotifier(repository);
});

class BookmarksNotifier extends StateNotifier<AsyncValue<List<Bookmark>>> {
  final BookmarkRepository _repository;

  BookmarksNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    state = const AsyncValue.loading();
    try {
      final bookmarks = await _repository.getBookmarks();
      state = AsyncValue.data(bookmarks);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> addBookmark({
    required String documentId,
    required String documentTitle,
    required double scrollOffset,
    required double progress,
    int? pageNumber,
    String? note,
    String? previewText,
  }) async {
    final currentBookmarks = state.value ?? [];
    
    // Prevent duplicate bookmarks at nearly identical positions (< 2% diff)
    final isDuplicate = currentBookmarks.any((b) => 
        b.documentId == documentId && 
        (b.progress - progress).abs() < 0.02);

    if (isDuplicate) {
      return false; // Indicating it was a duplicate
    }

    final newBookmark = Bookmark(
      id: const Uuid().v4(),
      documentId: documentId,
      documentTitle: documentTitle,
      scrollOffset: scrollOffset,
      progress: progress,
      createdAt: DateTime.now(),
      note: note,
      pageNumber: pageNumber,
      previewText: previewText,
    );

    final updatedList = [newBookmark, ...currentBookmarks];
    state = AsyncValue.data(updatedList);

    try {
      await _repository.saveBookmarks(updatedList);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  Future<void> deleteBookmark(String id) async {
    final currentBookmarks = state.value ?? [];
    final updatedList = currentBookmarks.where((b) => b.id != id).toList();
    state = AsyncValue.data(updatedList);

    try {
      await _repository.saveBookmarks(updatedList);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
