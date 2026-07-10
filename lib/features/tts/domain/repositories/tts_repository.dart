class TtsProgress {
  final int startOffset;
  final int endOffset;
  final String word;

  const TtsProgress(this.startOffset, this.endOffset, this.word);
}

abstract class TtsRepository {
  Future<void> speak(String text, {int startOffset = 0});
  Future<void> seek(int absoluteOffset);
  Future<void> seekWords(int wordDelta);
  Future<void> pause();
  Future<void> stop();
  Future<void> setRate(double rate);
  Future<void> setPitch(double pitch);
  Future<void> setVolume(double volume);
  Future<void> setLanguage(String language);
  Future<List<String>> getLanguages();
  
  Stream<TtsState> get stateStream;
  Stream<TtsProgress> get progressStream;
}

enum TtsState { idle, playing, paused, stopped, loading, error }
