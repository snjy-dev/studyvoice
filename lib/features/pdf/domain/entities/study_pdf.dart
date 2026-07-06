import 'package:flutter/foundation.dart';

@immutable
class StudyPdf {
  final String id;
  final String name;
  final String path;
  final int size;
  final int pageCount;
  final String extractedText;
  final int wordCount;
  final int characterCount;
  final DateTime createdAt;

  const StudyPdf({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.pageCount,
    required this.extractedText,
    required this.wordCount,
    required this.characterCount,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyPdf &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  StudyPdf copyWith({
    String? id,
    String? name,
    String? path,
    int? size,
    int? pageCount,
    String? extractedText,
    int? wordCount,
    int? characterCount,
    DateTime? createdAt,
  }) {
    return StudyPdf(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      size: size ?? this.size,
      pageCount: pageCount ?? this.pageCount,
      extractedText: extractedText ?? this.extractedText,
      wordCount: wordCount ?? this.wordCount,
      characterCount: characterCount ?? this.characterCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
