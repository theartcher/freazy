import 'package:flutter/material.dart';
import 'package:freazy/models/reminder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReminderSelector extends StatefulWidget {
  final Reminder? initialReminder;
  final void Function(Reminder reminder) onSave;
  final void Function(Reminder reminder) onDelete;

  const ReminderSelector({
    super.key,
    required this.onSave,
    required this.onDelete,
    this.initialReminder,
  });

  @override
  State<ReminderSelector> createState() => _ReminderSelectorState();
}

class _ReminderSelectorState extends State<ReminderSelector> {
  static const spaceBetween = 8.0;

  late Reminder _reminder;
  final List<int> _numberOptions =
      List.generate(7, (index) => index + 1); // [1, 2, 3, 4, 5, 6, 7]

  @override
  void initState() {
    super.initState();
    _reminder = widget.initialReminder ??
        Reminder(type: ReminderType.day, amount: _numberOptions.first);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Row(
      children: [
        Text(localization.configureRemindersPage_reminder_prefix),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: _reminder.amount,
          items: _numberOptions
              .map((number) => DropdownMenuItem<int>(
                    value: number,
                    child: Text(number.toString()),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _reminder.amount = value!;
              widget.onSave(
                _reminder,
              );
            });
          },
        ),
        const SizedBox(width: spaceBetween),
        DropdownButton<ReminderType>(
          value: _reminder.type,
          items: [
            DropdownMenuItem<ReminderType>(
              value: ReminderType.day,
              child: Text(
                localization.configureRemindersPage_reminder_optionDay,
              ),
            ),
            DropdownMenuItem<ReminderType>(
              value: ReminderType.week,
              child: Text(
                localization.configureRemindersPage_reminder_optionWeek,
              ),
            )
          ],
          onChanged: (value) {
            setState(() {
              _reminder.type = value!;
              widget.onSave(_reminder);
            });
          },
        ),
        const SizedBox(width: spaceBetween),
        Expanded(
          child: Text(localization.configureRemindersPage_reminder_suffix),
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          color: Colors.red,
          onPressed: () {
            widget.onDelete(_reminder);
          },
        ),
      ],
    );
  }
}
