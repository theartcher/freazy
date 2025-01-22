import 'package:freazy/models/reminder.dart';

class ReminderValidator {
  static String? validate(List<Reminder> reminders) {
    Set<String> seenReminders = {};

    for (var reminder in reminders) {
      String reminderKey = '${reminder.type}-${reminder.amount}';

      if (seenReminders.contains(reminderKey)) {
        return 'Er is al een melding met deze instellingen "${reminder.amount} - ${reminder.type.label}".';
      }

      seenReminders.add(reminderKey);
    }

    return null;
  }
}
