// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'ஸ்டடிவாய்ஸ்';

  @override
  String get continueReading => 'தொடர்ந்து படிக்கவும்';

  @override
  String get openPdf => 'PDF திறக்கவும்';

  @override
  String get scanImage => 'படத்தை ஸ்கேன் செய்யவும்';

  @override
  String get pasteText => 'உரையை ஒட்டவும்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get history => 'வரலாறு';

  @override
  String get bookmarks => 'புக்மார்க்கள்';

  @override
  String get favorites => 'பிடித்தவை';

  @override
  String get recentDocuments => 'சமீபத்திய ஆவணங்கள்';

  @override
  String get language => 'மொழி';

  @override
  String get darkMode => 'இருண்ட பயன்முறை';

  @override
  String get lightMode => 'ஒளி பயன்முறை';

  @override
  String get cancel => 'ரத்து செய்';

  @override
  String get save => 'சேமி';

  @override
  String get done => 'முடிந்தது';

  @override
  String get goodMorning => 'காலை வணக்கம்';

  @override
  String get goodAfternoon => 'மதிய வணக்கம்';

  @override
  String get goodEvening => 'மாலை வணக்கம்';

  @override
  String get welcome => 'வரவேற்கிறோம்';

  @override
  String get studySubtitle =>
      'AI-இயங்கும் ஆஃப்லைன் வாசிப்புடன் புத்திசாலித்தனமாகப் படிக்கவும்.';

  @override
  String get seeAll => 'அனைத்தையும் பார்';

  @override
  String get noRecentDocs => 'சமீபத்திய ஆவணங்கள் இல்லை';

  @override
  String get recentDocsDesc =>
      'நீங்கள் சமீபத்தில் திறந்த கோப்புகள் இங்கே தோன்றும்.';

  @override
  String get noFavorites => 'பிடித்தவை இல்லை';

  @override
  String get favoritesDesc =>
      'ஆவணங்களை விரைவாகக் கண்டறிய அவற்றைப் பிடித்தவையாகக் குறிக்கவும்.';

  @override
  String get noActiveSession => 'செயலில் அமர்வு இல்லை';

  @override
  String get activeSessionDesc => 'நீங்கள் விட்ட இடத்திலிருந்து தொடரவும்.';

  @override
  String get startReading => 'படிக்கத் தொடங்குங்கள்';

  @override
  String get localStorage => 'உள்ளூர் சேமிப்பு';

  @override
  String get captureAndRead => 'பிடித்து படிக்கவும்';

  @override
  String get fromClipboard => 'ஒட்டப்பட்ட உரை';

  @override
  String get pastActivity => 'கடந்த வரலாறு';

  @override
  String get savedItems => 'சேமித்தவை';

  @override
  String get pageMarkers => 'பக்க அடையாளங்கள்';

  @override
  String get noDocumentLoaded => 'ஆவணம் ஏற்றப்படவில்லை';

  @override
  String pagesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பக்கங்கள்',
      one: '1 பக்கம்',
    );
    return '$_temp0';
  }

  @override
  String wordsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count சொற்கள்',
      one: '1 சொல்',
    );
    return '$_temp0';
  }

  @override
  String get camera => 'கேமரா';

  @override
  String get gallery => 'கேலரி';

  @override
  String get selectSource => 'படத்தின் மூலத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get ocrNoText =>
      'படத்தில் உரை எதுவும் கண்டறியப்படவில்லை. (குறிப்பு: தமிழ் ஆஃப்லைன் OCR தற்போது ஆதரிக்கப்படவில்லை)';

  @override
  String get ocrImageEmpty => 'படக் கோப்பு காலியாக உள்ளது.';

  @override
  String get ocrCameraScan => 'கேமரா ஸ்கேன்';

  @override
  String get ocrGalleryImage => 'கேலரி படம்';

  @override
  String get play => 'இயக்கு';

  @override
  String get pause => 'நிறுத்து';

  @override
  String get stop => 'முடி';

  @override
  String get resume => 'தொடர்';

  @override
  String get speechRate => 'பேச்சு வேகம்';

  @override
  String get pitch => 'சுருதி';

  @override
  String get volume => 'ஒலி அளவு';

  @override
  String get voiceLanguage => 'குரல் மொழி';

  @override
  String ttsError(Object error) {
    return 'TTS பிழை: $error';
  }

  @override
  String get today => 'இன்று';

  @override
  String get yesterday => 'நேற்று';

  @override
  String get earlier => 'முன்பு';

  @override
  String completedPercent(Object percent) {
    return '$percent% முடிந்தது';
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
