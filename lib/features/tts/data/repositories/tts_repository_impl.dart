import 'dart:async';
import 'dart:developer';
import 'package:study_voice/core/services/tts/tts_service_impl.dart';
import 'package:study_voice/features/tts/domain/repositories/tts_repository.dart';

class TtsRepositoryImpl implements TtsRepository {
  final TtsServiceImpl _ttsService;
  final _stateController = StreamController<TtsState>.broadcast();
  TtsState _currentState = TtsState.idle;
  
  Completer<void>? _chunkCompleter;
  int _currentSpeechSessionId = 0;

  TtsRepositoryImpl(this._ttsService) {
    _ttsService.setStartHandler(() {
      _updateState(TtsState.playing);
    });
    _ttsService.setCompletionHandler(() {
      _signalChunkComplete();
    });
    _ttsService.setPauseHandler(() {
      _updateState(TtsState.paused);
      _signalChunkComplete();
    });
    _ttsService.setContinueHandler(() {
      _updateState(TtsState.playing);
    });
    _ttsService.setErrorHandler((message) {
      log('TTS Engine Error: $message');
      _signalChunkComplete();
      _updateState(TtsState.error);
    });
  }

  void _updateState(TtsState state) {
    _currentState = state;
    _stateController.add(state);
  }

  void _signalChunkComplete() {
    if (_chunkCompleter != null && !_chunkCompleter!.isCompleted) {
      _chunkCompleter!.complete();
    }
  }

  String _normalizeText(String text) {
    if (text.isEmpty) return '';
    // 1. Remove control characters
    var normalized = text.replaceAll(RegExp(r'[\r\f\t\v]'), ' ');
    // 2. Normalize paragraph breaks
    normalized = normalized.replaceAll(RegExp(r'\n\s*\n+'), '[[PARAGRAPH]]');
    // 3. Merge single newlines into spaces to avoid unnatural pauses
    normalized = normalized.replaceAll('\n', ' ');
    // 4. Restore paragraph breaks
    normalized = normalized.replaceAll('[[PARAGRAPH]]', '\n\n');
    // 5. Clean up spaces
    normalized = normalized.replaceAll(RegExp(r' +'), ' ');
    return normalized.trim();
  }

  @override
  Future<void> speak(String text) async {
    final sessionId = ++_currentSpeechSessionId;
    
    final cleanText = _normalizeText(text);
    if (cleanText.isEmpty) {
      _updateState(TtsState.idle);
      return;
    }

    // Auto-detect language if it's not set or to ensure correctness
    final isTamil = cleanText.contains(RegExp(r'[\u0B80-\u0BFF]'));
    await _ttsService.setLanguage(isTamil ? 'ta-IN' : 'en-US');

    _updateState(TtsState.loading);
    
    // Split into chunks to ensure engine stability and sequential control
    const maxChunkSize = 3500; 
    final chunks = _splitIntoChunks(cleanText, maxChunkSize);
    
    log('TTS Session $sessionId: Started with ${chunks.length} chunks');

    try {
      for (var i = 0; i < chunks.length; i++) {
        // Abort if a new session started or if explicitly stopped/paused
        if (sessionId != _currentSpeechSessionId || 
            _currentState == TtsState.stopped || 
            _currentState == TtsState.paused) {
          log('TTS Session $sessionId: Terminated at chunk $i (State: $_currentState)');
          return;
        }

        final chunk = chunks[i];
        log('TTS Session $sessionId: Processing chunk ${i + 1}/${chunks.length} (${chunk.length} chars)');
        log('TTS Chunk Snippet: ${chunk.substring(0, chunk.length > 60 ? 60 : chunk.length)}...');

        _chunkCompleter = Completer<void>();
        await _ttsService.speak(chunk);
        
        // Synchronously wait for the native completion callback
        await _chunkCompleter!.future;
      }
      
      if (sessionId == _currentSpeechSessionId && _currentState != TtsState.paused) {
        log('TTS Session $sessionId: All chunks finished');
        _updateState(TtsState.stopped);
      }
    } catch (e, stack) {
      log('TTS Session $sessionId: Fatal Error', error: e, stackTrace: stack);
      _updateState(TtsState.error);
    }
  }

  List<String> _splitIntoChunks(String text, int maxSize) {
    final chunks = <String>[];
    var start = 0;
    while (start < text.length) {
      final end = start + maxSize;
      if (end >= text.length) {
        chunks.add(text.substring(start));
        break;
      }
      
      var lastBreak = text.lastIndexOf(RegExp(r'[.!?\n]'), end);
      if (lastBreak <= start) {
        lastBreak = text.lastIndexOf(' ', end);
      }
      
      if (lastBreak <= start) {
        chunks.add(text.substring(start, end));
        start = end;
      } else {
        chunks.add(text.substring(start, lastBreak + 1));
        start = lastBreak + 1;
      }
    }
    return chunks;
  }

  @override
  Future<void> pause() async {
    log('TTS: Pause requested');
    await _ttsService.pause();
    // State will be updated by the pause handler callback set in constructor
  }

  @override
  Future<void> stop() async {
    log('TTS: Stop requested');
    _currentSpeechSessionId++; // Invalidate running loops immediately
    await _ttsService.stop();
    _updateState(TtsState.stopped);
    _signalChunkComplete();
  }

  @override
  Future<void> setRate(double rate) async {
    await _ttsService.setRate(rate);
  }

  @override
  Future<void> setPitch(double pitch) async {
    await _ttsService.setPitch(pitch);
  }

  @override
  Future<void> setVolume(double volume) async {
    await _ttsService.setVolume(volume);
  }

  @override
  Future<void> setLanguage(String language) async {
    await _ttsService.setLanguage(language);
  }

  @override
  Future<List<String>> getLanguages() async {
    return ['en-US', 'ta-IN'];
  }

  @override
  Stream<TtsState> get stateStream => _stateController.stream;

  TtsState get currentState => _currentState;
}
