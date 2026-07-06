import 'package:flutter/material.dart';

/// Localization constants for the application.
@immutable
abstract class LocaleConstants {
  const LocaleConstants._();

  /// Default application locale.
  static const Locale defaultLocale = Locale('en');

  /// List of supported locales.
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ta'),
  ];
}
