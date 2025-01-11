import 'package:freazy/models/item.dart';
import 'package:freazy/utils/db_helper.dart';
import 'package:freazy/utils/preferences_manager.dart';

class NotificationHelper {
  Future<bool> sendNotifications() async {
    DatabaseHelper db = DatabaseHelper();

    // Get all items
    List<Item> items = await db.fetchItems();

    // If there are no items, there is no need to check for notifications
    if (items.isEmpty) return false;

    // Get local preferences
    List<Duration> notificationFrequencies =
        await PreferencesManager().loadDurations();

    // If there are no notification frequencies, there is no need to check for notifications
    if (notificationFrequencies.isEmpty) return false;

    print('Checking for notifications');

    // Get items to notify about
    List<Item> itemsToNotifyAbout =
        _getItemsToNotify(items, notificationFrequencies);

    //Format the notification string.
    // E.g. -> If 1 item, note specific item. If multiple items, note the number of items. Also note items overdue.

    return true;
  }

  /// Private method to formulate the string to be displayed in the notification.
  String _formatNotificationString(List<Item> items) {
    if (items.isEmpty) {
      return 'Something went REALLY wrong if you receive this notification. Please contact us.';
    }

    if (items.length == 1) {
      return 'Uw product ${items.first.title} bederft op ${items.first.expirationDate}.';
    }

    if (items.length >= 3) {
      return 'Er zijn ${items.length} producten die bijna bedorven zijn. ${items.first.title}, ${items[1].title} en ${items[2].title} zijn er een paar van.';
    }

    return 'Er zijn ${items.length} items die bijna bedorven zijn.';
  }

  /// Private method to filter items that should be notified about
  List<Item> _getItemsToNotify(
      List<Item> items, List<Duration> notificationFrequencies) {
    final now = DateTime.now();
    List<Item> itemsToNotify = [];

    for (final item in items) {
      final expirationDate = item.expirationDate;

      for (final frequency in notificationFrequencies) {
        if (now.isAfter(expirationDate.subtract(frequency)) &&
            now.isBefore(expirationDate)) {
          itemsToNotify.add(item);
          break;
        }
      }
    }

    return itemsToNotify;
  }
}
