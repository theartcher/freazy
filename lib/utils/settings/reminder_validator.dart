import 'package:flutter/material.dart';
import 'package:freazy/models/reminder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReminderValidator {
  static Future<String?> validate(
    List<Reminder> reminders,
    BuildContext context,
    Locale locale,
  ) async {
    final localization = AppLocalizations.of(context)!;
    Set<String> seenReminders = {};

    for (var reminder in reminders) {
      String reminderKey = '${reminder.type.label(locale)}-${reminder.amount}';

      if (seenReminders.contains(reminderKey)) {
        return localization.configureRemindersPage_reminderValidation_duplicate(
          reminder.amount,
          reminder.type.label(locale),
        );
      }

      seenReminders.add(reminderKey);
    }

    return null;
  }
}
