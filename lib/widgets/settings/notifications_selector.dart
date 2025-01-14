import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  void _AddNewNotification() {
    // Check if there is already an empty / unused notification row
    // If there is, do not add one, disable that button
    // If there is not, add an empty/unused notification row.
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [],
        ),
        Row(
          children: [
            //Row to add notification
            const Expanded(child: Text("Notificatie toevoegen")),
            IconButton(
                onPressed: () => _AddNewNotification,
                icon: const Icon(Icons.add))
          ],
        ),
      ],
    );
  }
}

typedef NotificationUnitEntry = DropdownMenuEntry<IconLabel>;
typedef NotificationNumberEntry = DropdownMenuEntry<IconLabel>;

enum NotificationUnitEntry {
  week('weken'),
  dag("dagen"),

  final String label;

  static final List<ColorEntry> entries = UnmodifiableListView<ColorEntry>(
    values.map<ColorEntry>(
      (ColorLabel color) => ColorEntry(
        value: color,
        label: color.label,
        enabled: color.label != 'Grey',
        style: MenuItemButton.styleFrom(
          foregroundColor: color.color,
        ),
      ),
    ),
  );
}

class NotificationSelector extends StatefulWidget {
  const NotificationSelector({super.key});

  @override
  State<NotificationSelector> createState() => _NotificationSelectorState();
}

class _NotificationSelectorState extends State<NotificationSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Herinner mij"),
        DropdownMenu(dropdownMenuEntries: dropdownMenuEntries),
        DropdownMenu(dropdownMenuEntries: dropdownMenuEntries),
        const Text("van tevoren.")
      ],
    );
  }
}
