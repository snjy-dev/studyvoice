import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study_voice/core/localization/locale_provider.dart';
import 'package:study_voice/core/theme/app_theme.dart';
import 'package:study_voice/features/bookmarks/presentation/screens/bookmarks_screen.dart';
import 'package:study_voice/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:study_voice/features/home/presentation/screens/home_screen.dart';
import 'package:study_voice/features/library/presentation/screens/history_screen.dart';
import 'package:study_voice/features/paste_text/presentation/screens/paste_text_screen.dart';
import 'package:study_voice/features/reader/presentation/screens/reader_screen.dart';
import 'package:study_voice/features/settings/presentation/screens/settings_screen.dart';
import 'package:study_voice/l10n/app_localizations.dart';

class StudyVoiceApp extends ConsumerWidget {
  const StudyVoiceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'StudyVoice',
      debugShowCheckedModeBanner: false,
      theme: StudyVoiceTheme.lightTheme,
      darkTheme: StudyVoiceTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      
      // Localization configuration
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }

  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/reader',
        name: 'reader',
        builder: (context, state) => const ReaderScreen(),
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/bookmarks',
        name: 'bookmarks',
        builder: (context, state) => const BookmarksScreen(),
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/paste',
        name: 'paste',
        builder: (context, state) => const PasteTextScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
