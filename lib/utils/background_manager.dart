import 'package:flutter/material.dart';
import 'package:freazy/utils/settings/preferences_manager.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundManager {
  static const String _reminderBackgroundTaskKey = "remindersBgTask";
  static const String reminderBackgroundTaskName =
      "check-reminders-and-send-notifications";

  ///Schedule a reminder to execute the background task for notifications at the user's TimeOfDay.
  ///Specify the [policyOnExistingSchedule] accordingly, currently it will overwrite the existing task.
  static Future<void> scheduleReminder(
      {ExistingWorkPolicy? policyOnExistingSchedule}) async {
    TimeOfDay executionTime = await PreferencesManager.loadReminderTime();
    Duration delayToExecutionTime = _delayScheduleToTime(executionTime);

    await Workmanager().registerPeriodicTask(
      _reminderBackgroundTaskKey,
      reminderBackgroundTaskName,
      existingWorkPolicy: policyOnExistingSchedule ?? ExistingWorkPolicy.update,
      frequency: const Duration(days: 1),
      initialDelay: delayToExecutionTime,
    );
  }

  ///Clears all existing background tasks, schedule and one-offs.
  static Future<void> clearAllSchedules() async {
    await Workmanager().cancelAll();
  }

  ///Converts [TimeOfDay] into a [Duration], with the duration being the time in seconds needed from DateTime.now() to be the same time as [time].
  static Duration _delayScheduleToTime(TimeOfDay time) {
    final now = DateTime.now();
    final currentTimeInSeconds = now.hour * 3600 + now.minute * 60 + now.second;

    // Convert the provided TimeOfDay to seconds from midnight
    final targetTimeInSeconds = time.hour * 3600 + time.minute * 60;

    // Calculate the difference in seconds
    int delayInSeconds;
    if (targetTimeInSeconds >= currentTimeInSeconds) {
      // If the target time is later today
      delayInSeconds = targetTimeInSeconds - currentTimeInSeconds;
    } else {
      // If the target time is on the next day
      const secondsInDay = 24 * 3600;
      delayInSeconds =
          secondsInDay - currentTimeInSeconds + targetTimeInSeconds;
    }

    // Return the delay as a Duration
    return Duration(seconds: delayInSeconds);
  }
}
