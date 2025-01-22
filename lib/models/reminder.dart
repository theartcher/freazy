enum ReminderType { week, day }

extension ReminderTypeLabel on ReminderType {
  String get label {
    switch (this) {
      case ReminderType.week:
        return "weken";
      case ReminderType.day:
        return "dagen";
    }
  }
}

class Reminder {
  ReminderType type; // Enum for "week" or "day"
  int amount; // Amount of weeks or days

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
      'type': type.name, // Use `.name` to store as a String
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
