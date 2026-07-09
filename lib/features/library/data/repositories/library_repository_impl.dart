import 'package:study_voice/core/services/storage/storage_service.dart';
import 'package:study_voice/features/library/domain/entities/recent_document.dart';
import 'package:study_voice/features/library/domain/repositories/library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final StorageService _storageService;
  static const int _maxRecentCount = 20;

  LibraryRepositoryImpl(this._storageService);

  @override
  Future<List<RecentDocument>> getRecentDocuments() async {
    final list = await _storageService.loadRecentDocuments();
    final docs = list.map((e) => RecentDocument.fromMap(e)).toList();
    // Sort by lastOpened descending
    docs.sort((a, b) => b.lastOpened.compareTo(a.lastOpened));
    return docs;
  }

  @override
  Future<void> addOrUpdateRecentDocument(RecentDocument document) async {
    final currentDocs = await getRecentDocuments();
    
    // Remove if already exists to move to top
    currentDocs.removeWhere((e) => e.id == document.id);
    
    // Add new document at the beginning
    currentDocs.insert(0, document);

    // Limit to max count
    if (currentDocs.length > _maxRecentCount) {
      currentDocs.removeLast();
    }

    await _storageService.saveRecentDocuments(currentDocs.map((e) => e.toMap()).toList());
  }

  @override
  Future<void> deleteFromHistory(String id) async {
    final currentDocs = await getRecentDocuments();
    currentDocs.removeWhere((e) => e.id == id);
    await _storageService.saveRecentDocuments(currentDocs.map((e) => e.toMap()).toList());
  }

  @override
  Future<void> clearHistory() async {
    await _storageService.saveRecentDocuments([]);
  }
}
