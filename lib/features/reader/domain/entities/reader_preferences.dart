import 'package:flutter/material.dart';

@immutable
class ReaderPreferences {
  final double fontSize;
  final double lineHeight;
  final double letterSpacing;
  final double paragraphSpacing;
  final ReaderThemeType themeType;
  final bool isScrollMode;

  const ReaderPreferences({
    this.fontSize = 16.0,
    this.lineHeight = 1.5,
    this.letterSpacing = 0.0,
    this.paragraphSpacing = 16.0,
    this.themeType = ReaderThemeType.light,
    this.isScrollMode = true,
  });

  ReaderPreferences copyWith({
    double? fontSize,
    double? lineHeight,
    double? letterSpacing,
    double? paragraphSpacing,
    ReaderThemeType? themeType,
    bool? isScrollMode,
  }) {
    return ReaderPreferences(
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
      themeType: themeType ?? this.themeType,
      isScrollMode: isScrollMode ?? this.isScrollMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fontSize': fontSize,
      'lineHeight': lineHeight,
      'letterSpacing': letterSpacing,
      'paragraphSpacing': paragraphSpacing,
      'themeType': themeType.index,
      'isScrollMode': isScrollMode,
    };
  }

  factory ReaderPreferences.fromMap(Map<String, dynamic> map) {
    return ReaderPreferences(
      fontSize: (map['fontSize'] as num?)?.toDouble() ?? 16.0,
      lineHeight: (map['lineHeight'] as num?)?.toDouble() ?? 1.5,
      letterSpacing: (map['letterSpacing'] as num?)?.toDouble() ?? 0.0,
      paragraphSpacing: (map['paragraphSpacing'] as num?)?.toDouble() ?? 16.0,
      themeType: map['themeType'] != null
          ? ReaderThemeType.values[map['themeType'] as int]
          : ReaderThemeType.light,
      isScrollMode: map['isScrollMode'] as bool? ?? true,
    );
  }
}

enum ReaderThemeType { light, sepia, dark, amoled }
