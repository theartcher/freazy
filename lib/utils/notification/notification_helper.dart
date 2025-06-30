import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:freazy/constants/constants.dart';
import 'package:freazy/models/item.dart';
import 'package:freazy/models/reminder.dart';
import 'package:freazy/utils/databases/item_database_helper.dart';
import 'package:freazy/utils/notification/notification_localization.dart';
import 'package:freazy/utils/settings/preferences_manager.dart';

class NotificationHelper {
  Future<bool> sendNotifications() async {
    //Check if the user wants to receive notifications, if not then stop.
    bool sendNotifications =
        await PreferencesManager.loadReceiveNotifications();
    if (!sendNotifications) return true;
    ItemDatabaseHelper db = ItemDatabaseHelper();

    // Get local preferences
    // If there are no reminders, there is no need to check for notifications
    List<Reminder> itemReminders = await PreferencesManager.loadReminders();
    if (itemReminders.isEmpty) return true;

    // Get all items
    // If there are no items, there is no need to check for notifications
    List<Item> items = await db.fetchItems();
    if (items.isEmpty) return true;

    // Get items to notify about
    // If there are no items that need reminding, there's no need to send a notification.
    List<Item> itemsToNotifyAbout = _getItemsToNotify(items, itemReminders);
    if (itemsToNotifyAbout.isEmpty) return true;

    //Format the notification string.
    Locale locale = await PreferencesManager.loadLocale();
    String notificationString =
        await _formatNotificationString(itemsToNotifyAbout, locale);

    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: FREAZY_NOTIFICATION_CHANNEL_KEY,
      actionType: ActionType.Default,
      title: NotificationLocalizationHelper().getTitle(locale),
      body: notificationString,
    ));

    //Let the work manager know the task executed successfully.
    return true;
  }

  /// Private method to formulate the string to be displayed in the notification.
  Future<String> _formatNotificationString(
    List<Item> items,
    Locale locale,
  ) async {
    var notificationLocalization = NotificationLocalizationHelper();

    if (items.isEmpty) {
      return notificationLocalization.getUnexpectedError(locale);
    }

    if (items.length == 1) {
      return notificationLocalization.getSingleItemNotification(
        locale,
        items.first.title,
        items.first.expirationDate,
      );
    }

    if (items.length > 1 && items.length <= 3) {
      return notificationLocalization.getThreeItemNotification(
        locale,
        items[0].title,
        items[1].title,
        items[2].title,
      );
    }

    return notificationLocalization.getMultipleItemNotification(
      locale,
      items.length,
    );
  }

  /// Private method to filter items that should be notified about
  List<Item> _getItemsToNotify(List<Item> items, List<Reminder> itemReminders) {
    final today = DateTime.now();
    List<Item> itemsToNotify = [];

    for (final item in items) {
      final expirationDate = item.expirationDate;

      // Check each reminder frequency for the item
      for (final reminder in itemReminders) {
        DateTime reminderDate;

        // Calculate the reminder date based on the type (week or day)
        if (reminder.type == ReminderType.week) {
          reminderDate =
              expirationDate.subtract(Duration(days: reminder.amount * 7));
        } else {
          reminderDate =
              expirationDate.subtract(Duration(days: reminder.amount));
        }

        // Check if today is the exact reminder date
        if (today.year == reminderDate.year &&
            today.month == reminderDate.month &&
            today.day == reminderDate.day) {
          itemsToNotify.add(item);
          break; // Stop checking further reminders for this item if one matches
        }
      }
    }

    return itemsToNotify;
  }
}
