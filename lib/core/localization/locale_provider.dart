import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/core/localization/locale_constants.dart';

/// Provider to manage and listen to the application's locale.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// Notifier to handle locale changes.
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(LocaleConstants.defaultLocale);

  /// Updates the application locale.
  void setLocale(Locale locale) {
    if (LocaleConstants.supportedLocales.contains(locale)) {
      state = locale;
    }
  }
}
