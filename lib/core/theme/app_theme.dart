import 'package:flutter/material.dart';
import 'package:study_voice/core/theme/dark_theme.dart';
import 'package:study_voice/core/theme/light_theme.dart';

/// The central entry point for the StudyVoice application theme engine.
/// 
/// Provides access to [lightTheme] and [darkTheme] configurations.
@immutable
abstract class StudyVoiceTheme {
  const StudyVoiceTheme._();

  /// The light mode [ThemeData] using Design Tokens.
  static ThemeData get lightTheme => lightThemeData;

  /// The dark mode [ThemeData] using Design Tokens.
  static ThemeData get darkTheme => darkThemeData;
}
