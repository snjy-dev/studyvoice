import 'package:flutter/foundation.dart';

@immutable
class PdfDocument {
  final String id;
  final String name;
  final String path;
  final int size;
  final int? pageCount;
  final DateTime createdAt;

  const PdfDocument({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    this.pageCount,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfDocument &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
