import 'package:study_voice/features/library/domain/entities/recent_document.dart';

abstract class LibraryRepository {
  Future<List<RecentDocument>> getRecentDocuments();
  Future<void> addOrUpdateRecentDocument(RecentDocument document);
  Future<void> deleteFromHistory(String id);
  Future<void> clearHistory();
}
