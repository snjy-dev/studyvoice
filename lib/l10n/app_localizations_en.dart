// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'StudyVoice';

  @override
  String get continueReading => 'Continue Reading';

  @override
  String get openPdf => 'Open PDF';

  @override
  String get scanImage => 'Scan Image';

  @override
  String get pasteText => 'Paste Text';

  @override
  String get settings => 'Settings';

  @override
  String get history => 'History';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get favorites => 'Favorites';

  @override
  String get recentDocuments => 'Recent Documents';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get welcome => 'Welcome';

  @override
  String get studySubtitle => 'Study smarter with AI-powered offline reading.';

  @override
  String get seeAll => 'See All';

  @override
  String get noRecentDocs => 'No Recent Documents';

  @override
  String get recentDocsDesc => 'Your recently opened files will appear here.';

  @override
  String get noFavorites => 'No Favorites';

  @override
  String get favoritesDesc =>
      'Mark documents as favorites to find them quickly.';

  @override
  String get noActiveSession => 'No active session';

  @override
  String get activeSessionDesc => 'Pick up where you left off.';

  @override
  String get startReading => 'Start Reading';

  @override
  String get localStorage => 'Local storage';

  @override
  String get captureAndRead => 'Capture & read';

  @override
  String get fromClipboard => 'From clipboard';

  @override
  String get pastActivity => 'Past activity';

  @override
  String get savedItems => 'Saved items';

  @override
  String get pageMarkers => 'Page markers';

  @override
  String get noDocumentLoaded => 'No document loaded';

  @override
  String pagesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Pages',
      one: '1 Page',
    );
    return '$_temp0';
  }

  @override
  String wordsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Words',
      one: '1 Word',
    );
    return '$_temp0';
  }

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get selectSource => 'Select Image Source';

  @override
  String get ocrNoText =>
      'No text detected in the image. (Note: Tamil offline OCR is not yet supported)';

  @override
  String get ocrImageEmpty => 'Image file is empty.';

  @override
  String get ocrCameraScan => 'Camera Scan';

  @override
  String get ocrGalleryImage => 'Gallery Image';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get stop => 'Stop';

  @override
  String get resume => 'Resume';

  @override
  String get speechRate => 'Speech Rate';

  @override
  String get pitch => 'Pitch';

  @override
  String get volume => 'Volume';

  @override
  String get voiceLanguage => 'Voice Language';

  @override
  String ttsError(Object error) {
    return 'TTS Error: $error';
  }

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get earlier => 'Earlier';

  @override
  String completedPercent(Object percent) {
    return '$percent% completed';
  }

  @override
  String get noBookmarks => 'No Bookmarks';

  @override
  String get bookmarksDesc =>
      'Bookmark important pages to easily return to them later.';

  @override
  String get searchDocument => 'Search in document';

  @override
  String get search => 'Search';

  @override
  String get clear => 'Clear';

  @override
  String get noMatchesFound => 'No matches found';

  @override
  String matchCount(Object current, Object total) {
    return '$current of $total';
  }

  @override
  String get pasteFromClipboard => 'Paste from Clipboard';

  @override
  String get textIsEmpty => 'Text is empty or contains only whitespace.';

  @override
  String get defaultPastedTitle => 'Pasted Text';

  @override
  String charactersCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Characters',
      one: '1 Character',
    );
    return '$_temp0';
  }

  @override
  String forwardWords(Object count) {
    return 'Forward $count Words';
  }

  @override
  String rewindWords(Object count) {
    return 'Rewind $count Words';
  }

  @override
  String get theme => 'Theme';

  @override
  String get fontSize => 'Font Size';

  @override
  String get lineHeight => 'Line Height';

  @override
  String get letterSpacing => 'Letter Spacing';

  @override
  String get speechSettings => 'Speech Settings';

  @override
  String get readingSettings => 'Reading Settings';

  @override
  String get applicationSettings => 'Application Settings';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get privacy => 'Privacy Policy';

  @override
  String get dailyReminder => 'Daily Reminder';

  @override
  String get enableReminders => 'Enable Reminders';

  @override
  String get testNotification => 'Test Notification';

  @override
  String get notificationDenied => 'Notification permission denied.';

  @override
  String get reminderTime => 'Reminder Time';

  @override
  String get studyReminderTitle => 'Time to study!';

  @override
  String get studyReminderBody => 'Pick up where you left off in StudyVoice.';
}
