import 'dart:ui';

import 'package:freazy/constants/locales.dart';

enum ReminderType { week, day }

extension ReminderTypeLabel on ReminderType {
  String label(Locale locale) {
    switch (this) {
      case ReminderType.week:
        if (locale == nlLocale) {
          return "weken";
        } else {
          return "weeks";
        }
      case ReminderType.day:
        if (locale == nlLocale) {
          return "dagen";
        } else {
          return "days";
        }
    }
  }
}

class Reminder {
  ReminderType type;
  int amount;

  Reminder({
    required this.type,
    required this.amount,
  });

  /// Empty constructor with default values
  Reminder.empty()
      : type = ReminderType.day,
        amount = 0;

  /// Convert object to a map
  Map<String, Object?> toMap() {
    return {
      'type': type.name,
      'amount': amount,
    };
  }

  /// Create an object from a map
  factory Reminder.fromMap(Map<dynamic, dynamic> map) {
    return Reminder(
      type: ReminderType.values.firstWhere(
        (e) => e.name == map['type'], // Convert String back to Enum
      ),
      amount: map['amount'] as int,
    );
  }

  /// Create a copy of the object with optional overrides
  Reminder copyWith({
    ReminderType? durationType,
    int? durationValue,
  }) {
    return Reminder(
      type: durationType ?? type,
      amount: durationValue ?? amount,
    );
  }
}
