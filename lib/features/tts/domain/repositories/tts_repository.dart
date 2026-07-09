abstract class TtsRepository {
  Future<void> speak(String text);
  Future<void> pause();
  Future<void> stop();
  Future<void> setRate(double rate);
  Future<void> setPitch(double pitch);
  Future<void> setVolume(double volume);
  Future<void> setLanguage(String language);
  Future<List<String>> getLanguages();
  
  Stream<TtsState> get stateStream;
}

enum TtsState { idle, playing, paused, stopped, loading, error }
