import 'package:flutter/material.dart';

/// Design tokens for application colors.
/// 
/// Follows Material 3 color system naming conventions.
@immutable
abstract class AppColors {
  const AppColors._();

  // Brand Colors - Light
  static const Color primaryLight = Color(0xFF6750A4);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFFEADDFF);
  
  static const Color secondaryLight = Color(0xFF625B71);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  
  static const Color backgroundLight = Color(0xFFFEF7FF);
  static const Color onBackgroundLight = Color(0xFF1D1B20);
  static const Color surfaceLight = Color(0xFFFEF7FF);
  static const Color onSurfaceLight = Color(0xFF1D1B20);
  
  static const Color errorLight = Color(0xFFB3261E);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  
  static const Color successLight = Color(0xFF2E7D32);
  static const Color warningLight = Color(0xFFED6C02);
  static const Color dividerLight = Color(0xFFCAC4D0);

  // Brand Colors - Dark
  static const Color primaryDark = Color(0xFFD0BCFF);
  static const Color onPrimaryDark = Color(0xFF381E72);
  static const Color primaryContainerDark = Color(0xFF4F378B);
  
  static const Color secondaryDark = Color(0xFFCCC2DC);
  static const Color onSecondaryDark = Color(0xFF332D41);
  
  static const Color backgroundDark = Color(0xFF141218);
  static const Color onBackgroundDark = Color(0xFFE6E1E5);
  static const Color surfaceDark = Color(0xFF141218);
  static const Color onSurfaceDark = Color(0xFFE6E1E5);
  
  static const Color errorDark = Color(0xFFF2B8B5);
  static const Color onErrorDark = Color(0xFF601410);
  
  static const Color successDark = Color(0xFF81C784);
  static const Color warningDark = Color(0xFFFFB74D);
  static const Color dividerDark = Color(0xFF49454F);
}
