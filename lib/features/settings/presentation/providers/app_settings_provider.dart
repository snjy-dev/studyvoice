import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_voice/core/services/notifications/notification_service.dart';
import 'package:study_voice/core/services/storage/storage_service.dart';
import 'package:study_voice/features/tts/presentation/providers/tts_provider.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  service.initialize();
  return service;
});

class AppSettings {
  final bool remindersEnabled;
  final int reminderHour;
  final int reminderMinute;
  final String languageCode;

  const AppSettings({
    this.remindersEnabled = false,
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.languageCode = 'en',
  });

  AppSettings copyWith({
    bool? remindersEnabled,
    int? reminderHour,
    int? reminderMinute,
    String? languageCode,
  }) {
    return AppSettings(
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'remindersEnabled': remindersEnabled,
      'reminderHour': reminderHour,
      'reminderMinute': reminderMinute,
      'languageCode': languageCode,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      remindersEnabled: map['remindersEnabled'] as bool? ?? false,
      reminderHour: map['reminderHour'] as int? ?? 20,
      reminderMinute: map['reminderMinute'] as int? ?? 0,
      languageCode: map['languageCode'] as String? ?? 'en',
    );
  }
}

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return AppSettingsNotifier(storage, notificationService);
});

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final StorageService _storage;
  final NotificationService _notificationService;

  AppSettingsNotifier(this._storage, this._notificationService) : super(const AppSettings()) {
    _load();
  }

  Future<void> _load() async {
    final map = await _storage.loadAppSettings();
    if (map.isNotEmpty) {
      state = AppSettings.fromMap(map);
    }
  }

  Future<void> _save() async {
    await _storage.saveAppSettings(state.toMap());
  }

  Future<void> toggleReminders(bool enabled, String title, String body) async {
    if (enabled) {
      final granted = await _notificationService.requestPermission();
      if (!granted) {
        throw Exception('Permission denied');
      }
      await _notificationService.scheduleDailyReminder(
        state.reminderHour, 
        state.reminderMinute,
        title,
        body,
      );
    } else {
      await _notificationService.cancelAll();
    }
    
    state = state.copyWith(remindersEnabled: enabled);
    await _save();
  }

  Future<void> updateReminderTime(int hour, int minute, String title, String body) async {
    state = state.copyWith(reminderHour: hour, reminderMinute: minute);
    if (state.remindersEnabled) {
      await _notificationService.scheduleDailyReminder(
        hour, 
        minute,
        title,
        body,
      );
    }
    await _save();
  }

  Future<void> setLanguage(String code) async {
    state = state.copyWith(languageCode: code);
    await _save();
  }
}
