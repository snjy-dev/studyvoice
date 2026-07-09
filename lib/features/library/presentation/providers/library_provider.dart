import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/features/library/data/repositories/library_repository_impl.dart';
import 'package:study_voice/features/library/domain/entities/recent_document.dart';
import 'package:study_voice/features/library/domain/repositories/library_repository.dart';
import 'package:study_voice/features/tts/presentation/providers/tts_provider.dart';

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return LibraryRepositoryImpl(storage);
});

final recentDocumentsProvider = StateNotifierProvider<RecentDocumentsNotifier, AsyncValue<List<RecentDocument>>>((ref) {
  final repository = ref.watch(libraryRepositoryProvider);
  return RecentDocumentsNotifier(repository);
});

class RecentDocumentsNotifier extends StateNotifier<AsyncValue<List<RecentDocument>>> {
  final LibraryRepository _repository;

  RecentDocumentsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadRecentDocuments();
  }

  Future<void> loadRecentDocuments() async {
    state = const AsyncValue.loading();
    try {
      final docs = await _repository.getRecentDocuments();
      state = AsyncValue.data(docs);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addToRecent(RecentDocument document) async {
    try {
      await _repository.addOrUpdateRecentDocument(document);
      await loadRecentDocuments();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteDocument(String id) async {
    try {
      await _repository.deleteFromHistory(id);
      await loadRecentDocuments();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
