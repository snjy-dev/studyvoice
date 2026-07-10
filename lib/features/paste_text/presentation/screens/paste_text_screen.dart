import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:study_voice/core/theme/app_spacing.dart';
import 'package:study_voice/core/theme/app_typography.dart';
import 'package:study_voice/core/widgets/app_scaffold.dart';
import 'package:study_voice/features/pdf/domain/entities/study_document.dart';
import 'package:study_voice/features/reader/presentation/providers/reader_provider.dart';
import 'package:study_voice/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class PasteTextScreen extends ConsumerStatefulWidget {
  const PasteTextScreen({super.key});

  @override
  ConsumerState<PasteTextScreen> createState() => _PasteTextScreenState();
}

class _PasteTextScreenState extends ConsumerState<PasteTextScreen> {
  final TextEditingController _textController = TextEditingController();
  final _uuid = const Uuid();
  bool _isEmpty = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    _checkClipboard();
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isEmpty = _textController.text.trim().isEmpty;
      if (!_isEmpty) {
        _errorMessage = '';
      }
    });
  }

  Future<void> _checkClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text != null && clipboardData.text!.trim().isNotEmpty) {
      _textController.text = clipboardData.text!;
    }
  }

  void _pasteFromClipboard(AppLocalizations l10n) async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text != null && clipboardData.text!.trim().isNotEmpty) {
      _textController.text = clipboardData.text!;
    } else {
      setState(() {
        _errorMessage = l10n.textIsEmpty;
      });
    }
  }

  void _clearText() {
    _textController.clear();
    setState(() {
      _errorMessage = '';
    });
  }

  void _onContinue(AppLocalizations l10n) {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorMessage = l10n.textIsEmpty;
      });
      return;
    }

    final wordCount = text.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
    final characterCount = text.length;

    // Auto title from first meaningful line
    final lines = text.split('\n').where((l) => l.trim().isNotEmpty).toList();
    final title = lines.isNotEmpty ? lines.first.trim() : l10n.defaultPastedTitle;
    final finalTitle = title.length > 50 ? '${title.substring(0, 47)}...' : title;

    final doc = StudyDocument(
      id: _uuid.v4(),
      name: finalTitle,
      path: 'clipboard://${_uuid.v4()}',
      size: text.codeUnits.length,
      pageCount: (wordCount / 250).ceil().clamp(1, 100000), // Approximate 250 words per page
      extractedText: text,
      wordCount: wordCount,
      characterCount: characterCount,
      createdAt: DateTime.now(),
      type: DocumentType.text,
    );

    ref.read(currentDocumentProvider.notifier).state = doc;
    context.pushReplacementNamed('reader');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final text = _textController.text;
    final wordCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    final characterCount = text.length;

    return AppScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const BackButton(),
                  Expanded(
                    child: Text(
                      l10n.pasteText,
                      style: AppTypography.headlineMedium,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapL,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => _pasteFromClipboard(l10n),
                    icon: const Icon(Icons.content_paste_rounded),
                    label: Text(l10n.pasteFromClipboard),
                  ),
                  if (!_isEmpty)
                    TextButton.icon(
                      onPressed: _clearText,
                      icon: const Icon(Icons.clear_all_rounded),
                      label: Text(l10n.clear),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                      ),
                    ),
                ],
              ),
              AppSpacing.gapS,
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.m),
                    border: Border.all(
                      color: _errorMessage.isNotEmpty
                          ? theme.colorScheme.error
                          : Colors.transparent,
                    ),
                  ),
                  child: TextField(
                    controller: _textController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: l10n.pasteFromClipboard,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(AppSpacing.m),
                    ),
                  ),
                ),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.s),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
                  ),
                ),
              AppSpacing.gapM,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${l10n.wordsCount(wordCount)} • ${l10n.charactersCount(characterCount)}',
                    style: AppTypography.labelMedium.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapL,
              FilledButton.icon(
                onPressed: _isEmpty ? null : () => _onContinue(l10n),
                icon: const Icon(Icons.menu_book_rounded),
                label: Text(l10n.continueReading),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(AppSpacing.m),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
