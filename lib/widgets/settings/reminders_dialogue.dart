import 'package:flutter/material.dart';
import 'package:freazy/models/reminder.dart';
import 'package:freazy/utils/databases/reminder_database_helper.dart';
import 'package:freazy/utils/preferences_manager.dart';
import 'package:freazy/widgets/settings/menu_setting.dart';
import 'package:freazy/widgets/settings/reminder_selector.dart';

class ReminderDialogue extends StatefulWidget {
  const ReminderDialogue({super.key});

  @override
  State<ReminderDialogue> createState() => _ReminderDialogueState();
}

class _ReminderDialogueState extends State<ReminderDialogue> {
  List<ReminderSelector> _notificationSelectors = [];
  final RemindersDatabaseHelper db = RemindersDatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return DialogueSettings(
        title: "Beheer notificaties", openMenu: _showDialogue);
  }

  Future<void> _initializeNotifications() async {
    final reminders = await db.fetchReminders();

    setState(() {
      // Map fetched reminders to NotificationSelector widgets
      _notificationSelectors = reminders.map((reminder) {
        return ReminderSelector(
          id: reminder.id!,
          onDelete: (int id) {},
          onSave: (Reminder reminder) {},
          initialReminder: reminder,
        );
      }).toList();
    });
  }

  void _addNewNotification() {
    if (_notificationSelectors.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You can't add more than 5 notifications."),
        ),
      );
      return;
    }

    setState(() {
      // Create a new Reminder with no ID (indicating it's new)
      final newReminder = Reminder.empty();

      // Add a ReminderSelector for the new reminder
      _notificationSelectors.add(ReminderSelector(
        id: null,
        onDelete: (int id) {},
        onSave: (Reminder reminder) {},
        initialReminder: newReminder,
      ));
    });
  }

  // Function to show the confirmation dialog
  void _showDialogue() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Dialog.fullscreen(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bevestig verwijdering'),
                Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Text("Nieuwe melding toevoegen")),
                        IconButton(
                          onPressed: _addNewNotification,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    Column(children: _notificationSelectors),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text('Annuleren'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Opslaan',
                              style: TextStyle(color: Colors.green)),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
