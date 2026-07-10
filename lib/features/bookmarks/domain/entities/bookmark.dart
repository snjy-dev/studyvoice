import 'package:flutter/foundation.dart';

@immutable
class Bookmark {
  final String id;
  final String documentId;
  final String documentTitle;
  final double scrollOffset;
  final double progress;
  final DateTime createdAt;
  final String? note;
  final int? pageNumber;
  final String? previewText;

  const Bookmark({
    required this.id,
    required this.documentId,
    required this.documentTitle,
    required this.scrollOffset,
    required this.progress,
    required this.createdAt,
    this.note,
    this.pageNumber,
    this.previewText,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'documentId': documentId,
      'documentTitle': documentTitle,
      'scrollOffset': scrollOffset,
      'progress': progress,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'note': note,
      'pageNumber': pageNumber,
      'previewText': previewText,
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'] as String,
      documentId: map['documentId'] as String,
      documentTitle: map['documentTitle'] as String,
      scrollOffset: (map['scrollOffset'] as num).toDouble(),
      progress: (map['progress'] as num).toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      note: map['note'] as String?,
      pageNumber: map['pageNumber'] as int?,
      previewText: map['previewText'] as String?,
    );
  }
}
