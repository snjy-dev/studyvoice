import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/features/pdf/domain/entities/study_document.dart';
import 'package:study_voice/features/reader/data/repositories/reader_repository_impl.dart';
import 'package:study_voice/features/reader/domain/entities/reader_preferences.dart';
import 'package:study_voice/features/reader/domain/repositories/reader_repository.dart';
import 'package:study_voice/features/tts/presentation/providers/tts_provider.dart';

final currentDocumentProvider = StateProvider<StudyDocument?>((ref) => null);

final readerRepositoryProvider = Provider<ReaderRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ReaderRepositoryImpl(storage);
});

final readerPreferencesProvider = StateNotifierProvider<ReaderPreferencesNotifier, ReaderPreferences>((ref) {
  final repository = ref.watch(readerRepositoryProvider);
  return ReaderPreferencesNotifier(repository);
});

class ReaderPreferencesNotifier extends StateNotifier<ReaderPreferences> {
  final ReaderRepository _repository;

  ReaderPreferencesNotifier(this._repository) : super(const ReaderPreferences()) {
    _load();
  }

  Future<void> _load() async {
    state = await _repository.loadPreferences();
  }

  Future<void> updatePreferences(ReaderPreferences preferences) async {
    state = preferences;
    await _repository.savePreferences(state);
  }

  void setFontSize(double size) => updatePreferences(state.copyWith(fontSize: size));
  void setLineHeight(double height) => updatePreferences(state.copyWith(lineHeight: height));
  void setLetterSpacing(double spacing) => updatePreferences(state.copyWith(letterSpacing: spacing));
  void setParagraphSpacing(double spacing) => updatePreferences(state.copyWith(paragraphSpacing: spacing));
  void setThemeType(ReaderThemeType type) => updatePreferences(state.copyWith(themeType: type));
  void setScrollMode(bool isScroll) => updatePreferences(state.copyWith(isScrollMode: isScroll));
}

final readerUiProvider = StateNotifierProvider<ReaderUiNotifier, ReaderUiState>((ref) {
  return ReaderUiNotifier();
});

class ReaderUiState {
  final bool isImmersive;
  final double progress;

  const ReaderUiState({
    this.isImmersive = false,
    this.progress = 0.0,
  });

  ReaderUiState copyWith({
    bool? isImmersive,
    double? progress,
  }) {
    return ReaderUiState(
      isImmersive: isImmersive ?? this.isImmersive,
      progress: progress ?? this.progress,
    );
  }
}

class ReaderUiNotifier extends StateNotifier<ReaderUiState> {
  ReaderUiNotifier() : super(const ReaderUiState());

  void toggleImmersive() {
    state = state.copyWith(isImmersive: !state.isImmersive);
  }

  void setImmersive(bool immersive) {
    state = state.copyWith(isImmersive: immersive);
  }

  void setProgress(double progress) {
    state = state.copyWith(progress: progress);
  }
}
