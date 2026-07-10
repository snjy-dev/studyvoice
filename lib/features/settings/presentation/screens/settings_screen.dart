import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/core/theme/app_spacing.dart';
import 'package:study_voice/core/theme/app_typography.dart';
import 'package:study_voice/core/widgets/app_scaffold.dart';
import 'package:study_voice/features/reader/presentation/providers/reader_provider.dart';
import 'package:study_voice/features/settings/presentation/providers/app_settings_provider.dart';
import 'package:study_voice/features/tts/presentation/providers/tts_provider.dart';
import 'package:study_voice/l10n/app_localizations.dart';
import 'package:study_voice/features/reader/domain/entities/reader_preferences.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final appSettings = ref.watch(appSettingsProvider);
    final readerPrefs = ref.watch(readerPreferencesProvider);
    final ttsSettings = ref.watch(ttsSettingsProvider);

    return AppScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(l10n.settings, style: AppTypography.titleLarge),
            floating: true,
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionTitle(context, l10n.readingSettings),
              _buildThemeSelector(context, ref, readerPrefs, l10n),
              ListTile(
                title: Text(l10n.fontSize),
                subtitle: Slider(
                  value: readerPrefs.fontSize,
                  min: 12.0,
                  max: 48.0,
                  onChanged: (val) => ref.read(readerPreferencesProvider.notifier).setFontSize(val),
                ),
              ),
              ListTile(
                title: Text(l10n.lineHeight),
                subtitle: Slider(
                  value: readerPrefs.lineHeight,
                  min: 1.0,
                  max: 3.0,
                  onChanged: (val) => ref.read(readerPreferencesProvider.notifier).setLineHeight(val),
                ),
              ),
              ListTile(
                title: Text(l10n.letterSpacing),
                subtitle: Slider(
                  value: readerPrefs.letterSpacing,
                  min: -1.0,
                  max: 3.0,
                  onChanged: (val) => ref.read(readerPreferencesProvider.notifier).setLetterSpacing(val),
                ),
              ),
              const Divider(),
              _buildSectionTitle(context, l10n.speechSettings),
              ListTile(
                title: const Text('Voice Language'),
                trailing: DropdownButton<String>(
                  value: ttsSettings.language,
                  items: const [
                    DropdownMenuItem(value: 'en-US', child: Text('English')),
                    DropdownMenuItem(value: 'ta-IN', child: Text('Tamil')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(ttsSettingsProvider.notifier).setLanguage(val);
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Speech Rate'),
                subtitle: Slider(
                  value: ttsSettings.rate,
                  min: 0.1,
                  max: 1.5,
                  onChanged: (val) => ref.read(ttsSettingsProvider.notifier).setRate(val),
                ),
              ),
              ListTile(
                title: const Text('Pitch'),
                subtitle: Slider(
                  value: ttsSettings.pitch,
                  min: 0.5,
                  max: 2.0,
                  onChanged: (val) => ref.read(ttsSettingsProvider.notifier).setPitch(val),
                ),
              ),
              const Divider(),
              _buildSectionTitle(context, l10n.applicationSettings),
              SwitchListTile(
                title: Text(l10n.enableReminders),
                value: appSettings.remindersEnabled,
                onChanged: (val) async {
                  try {
                    await ref.read(appSettingsProvider.notifier).toggleReminders(
                      val,
                      l10n.studyReminderTitle,
                      l10n.studyReminderBody,
                    );
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.notificationDenied)),
                      );
                    }
                  }
                },
              ),
              if (appSettings.remindersEnabled)
                ListTile(
                  title: Text(l10n.reminderTime),
                  subtitle: Text(
                    TimeOfDay(hour: appSettings.reminderHour, minute: appSettings.reminderMinute).format(context),
                  ),
                  trailing: const Icon(Icons.access_time_rounded),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: appSettings.reminderHour, minute: appSettings.reminderMinute),
                    );
                    if (time != null) {
                      await ref.read(appSettingsProvider.notifier).updateReminderTime(
                        time.hour,
                        time.minute,
                        l10n.studyReminderTitle,
                        l10n.studyReminderBody,
                      );
                    }
                  },
                ),
              ListTile(
                title: Text(l10n.testNotification),
                trailing: const Icon(Icons.notifications_active_rounded),
                onTap: () async {
                  await ref.read(notificationServiceProvider).showTestNotification(
                    l10n.studyReminderTitle,
                    l10n.studyReminderBody,
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: Text(l10n.about),
                trailing: const Icon(Icons.info_outline_rounded),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'StudyVoice',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2026 StudyVoice',
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.l, AppSpacing.l, AppSpacing.s),
      child: Text(
        title,
        style: AppTypography.titleMedium.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, WidgetRef ref, ReaderPreferences prefs, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.theme, style: AppTypography.bodyLarge),
          const SizedBox(height: AppSpacing.s),
          Wrap(
            spacing: AppSpacing.s,
            children: ReaderThemeType.values.map((type) {
              final isSelected = prefs.themeType == type;
              return ChoiceChip(
                label: Text(type.name.toUpperCase()),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    ref.read(readerPreferencesProvider.notifier).setThemeType(type);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
