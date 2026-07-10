import 'package:study_voice/core/services/storage/storage_service.dart';
import 'package:study_voice/features/favorites/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final StorageService _storageService;

  FavoritesRepositoryImpl(this._storageService);

  @override
  Future<List<String>> getFavoriteIds() async {
    return await _storageService.loadFavoriteIds();
  }

  @override
  Future<void> saveFavoriteIds(List<String> favoriteIds) async {
    await _storageService.saveFavoriteIds(favoriteIds);
  }
}
