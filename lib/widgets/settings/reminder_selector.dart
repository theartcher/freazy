import 'package:flutter/material.dart';
import 'package:freazy/models/reminder.dart';
import 'package:freazy/utils/databases/reminder_database_helper.dart';

class ReminderSelector extends StatefulWidget {
  final int? id;
  final Reminder? initialReminder;
  final void Function(int id) onDelete;
  final void Function(Reminder reminder) onSave;

  const ReminderSelector({
    super.key,
    required this.id,
    required this.onDelete,
    required this.onSave,
    required this.initialReminder,
  });

  @override
  State<ReminderSelector> createState() => _ReminderSelectorState();
}

class _ReminderSelectorState extends State<ReminderSelector> {
  late Reminder _reminder;
  final List<int> _numberOptions =
      List.generate(7, (index) => index + 1); // [1, 2, 3, 4, 5, 6, 7]

  @override
  void initState() {
    super.initState();

    // Use the initialReminder if provided, otherwise create a new one
    _reminder = widget.initialReminder ??
        Reminder(
          id: widget.id,
          amount: _numberOptions.first, // Default to the first valid value
          type: ReminderType.day,
        );

    // Validate the initial amount to ensure it's within the valid range
    if (!_numberOptions.contains(_reminder.amount)) {
      _reminder.amount = _numberOptions.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Herinner mij"),
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
              widget.onSave(_reminder); // Save changes
            });
          },
        ),
        const SizedBox(width: 8),
        DropdownButton<ReminderType>(
          value: _reminder.type,
          items: ReminderType.values
              .map((type) => DropdownMenuItem<ReminderType>(
                    value: type,
                    child: Text(type.label),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _reminder.type = value!;
              widget.onSave(_reminder); // Save changes
            });
          },
        ),
        const SizedBox(width: 8),
        const Expanded(child: Text("van tevoren.")),
        IconButton(
          icon: const Icon(Icons.remove),
          color: Colors.red,
          onPressed: () {
            if (_reminder.id != null) {
              widget.onDelete(_reminder.id!);
            }
          },
        ),
      ],
    );
  }
}
