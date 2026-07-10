import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/core/services/storage/storage_service.dart';
import 'package:study_voice/core/services/storage/storage_service_impl.dart';
import 'package:study_voice/core/services/tts/tts_service_impl.dart';
import 'package:study_voice/features/tts/data/repositories/tts_repository_impl.dart';
import 'package:study_voice/features/tts/domain/repositories/tts_repository.dart';

final storageServiceProvider = Provider<StorageService>((ref) => StorageServiceImpl());

final ttsServiceProvider = Provider<TtsServiceImpl>((ref) {
  final service = TtsServiceImpl();
  ref.onDispose(() => service.dispose());
  return service;
});

final ttsRepositoryProvider = Provider<TtsRepository>((ref) {
  final service = ref.watch(ttsServiceProvider);
  return TtsRepositoryImpl(service);
});

final ttsStateProvider = StreamProvider<TtsState>((ref) {
  return ref.watch(ttsRepositoryProvider).stateStream;
});

final ttsProgressProvider = StreamProvider<TtsProgress>((ref) {
  return ref.watch(ttsRepositoryProvider).progressStream;
});

class TtsSettings {
  final double rate;
  final double pitch;
  final double volume;
  final String language;

  const TtsSettings({
    this.rate = 0.5,
    this.pitch = 1.0,
    this.volume = 1.0,
    this.language = 'en-US',
  });

  TtsSettings copyWith({
    double? rate,
    double? pitch,
    double? volume,
    String? language,
  }) {
    return TtsSettings(
      rate: rate ?? this.rate,
      pitch: pitch ?? this.pitch,
      volume: volume ?? this.volume,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toMap() => {
    'rate': rate,
    'pitch': pitch,
    'volume': volume,
    'language': language,
  };

  factory TtsSettings.fromMap(Map<String, dynamic> map) => TtsSettings(
    rate: (map['rate'] as num?)?.toDouble() ?? 0.5,
    pitch: (map['pitch'] as num?)?.toDouble() ?? 1.0,
    volume: (map['volume'] as num?)?.toDouble() ?? 1.0,
    language: (map['language'] as String?) ?? 'en-US',
  );
}

final ttsSettingsProvider = StateNotifierProvider<TtsSettingsNotifier, TtsSettings>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final repo = ref.watch(ttsRepositoryProvider);
  return TtsSettingsNotifier(storage, repo);
});

class TtsSettingsNotifier extends StateNotifier<TtsSettings> {
  final StorageService _storage;
  final TtsRepository _repo;

  TtsSettingsNotifier(this._storage, this._repo) : super(const TtsSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final map = await _storage.loadSettings();
    if (map.isNotEmpty) {
      state = TtsSettings.fromMap(map);
      _applyToRepo();
    }
  }

  void _applyToRepo() {
    unawaited(_repo.setRate(state.rate));
    unawaited(_repo.setPitch(state.pitch));
    unawaited(_repo.setVolume(state.volume));
    unawaited(_repo.setLanguage(state.language));
  }

  Future<void> setRate(double rate) async {
    state = state.copyWith(rate: rate);
    await _repo.setRate(rate);
    await _save();
  }

  Future<void> setPitch(double pitch) async {
    state = state.copyWith(pitch: pitch);
    await _repo.setPitch(pitch);
    await _save();
  }

  Future<void> setVolume(double volume) async {
    state = state.copyWith(volume: volume);
    await _repo.setVolume(volume);
    await _save();
  }

  Future<void> setLanguage(String language) async {
    state = state.copyWith(language: language);
    await _repo.setLanguage(language);
    await _save();
  }

  Future<void> _save() async {
    await _storage.saveSettings(state.toMap());
  }
}
