import 'package:flutter_tts/flutter_tts.dart';
import 'package:study_voice/core/services/tts/tts_service.dart';

class TtsServiceImpl implements TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  @override
  Future<void> initialize() async {
    await _flutterTts.setSharedInstance(true);
    await _flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker
        ],
        IosTextToSpeechAudioMode.defaultMode
    );
  }

  @override
  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    final result = await _flutterTts.speak(text);
    if (result == 0) {
      throw Exception('TTS Engine failed to speak the text.');
    }
  }

  @override
  Future<void> pause() async {
    await _flutterTts.pause();
  }

  @override
  Future<void> resume() async {
    // Handled via state machine in Repository
  }

  @override
  Future<void> stop() async {
    await _flutterTts.stop();
  }

  @override
  Future<void> setRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }

  @override
  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }

  @override
  Future<void> setVolume(double volume) async {
    await _flutterTts.setVolume(volume);
  }

  @override
  Future<void> setLanguage(String language) async {
    await _flutterTts.setLanguage(language);
  }

  @override
  Future<bool> isSpeaking() async {
    return false; 
  }

  @override
  void dispose() {
    _flutterTts.stop();
  }

  void setStartHandler(Function() handler) => _flutterTts.setStartHandler(handler);
  void setCompletionHandler(Function() handler) => _flutterTts.setCompletionHandler(handler);
  void setPauseHandler(Function() handler) => _flutterTts.setPauseHandler(handler);
  void setContinueHandler(Function() handler) => _flutterTts.setContinueHandler(handler);
  void setErrorHandler(Function(dynamic) handler) => _flutterTts.setErrorHandler(handler);
}
