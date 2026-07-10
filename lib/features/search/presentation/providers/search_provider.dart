import 'dart:isolate';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/features/search/domain/entities/search_match.dart';

class SearchState {
  final String query;
  final bool isSearchBarVisible;
  final bool isSearching;
  final List<SearchMatch> matches;
  final int currentMatchIndex;

  const SearchState({
    this.query = '',
    this.isSearchBarVisible = false,
    this.isSearching = false,
    this.matches = const [],
    this.currentMatchIndex = 0,
  });

  SearchState copyWith({
    String? query,
    bool? isSearchBarVisible,
    bool? isSearching,
    List<SearchMatch>? matches,
    int? currentMatchIndex,
  }) {
    return SearchState(
      query: query ?? this.query,
      isSearchBarVisible: isSearchBarVisible ?? this.isSearchBarVisible,
      isSearching: isSearching ?? this.isSearching,
      matches: matches ?? this.matches,
      currentMatchIndex: currentMatchIndex ?? this.currentMatchIndex,
    );
  }
}

class SearchNotifier extends Notifier<SearchState> {
  String _lastDocumentText = '';

  @override
  SearchState build() {
    return const SearchState();
  }

  void toggleSearchBar() {
    if (state.isSearchBarVisible) {
      clearSearch();
    }
    state = state.copyWith(isSearchBarVisible: !state.isSearchBarVisible);
  }
  
  void hideSearchBar() {
    if (state.isSearchBarVisible) {
      clearSearch();
      state = state.copyWith(isSearchBarVisible: false);
    }
  }

  void clearSearch() {
    state = state.copyWith(
      query: '',
      isSearching: false,
      matches: [],
      currentMatchIndex: 0,
    );
  }

  Future<void> search(String query, String documentText) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      clearSearch();
      // Keep search bar visible
      state = state.copyWith(isSearchBarVisible: true);
      return;
    }

    if (normalizedQuery == state.query && _lastDocumentText == documentText) {
      return; // Same search, do nothing
    }

    _lastDocumentText = documentText;
    state = state.copyWith(
      query: normalizedQuery,
      isSearching: true,
    );

    // Run search in isolate for performance
    final matches = await Isolate.run(() => _performSearch(documentText, normalizedQuery));

    state = state.copyWith(
      isSearching: false,
      matches: matches,
      currentMatchIndex: 0,
    );
  }

  void nextMatch() {
    if (state.matches.isEmpty) return;
    var nextIndex = state.currentMatchIndex + 1;
    if (nextIndex >= state.matches.length) {
      nextIndex = 0; // Wrap around
    }
    state = state.copyWith(currentMatchIndex: nextIndex);
  }

  void previousMatch() {
    if (state.matches.isEmpty) return;
    var prevIndex = state.currentMatchIndex - 1;
    if (prevIndex < 0) {
      prevIndex = state.matches.length - 1; // Wrap around
    }
    state = state.copyWith(currentMatchIndex: prevIndex);
  }

  static List<SearchMatch> _performSearch(String documentText, String query) {
    if (query.isEmpty) return [];
    
    // Normalize string by ignoring smart quotes or multiple spaces if needed,
    // but regex matching allows us to find exact substrings.
    // We replace multiple spaces with single space in query just in case,
    // but wait, if the document has multiple spaces, a normalized query might not match it easily.
    // Using RegExp with a pattern that allows arbitrary whitespace between words is Unicode-safe and robust.
    
    // Escape regex characters in query
    final escapedQuery = RegExp.escape(query);
    // Replace spaces with a pattern that matches any whitespace character (including newlines) one or more times
    final patternString = escapedQuery.replaceAll(RegExp(r'\s+'), r'\s+');
    
    final regex = RegExp(patternString, caseSensitive: false, unicode: true);
    final matches = regex.allMatches(documentText);
    
    final results = <SearchMatch>[];
    var index = 0;
    for (final match in matches) {
      results.add(
        SearchMatch(
          matchIndex: index++,
          startOffset: match.start,
          endOffset: match.end,
          matchedText: match.group(0) ?? '',
        )
      );
    }
    
    return results;
  }
}

final searchProvider = NotifierProvider<SearchNotifier, SearchState>(() {
  return SearchNotifier();
});
