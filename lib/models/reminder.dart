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
  int? id;
  ReminderType type; // Enum for "week" or "day"
  int amount; // Amount of weeks or days

  Reminder({
    this.id,
    required this.type,
    required this.amount,
  });

  /// Empty constructor with default values
  Reminder.empty()
      : id = null,
        type = ReminderType.day,
        amount = 0;

  /// Convert object to a map
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'type': type.name, // Use `.name` to store as a String
      'amount': amount,
    };
  }

  /// Create a copy of the object with optional overrides
  Reminder copyWith({
    int? id,
    ReminderType? durationType,
    int? durationValue,
  }) {
    return Reminder(
      id: id ?? this.id,
      type: durationType ?? type,
      amount: durationValue ?? amount,
    );
  }

  /// Create an object from a map
  factory Reminder.fromMap(Map<dynamic, dynamic> map) {
    return Reminder(
      id: map['id'] as int?,
      type: ReminderType.values.firstWhere(
        (e) => e.name == map['type'], // Convert String back to Enum
      ),
      amount: map['amount'] as int,
    );
  }
}
