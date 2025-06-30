import 'package:flutter/material.dart';
import 'package:freazy/models/reminder.dart';
import 'package:freazy/utils/settings/preferences_manager.dart';
import 'package:freazy/utils/settings/reminder_validator.dart';
import 'package:freazy/widgets/messenger.dart';
import 'package:freazy/widgets/settings/reminders/reminder_selector.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditNotificationsPage extends StatefulWidget {
  const EditNotificationsPage({super.key});

  @override
  State<EditNotificationsPage> createState() => _EditNotificationsPageState();
}

class _EditNotificationsPageState extends State<EditNotificationsPage> {
  final _formKey = GlobalKey<FormState>();
  final _maxAmountOfReminders = 15;
  bool _isLoading = false;
  List<Reminder> _reminders = [];

  void _addReminder() {
    if (_reminders.length >= _maxAmountOfReminders) {
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

  Future<void> _initialize() async {
    var existingReminders = await PreferencesManager.loadReminders();

    setState(() {
      _reminders = existingReminders;
    });
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> isValid(List<Reminder> reminders) async {
      var locale = await PreferencesManager.loadLocale();
      var errors = await ReminderValidator.validate(
        reminders,
        context,
        locale,
      );

      if (errors != null) {
        MessengerService().showMessage(
          message: errors,
          type: MessageType.error,
        );

        return false;
      }

      return true;
    }

    Future<void> saveReminder(Reminder reminder) async {
      // Check if reminder with the same amount and type already exists
      bool isDuplicate = _reminders.any((existingReminder) =>
          existingReminder.amount == reminder.amount &&
          existingReminder.type == reminder.type);

      if (isDuplicate) {
        if (!await isValid(_reminders)) {
          return;
        }
      }

      // Proceed to save the reminder if it's unique
      setState(() {
        final index = _reminders.indexOf(reminder);
        if (index != -1) {
          _reminders[index] = reminder;
        } else {
          _reminders.add(reminder);
        }
      });
    }

    Future<void> exitWithSaving() async {
      // Run validation when the "Save" button is pressed
      if (!await isValid(_reminders)) {
        return;
      }

      setState(() {
        _isLoading = true;
      });

      await PreferencesManager.saveReminders(_reminders);
      context.pop();
    }

    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(localization.configureRemindersPage_header_title),
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
                          localization.configureRemindersPage_section_title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _reminders.length >= _maxAmountOfReminders
                            ? null
                            : _addReminder,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                  _reminders.isEmpty
                      ? Text(
                          localization
                              .configureRemindersPage_reminder_noActiveReminders,
                        )
                      : const SizedBox.shrink(),
                  ..._reminders.map((reminder) {
                    return ReminderSelector(
                      key: ValueKey(reminder),
                      initialReminder: reminder,
                      onSave: saveReminder,
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
