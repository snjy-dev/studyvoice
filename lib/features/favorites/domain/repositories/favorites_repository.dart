abstract class FavoritesRepository {
  Future<List<String>> getFavoriteIds();
  Future<void> saveFavoriteIds(List<String> favoriteIds);
}
