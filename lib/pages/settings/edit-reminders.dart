import 'package:flutter/material.dart';
import 'package:freazy/models/reminder.dart';
import 'package:freazy/widgets/settings/reminders/reminder_selector.dart';
import 'package:go_router/go_router.dart';

class EditNotificationsPage extends StatefulWidget {
  const EditNotificationsPage({super.key});

  @override
  State<EditNotificationsPage> createState() => _EditNotificationsPageState();
}

class _EditNotificationsPageState extends State<EditNotificationsPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<Reminder> _reminders = [];

  void _addReminder() {
    if (_reminders.length >= 5) {
      return;
    }

    setState(() {
      _reminders.add(Reminder(type: ReminderType.day, amount: 1));
    });
  }

  void _deleteReminder(Reminder reminder) {
    setState(() {
      _reminders.remove(reminder);
    });
  }

  Future<void> exitWithSaving() async {
    setState(() {
      _isLoading = true;
    });

    // Implement loading, check states before saving.
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text("Meldingen configureren"),
        actions: [
          _isLoading
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () => exitWithSaving(),
                )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Melding toevoegen",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _reminders.length >= 5 ? null : _addReminder,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                  _reminders.isEmpty
                      ? const Text("Geen meldingen opgeslagen")
                      : const SizedBox.shrink(),
                  ..._reminders.map((reminder) {
                    return ReminderSelector(
                      key: ValueKey(reminder),
                      initialReminder: reminder,
                      onSave: (reminder) {
                        setState(() {
                          final index = _reminders.indexOf(reminder);
                          if (index != -1) {
                            _reminders[index] = reminder;
                          }
                        });
                      },
                      onDelete: _deleteReminder,
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
