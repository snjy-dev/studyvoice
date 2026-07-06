import 'package:flutter/material.dart';
import 'package:study_voice/core/theme/app_colors.dart';
import 'package:study_voice/core/theme/app_radius.dart';
import 'package:study_voice/core/theme/app_spacing.dart';
import 'package:study_voice/core/theme/app_typography.dart';

/// Defines the Light Theme for StudyVoice using Design Tokens.
final ThemeData lightThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryLight,
    onPrimary: AppColors.onPrimaryLight,
    primaryContainer: AppColors.primaryContainerLight,
    secondary: AppColors.secondaryLight,
    onSecondary: AppColors.onSecondaryLight,
    error: AppColors.errorLight,
    onError: AppColors.onErrorLight,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.onSurfaceLight,
    onSurfaceVariant: AppColors.dividerLight,
  ),
  scaffoldBackgroundColor: AppColors.backgroundLight,
  
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
  ),

  // Component Themes
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.surfaceLight,
    foregroundColor: AppColors.onSurfaceLight,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: AppTypography.titleLarge,
  ),

  cardTheme: const CardThemeData(
    color: AppColors.surfaceLight,
    elevation: 1,
    margin: EdgeInsets.all(AppSpacing.s),
    shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.onPrimaryLight,
      textStyle: AppTypography.labelLarge,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m),
    ),
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.onPrimaryLight,
      textStyle: AppTypography.labelLarge,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryLight,
      side: const BorderSide(color: AppColors.primaryLight),
      textStyle: AppTypography.labelLarge,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryLight,
      textStyle: AppTypography.labelLarge,
    ),
  ),

  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceLight,
    border: OutlineInputBorder(
      borderRadius: AppRadius.medium,
      borderSide: BorderSide(color: AppColors.dividerLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.medium,
      borderSide: BorderSide(color: AppColors.dividerLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.medium,
      borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
    ),
    contentPadding: EdgeInsets.all(AppSpacing.m),
  ),

  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.surfaceLight,
    indicatorColor: AppColors.primaryContainerLight,
    labelTextStyle: WidgetStateProperty.all(AppTypography.labelMedium),
  ),

  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.surfaceLight,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.onSurfaceLight,
    contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.surfaceLight),
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
  ),

  dialogTheme: const DialogThemeData(
    backgroundColor: AppColors.surfaceLight,
    titleTextStyle: AppTypography.titleLarge,
    contentTextStyle: AppTypography.bodyMedium,
    shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
  ),

  dividerTheme: const DividerThemeData(
    color: AppColors.dividerLight,
    thickness: 1,
    space: AppSpacing.m,
  ),

  chipTheme: const ChipThemeData(
    backgroundColor: AppColors.surfaceLight,
    labelStyle: AppTypography.labelMedium,
    shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
  ),
);
