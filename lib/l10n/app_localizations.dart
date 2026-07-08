import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ta'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'StudyVoice'**
  String get appTitle;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get continueReading;

  /// No description provided for @openPdf.
  ///
  /// In en, this message translates to:
  /// **'Open PDF'**
  String get openPdf;

  /// No description provided for @scanImage.
  ///
  /// In en, this message translates to:
  /// **'Scan Image'**
  String get scanImage;

  /// No description provided for @pasteText.
  ///
  /// In en, this message translates to:
  /// **'Paste Text'**
  String get pasteText;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @recentDocuments.
  ///
  /// In en, this message translates to:
  /// **'Recent Documents'**
  String get recentDocuments;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @studySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Study smarter with AI-powered offline reading.'**
  String get studySubtitle;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @noRecentDocs.
  ///
  /// In en, this message translates to:
  /// **'No Recent Documents'**
  String get noRecentDocs;

  /// No description provided for @recentDocsDesc.
  ///
  /// In en, this message translates to:
  /// **'Your recently opened files will appear here.'**
  String get recentDocsDesc;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No Favorites'**
  String get noFavorites;

  /// No description provided for @favoritesDesc.
  ///
  /// In en, this message translates to:
  /// **'Mark documents as favorites to find them quickly.'**
  String get favoritesDesc;

  /// No description provided for @noActiveSession.
  ///
  /// In en, this message translates to:
  /// **'No active session'**
  String get noActiveSession;

  /// No description provided for @activeSessionDesc.
  ///
  /// In en, this message translates to:
  /// **'Pick up where you left off.'**
  String get activeSessionDesc;

  /// No description provided for @startReading.
  ///
  /// In en, this message translates to:
  /// **'Start Reading'**
  String get startReading;

  /// No description provided for @localStorage.
  ///
  /// In en, this message translates to:
  /// **'Local storage'**
  String get localStorage;

  /// No description provided for @captureAndRead.
  ///
  /// In en, this message translates to:
  /// **'Capture & read'**
  String get captureAndRead;

  /// No description provided for @fromClipboard.
  ///
  /// In en, this message translates to:
  /// **'From clipboard'**
  String get fromClipboard;

  /// No description provided for @pastActivity.
  ///
  /// In en, this message translates to:
  /// **'Past activity'**
  String get pastActivity;

  /// No description provided for @savedItems.
  ///
  /// In en, this message translates to:
  /// **'Saved items'**
  String get savedItems;

  /// No description provided for @pageMarkers.
  ///
  /// In en, this message translates to:
  /// **'Page markers'**
  String get pageMarkers;

  /// No description provided for @noDocumentLoaded.
  ///
  /// In en, this message translates to:
  /// **'No document loaded'**
  String get noDocumentLoaded;

  /// No description provided for @pagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Page} other{{count} Pages}}'**
  String pagesCount(num count);

  /// No description provided for @wordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Word} other{{count} Words}}'**
  String wordsCount(num count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
