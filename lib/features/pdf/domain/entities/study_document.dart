import 'package:flutter/foundation.dart';

@immutable
class StudyDocument {
  final String id;
  final String name;
  final String path;
  final int size;
  final int pageCount;
  final String extractedText;
  final int wordCount;
  final int characterCount;
  final DateTime createdAt;
  final DocumentType type;

  const StudyDocument({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.pageCount,
    required this.extractedText,
    required this.wordCount,
    required this.characterCount,
    required this.createdAt,
    required this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyDocument &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  StudyDocument copyWith({
    String? id,
    String? name,
    String? path,
    int? size,
    int? pageCount,
    String? extractedText,
    int? wordCount,
    int? characterCount,
    DateTime? createdAt,
    DocumentType? type,
  }) {
    return StudyDocument(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      size: size ?? this.size,
      pageCount: pageCount ?? this.pageCount,
      extractedText: extractedText ?? this.extractedText,
      wordCount: wordCount ?? this.wordCount,
      characterCount: characterCount ?? this.characterCount,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
    );
  }
}

enum DocumentType { pdf, image, text }
