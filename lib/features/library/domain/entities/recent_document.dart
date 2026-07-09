import 'package:flutter/foundation.dart';
import 'package:study_voice/features/pdf/domain/entities/study_document.dart';

@immutable
class RecentDocument {
  final String id;
  final String title;
  final String path;
  final DocumentType source;
  final DateTime lastOpened;
  final double progress;
  final double scrollOffset;
  final int wordCount;
  final int characterCount;
  final bool isFavorite;
  final DateTime createdAt;
  final String extractedText;
  final int pageCount;

  const RecentDocument({
    required this.id,
    required this.title,
    required this.path,
    required this.source,
    required this.lastOpened,
    required this.progress,
    required this.scrollOffset,
    required this.wordCount,
    required this.characterCount,
    this.isFavorite = false,
    required this.createdAt,
    required this.extractedText,
    required this.pageCount,
  });

  RecentDocument copyWith({
    String? id,
    String? title,
    String? path,
    DocumentType? source,
    DateTime? lastOpened,
    double? progress,
    double? scrollOffset,
    int? wordCount,
    int? characterCount,
    bool? isFavorite,
    DateTime? createdAt,
    String? extractedText,
    int? pageCount,
  }) {
    return RecentDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      path: path ?? this.path,
      source: source ?? this.source,
      lastOpened: lastOpened ?? this.lastOpened,
      progress: progress ?? this.progress,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      wordCount: wordCount ?? this.wordCount,
      characterCount: characterCount ?? this.characterCount,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      extractedText: extractedText ?? this.extractedText,
      pageCount: pageCount ?? this.pageCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'path': path,
      'source': source.index,
      'lastOpened': lastOpened.millisecondsSinceEpoch,
      'progress': progress,
      'scrollOffset': scrollOffset,
      'wordCount': wordCount,
      'characterCount': characterCount,
      'isFavorite': isFavorite,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'extractedText': extractedText,
      'pageCount': pageCount,
    };
  }

  factory RecentDocument.fromMap(Map<String, dynamic> map) {
    return RecentDocument(
      id: map['id'] as String,
      title: map['title'] as String,
      path: map['path'] as String,
      source: DocumentType.values[map['source'] as int],
      lastOpened: DateTime.fromMillisecondsSinceEpoch(map['lastOpened'] as int),
      progress: (map['progress'] as num).toDouble(),
      scrollOffset: (map['scrollOffset'] as num).toDouble(),
      wordCount: map['wordCount'] as int,
      characterCount: map['characterCount'] as int,
      isFavorite: map['isFavorite'] as bool? ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      extractedText: map['extractedText'] as String? ?? '',
      pageCount: map['pageCount'] as int? ?? 1,
    );
  }

  StudyDocument toStudyDocument() {
    return StudyDocument(
      id: id,
      name: title,
      path: path,
      size: 0, // Size not critical for reader
      pageCount: pageCount,
      extractedText: extractedText,
      wordCount: wordCount,
      characterCount: characterCount,
      createdAt: createdAt,
      type: source,
    );
  }

  factory RecentDocument.fromStudyDocument(StudyDocument doc, {double progress = 0.0, double scrollOffset = 0.0}) {
    return RecentDocument(
      id: doc.id,
      title: doc.name,
      path: doc.path,
      source: doc.type,
      lastOpened: DateTime.now(),
      progress: progress,
      scrollOffset: scrollOffset,
      wordCount: doc.wordCount,
      characterCount: doc.characterCount,
      createdAt: doc.createdAt,
      extractedText: doc.extractedText,
      pageCount: doc.pageCount,
    );
  }
}
