import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:study_voice/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:study_voice/features/library/domain/entities/recent_document.dart';
import 'package:study_voice/features/library/presentation/providers/library_provider.dart';
import 'package:study_voice/features/tts/presentation/providers/tts_provider.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return FavoritesRepositoryImpl(storage);
});

final favoriteIdsProvider = StateNotifierProvider<FavoritesNotifier, AsyncValue<List<String>>>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return FavoritesNotifier(repository);
});

final favoriteDocumentsProvider = Provider<List<RecentDocument>>((ref) {
  final favoriteIds = ref.watch(favoriteIdsProvider).value ?? [];
  final recentDocs = ref.watch(recentDocumentsProvider).value ?? [];
  
  // Filter recent docs by favorite IDs
  // Since we rely on RecentDocuments for metadata, if a document was deleted from recent, 
  // it might not appear here, but we never explicitly clear recent documents except via history delete.
  final favorites = recentDocs.where((doc) => favoriteIds.contains(doc.id)).toList();
  return favorites;
});

class FavoritesNotifier extends StateNotifier<AsyncValue<List<String>>> {
  final FavoritesRepository _repository;

  FavoritesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadFavoriteIds();
  }

  Future<void> loadFavoriteIds() async {
    state = const AsyncValue.loading();
    try {
      final ids = await _repository.getFavoriteIds();
      state = AsyncValue.data(ids);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleFavorite(String documentId) async {
    final currentIds = state.value ?? [];
    List<String> newIds;
    if (currentIds.contains(documentId)) {
      newIds = currentIds.where((id) => id != documentId).toList();
    } else {
      newIds = [documentId, ...currentIds];
    }
    
    state = AsyncValue.data(newIds);
    try {
      await _repository.saveFavoriteIds(newIds);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  bool isFavorite(String documentId) {
    final currentIds = state.value ?? [];
    return currentIds.contains(documentId);
  }
}
