import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freazy/models/reminder.dart';
import 'package:freazy/utils/settings/timeofday_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static const String _remindersKey = 'reminders';
  static const String _notificationKey = 'receiveNotifications';
  static const String _remindersTimeKey = 'remindersTime';

  static Future<void> saveReminderTime(TimeOfDay reminderTime) async {
    final userPreferences = await SharedPreferences.getInstance();

    final String remindersTimeJson = TimeOfDayHelper.toJsonString(reminderTime);

    await userPreferences.setString(_remindersTimeKey, remindersTimeJson);
  }

  static Future<TimeOfDay> loadReminderTime() async {
    final userPreferences = await SharedPreferences.getInstance();
    final String? remindersTimeJson =
        userPreferences.getString(_remindersTimeKey);

    if (remindersTimeJson == null) return TimeOfDay.now();

    final TimeOfDay remindersTime =
        TimeOfDayHelper.fromJsonString(remindersTimeJson);

    return remindersTime;
  }

  static Future<void> saveReminders(List<Reminder> reminders) async {
    final userPreferences = await SharedPreferences.getInstance();

    final String remindersJson =
        jsonEncode(reminders.map((r) => r.toMap()).toList());

    await userPreferences.setString(_remindersKey, remindersJson);
  }

  static Future<List<Reminder>> loadReminders() async {
    final userPreferences = await SharedPreferences.getInstance();
    final String? remindersJson = userPreferences.getString(_remindersKey);

    if (remindersJson != null) {
      final List<dynamic> reminderList = jsonDecode(remindersJson);
      return reminderList.map((item) => Reminder.fromMap(item)).toList();
    }
    return [];
  }

  static Future<void> saveReceiveNotifications(bool value) async {
    final userPreferences = await SharedPreferences.getInstance();
    await userPreferences.setBool(_notificationKey, value);
  }

  static Future<bool> loadReceiveNotifications() async {
    final userPreferences = await SharedPreferences.getInstance();
    return userPreferences.getBool(_notificationKey) ?? false;
  }

  static Future<bool> clearAll() async {
    final userPreferences = await SharedPreferences.getInstance();
    final clearedSuccessfully = await userPreferences.clear();
    return clearedSuccessfully;
  }
}
