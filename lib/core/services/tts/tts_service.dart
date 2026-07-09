/// Interface for handling Text-to-Speech (TTS) operations.
abstract class TtsService {
  /// Initializes the TTS engine.
  Future<void> initialize();

  /// Starts speaking the provided [text].
  Future<void> speak(String text);

  /// Pauses the current speech.
  Future<void> pause();

  /// Resumes the paused speech.
  Future<void> resume();

  /// Stops the speech completely.
  Future<void> stop();

  /// Sets the speech rate. Usually between 0.0 and 1.0.
  Future<void> setRate(double rate);

  /// Sets the speech pitch. Usually between 0.5 and 2.0.
  Future<void> setPitch(double pitch);

  /// Sets the speech volume. Usually between 0.0 and 1.0.
  Future<void> setVolume(double volume);

  /// Sets the speech language (e.g., 'en-US', 'ta-IN').
  Future<void> setLanguage(String language);

  /// Checks if the engine is currently speaking.
  Future<bool> isSpeaking();

  /// Disposes of any resources held by the service.
  void dispose();
}
