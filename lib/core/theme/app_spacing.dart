import 'package:flutter/material.dart';

/// Design tokens for spacing and layout.
@immutable
abstract class AppSpacing {
  const AppSpacing._();

  static const double xs = 4.0;
  static const double s = 8.0;
  static const double sm = 12.0;
  static const double m = 16.0;
  static const double ml = 20.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
  static const double xxxl = 48.0;
  static const double huge = 64.0;

  // Helper widgets for common gaps
  static const SizedBox gapXs = SizedBox(width: xs, height: xs);
  static const SizedBox gapS = SizedBox(width: s, height: s);
  static const SizedBox gapSm = SizedBox(width: sm, height: sm);
  static const SizedBox gapM = SizedBox(width: m, height: m);
  static const SizedBox gapMl = SizedBox(width: ml, height: ml);
  static const SizedBox gapL = SizedBox(width: l, height: l);
  static const SizedBox gapXl = SizedBox(width: xl, height: xl);
}
