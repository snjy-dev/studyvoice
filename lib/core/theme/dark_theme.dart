import 'package:flutter/material.dart';
import 'package:study_voice/core/theme/app_colors.dart';
import 'package:study_voice/core/theme/app_radius.dart';
import 'package:study_voice/core/theme/app_spacing.dart';
import 'package:study_voice/core/theme/app_typography.dart';

/// Custom Dark Colors as per requirements
const Color _darkBg = Color(0xFF0F1115);
const Color _darkSurface = Color(0xFF1A1D23);

/// Defines the Dark Theme for StudyVoice using Design Tokens.
final ThemeData darkThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryDark,
    onPrimary: AppColors.onPrimaryDark,
    primaryContainer: AppColors.primaryContainerDark,
    secondary: AppColors.secondaryDark,
    onSecondary: AppColors.onSecondaryDark,
    error: AppColors.errorDark,
    onError: AppColors.onErrorDark,
    surface: _darkSurface,
    onSurface: AppColors.onSurfaceDark,
    onSurfaceVariant: AppColors.dividerDark,
  ),
  scaffoldBackgroundColor: _darkBg,
  
  // Typography
  textTheme: const TextTheme(
    displayLarge: AppTypography.displayLarge,
    displayMedium: AppTypography.displayMedium,
    displaySmall: AppTypography.displaySmall,
    headlineLarge: AppTypography.headlineLarge,
    headlineMedium: AppTypography.headlineMedium,
    headlineSmall: AppTypography.headlineSmall,
    titleLarge: AppTypography.titleLarge,
    titleMedium: AppTypography.titleMedium,
    titleSmall: AppTypography.titleSmall,
    bodyLarge: AppTypography.bodyLarge,
    bodyMedium: AppTypography.bodyMedium,
    bodySmall: AppTypography.bodySmall,
    labelLarge: AppTypography.labelLarge,
    labelMedium: AppTypography.labelMedium,
    labelSmall: AppTypography.labelSmall,
  ).apply(
    bodyColor: AppColors.onSurfaceDark,
    displayColor: AppColors.onSurfaceDark,
  ),

  // Component Themes
  appBarTheme: const AppBarTheme(
    backgroundColor: _darkSurface,
    foregroundColor: AppColors.onSurfaceDark,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: AppTypography.titleLarge,
  ),

  cardTheme: const CardThemeData(
    color: _darkSurface,
    elevation: 0,
    margin: EdgeInsets.all(AppSpacing.s),
    shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.onPrimaryDark,
      textStyle: AppTypography.labelLarge,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m),
    ),
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.onPrimaryDark,
      textStyle: AppTypography.labelLarge,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryDark,
      side: const BorderSide(color: AppColors.primaryDark),
      textStyle: AppTypography.labelLarge,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryDark,
      textStyle: AppTypography.labelLarge,
    ),
  ),

  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: _darkSurface,
    border: OutlineInputBorder(
      borderRadius: AppRadius.medium,
      borderSide: BorderSide(color: AppColors.dividerDark),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.medium,
      borderSide: BorderSide(color: AppColors.dividerDark),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.medium,
      borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
    ),
    contentPadding: EdgeInsets.all(AppSpacing.m),
  ),

  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: _darkSurface,
    indicatorColor: AppColors.primaryContainerDark,
    labelTextStyle: WidgetStateProperty.all(AppTypography.labelMedium),
  ),

  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: _darkSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.onSurfaceDark,
    contentTextStyle: AppTypography.bodyMedium.copyWith(color: _darkBg),
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
  ),

  dialogTheme: const DialogThemeData(
    backgroundColor: _darkSurface,
    titleTextStyle: AppTypography.titleLarge,
    contentTextStyle: AppTypography.bodyMedium,
    shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
  ),

  dividerTheme: const DividerThemeData(
    color: AppColors.dividerDark,
    thickness: 1,
    space: AppSpacing.m,
  ),

  chipTheme: const ChipThemeData(
    backgroundColor: _darkSurface,
    labelStyle: AppTypography.labelMedium,
    shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
  ),
);
