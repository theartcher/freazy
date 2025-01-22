import 'package:flutter/material.dart';

class TimeOfDayHelper {
  static String _addLeadingZeroIfNeeded(int value) {
    if (value < 10) {
      return '0$value';
    }
    return value.toString();
  }

  static String toJsonString(TimeOfDay timeOfDay) {
    final String hourLabel = _addLeadingZeroIfNeeded(timeOfDay.hour);
    final String minuteLabel = _addLeadingZeroIfNeeded(timeOfDay.minute);

    return '$hourLabel:$minuteLabel';
  }

  static TimeOfDay fromJsonString(String json) {
    final hourAndMinutes = json.split(':');

    return TimeOfDay(
      hour: int.tryParse(hourAndMinutes.first) ?? -1,
      minute: int.tryParse(hourAndMinutes.last) ?? -1,
    );
  }
}
