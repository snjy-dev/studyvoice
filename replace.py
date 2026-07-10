import sys

def replace_layout():
    with open('lib/features/reader/presentation/screens/reader_screen.dart', 'r', encoding='utf-8') as f:
        code = f.read()
    
    # Define exact blocks to replace
    old_stack_start = """        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                ref.read(readerUiProvider.notifier).toggleImmersive();
                _hideUiTimer?.cancel();
                _hideUiTimer = null;
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.l,
                  MediaQuery.of(context).padding.top + 80,
                  AppSpacing.l,
                  150,
                ),
                child: SelectableText.rich("""

    new_column_start = """        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Top Bar & Progress
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: uiState.isImmersive ? 0 : null,
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: bgColor.withValues(alpha: 0.9),
                        surfaceTintColor: Colors.transparent,
                        title: Text(
                          doc.name,
                          style: AppTypography.titleMedium.copyWith(color: textColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: BackButton(color: textColor),
                          actions: [
                            IconButton(
                              icon: Icon(Icons.search_rounded, color: textColor),
                              onPressed: () => ref.read(searchProvider.notifier).toggleSearchBar(),
                            ),
                            _AnimatedFavoriteButton(doc: doc, textColor: textColor),
                            _BookmarkButton(doc: doc, textColor: textColor, scrollController: _scrollController),
                            IconButton(
                              icon: Icon(Icons.info_outline_rounded, color: textColor),
                              onPressed: () => _showStats(context, doc, l10n),
                            ),
                          ],
                      ),
                      LinearProgressIndicator(
                        value: uiState.progress,
                        backgroundColor: textColor.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                        minHeight: 2,
                      ),
                      // Search Bar
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: searchState.isSearchBarVisible ? 60 : 0,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Container(
                            height: 60,
                            color: bgColor,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    focusNode: _searchFocus,
                                    style: TextStyle(color: textColor),
                                    decoration: InputDecoration(
                                      hintText: l10n.searchDocument,
                                      hintStyle: TextStyle(color: textColor.withValues(alpha: 0.5)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: textColor.withValues(alpha: 0.05),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                                    ),
                                    onChanged: (val) {
                                      _searchDebounce?.cancel();
                                      _searchDebounce = Timer(const Duration(milliseconds: 250), () {
                                        ref.read(searchProvider.notifier).search(val, doc.extractedText);
                                      });
                                    },
                                  ),
                                ),
                                if (searchState.isSearching) ...[
                                  const SizedBox(width: AppSpacing.s),
                                  SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: textColor)),
                                ] else if (searchState.matches.isNotEmpty) ...[
                                  const SizedBox(width: AppSpacing.s),
                                  Text(
                                    l10n.matchCount(searchState.currentMatchIndex + 1, searchState.matches.length),
                                    style: TextStyle(color: textColor, fontSize: 12),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.keyboard_arrow_up_rounded, color: textColor),
                                    onPressed: () => ref.read(searchProvider.notifier).previousMatch(),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: textColor),
                                    onPressed: () => ref.read(searchProvider.notifier).nextMatch(),
                                  ),
                                ] else if (searchState.query.isNotEmpty) ...[
                                  const SizedBox(width: AppSpacing.s),
                                  Text(l10n.noMatchesFound, style: TextStyle(color: textColor, fontSize: 12)),
                                ],
                                IconButton(
                                  icon: Icon(Icons.close_rounded, color: textColor),
                                  onPressed: () {
                                    _searchController.clear();
                                    ref.read(searchProvider.notifier).hideSearchBar();
                                    _searchFocus.unfocus();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Document
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(readerUiProvider.notifier).toggleImmersive();
                    _hideUiTimer?.cancel();
                    _hideUiTimer = null;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.l),
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      child: SelectableText.rich("""

    old_middle = """                  },
                ),
              ),
            ),

            // Top Bar & Progress
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              top: uiState.isImmersive ? -120 : 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: bgColor.withValues(alpha: 0.9),
                    surfaceTintColor: Colors.transparent,
                    title: Text(
                      doc.name,
                      style: AppTypography.titleMedium.copyWith(color: textColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: BackButton(color: textColor),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.search_rounded, color: textColor),
                          onPressed: () => ref.read(searchProvider.notifier).toggleSearchBar(),
                        ),
                        _AnimatedFavoriteButton(doc: doc, textColor: textColor),
                        _BookmarkButton(doc: doc, textColor: textColor, scrollController: _scrollController),
                        IconButton(
                          icon: Icon(Icons.info_outline_rounded, color: textColor),
                          onPressed: () => _showStats(context, doc, l10n),
                        ),
                      ],
                  ),
                  LinearProgressIndicator(
                    value: uiState.progress,
                    backgroundColor: textColor.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                    minHeight: 2,
                  ),
                  // Search Bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: searchState.isSearchBarVisible ? 60 : 0,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Container(
                        height: 60,
                        color: bgColor,
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocus,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  hintText: l10n.searchDocument,
                                  hintStyle: TextStyle(color: textColor.withValues(alpha: 0.5)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: textColor.withValues(alpha: 0.05),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                                ),
                                onChanged: (val) {
                                  _searchDebounce?.cancel();
                                  _searchDebounce = Timer(const Duration(milliseconds: 250), () {
                                    ref.read(searchProvider.notifier).search(val, doc.extractedText);
                                  });
                                },
                              ),
                            ),
                            if (searchState.isSearching) ...[
                              const SizedBox(width: AppSpacing.s),
                              SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: textColor)),
                            ] else if (searchState.matches.isNotEmpty) ...[
                              const SizedBox(width: AppSpacing.s),
                              Text(
                                l10n.matchCount(searchState.currentMatchIndex + 1, searchState.matches.length),
                                style: TextStyle(color: textColor, fontSize: 12),
                              ),
                              IconButton(
                                icon: Icon(Icons.keyboard_arrow_up_rounded, color: textColor),
                                onPressed: () => ref.read(searchProvider.notifier).previousMatch(),
                              ),
                              IconButton(
                                icon: Icon(Icons.keyboard_arrow_down_rounded, color: textColor),
                                onPressed: () => ref.read(searchProvider.notifier).nextMatch(),
                              ),
                            ] else if (searchState.query.isNotEmpty) ...[
                              const SizedBox(width: AppSpacing.s),
                              Text(l10n.noMatchesFound, style: TextStyle(color: textColor, fontSize: 12)),
                            ],
                            IconButton(
                              icon: Icon(Icons.close_rounded, color: textColor),
                              onPressed: () {
                                _searchController.clear();
                                ref.read(searchProvider.notifier).hideSearchBar();
                                _searchFocus.unfocus();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Control Bar
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              bottom: uiState.isImmersive ? -150 : 0,
              left: 0,
              right: 0,
              child: _PremiumControlBar("""

    new_middle = """                  },
                ),
              ),
            ),
          ),

          // Bottom Control Bar
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: uiState.isImmersive ? 0 : null,
              child: _PremiumControlBar("""

    old_end = """              ),
            ),
          ],
        ),
      ),
    );"""

    new_end = """              ),
            ),
          ),
        ],
      ),
    ),
  );"""

    code = code.replace(old_stack_start, new_column_start)
    code = code.replace(old_middle, new_middle)
    code = code.replace(old_end, new_end)

    with open('lib/features/reader/presentation/screens/reader_screen.dart', 'w', encoding='utf-8') as f:
        f.write(code)

    print("Success")

replace_layout()
