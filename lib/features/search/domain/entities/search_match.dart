class SearchMatch {
  final int matchIndex;
  final int startOffset;
  final int endOffset;
  final String matchedText;

  const SearchMatch({
    required this.matchIndex,
    required this.startOffset,
    required this.endOffset,
    required this.matchedText,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SearchMatch &&
      other.matchIndex == matchIndex &&
      other.startOffset == startOffset &&
      other.endOffset == endOffset &&
      other.matchedText == matchedText;
  }

  @override
  int get hashCode {
    return matchIndex.hashCode ^
      startOffset.hashCode ^
      endOffset.hashCode ^
      matchedText.hashCode;
  }
}
