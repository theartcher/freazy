import 'dart:convert';

import 'package:freazy/models/reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static const String _keyReminders = 'reminders';

  /// Save a list of Reminder objects to SharedPreferences
  static Future<void> saveReminders(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert each Reminder to a map, then serialize the list to JSON
    final String remindersJson =
        jsonEncode(reminders.map((r) => r.toMap()).toList());

    await prefs.setString(_keyReminders, remindersJson);
  }

  /// Load a list of Reminder objects from SharedPreferences
  static Future<List<Reminder>> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? remindersJson = prefs.getString(_keyReminders);

    if (remindersJson != null) {
      // Decode the JSON and map each item back to a Reminder object
      final List<dynamic> reminderList = jsonDecode(remindersJson);
      return reminderList.map((item) => Reminder.fromMap(item)).toList();
    }
    return []; // Return an empty list if nothing is stored
  }

  /// Clear the stored reminders
  static Future<void> clearReminders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyReminders);
  }

  Future<void> saveReceiveNotifications(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('receiveNotifications', value);
  }

  Future<bool> loadReceiveNotifications() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool('receiveNotifications') ?? false;
  }
}
