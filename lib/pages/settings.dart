import 'package:flutter/material.dart';
import 'package:freazy/utils/preferences_manager.dart';
import 'package:freazy/widgets/settings/menu_setting.dart';
import 'package:freazy/widgets/settings/reminders.dart';
import 'package:freazy/widgets/settings/reminders_dialogue.dart';
import 'package:go_router/go_router.dart';
import 'package:freazy/utils/databases/item_database_helper.dart';
import 'package:freazy/widgets/settings/toggle_switch_setting.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ItemDatabaseHelper _dbHelper = ItemDatabaseHelper();

  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        scrolledUnderElevation: 0,
        title: const Text('Instellingen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Section: Notifications
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Meldingen',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary),
            ),
          ),
          NotificationSettings(),
          ReminderDialogue(),
          const Divider(),
          // Section: Appearance
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Uiterlijk',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary),
            ),
          ),
          ToggleSwitchSetting(
            title: 'Donkere modus',
            description: "Gebruik een donker uiterlijk voor batterijbesparing.",
            isToggled: _darkMode,
            changeValue: _toggleDarkMode,
          ),
          const Divider(),
          // New Section: Delete Database
          ListTile(
            title: const Text(
              'Verwijder database',
              style: TextStyle(
                  color: Colors.red), // Optional styling to indicate caution
            ),
            trailing: const Icon(Icons.delete, color: Colors.red),
            onTap: _showDeleteConfirmationDialog,
          ),
        ],
      ),
    );
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkMode = value;
    });
  }

  // Function to show the confirmation dialog
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bevestig verwijdering'),
          content: const Text(
              'Weet u zeker dat u de database wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuleren'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Verwijderen',
                  style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await _deleteDatabase();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to handle the actual database deletion
  Future<void> _deleteDatabase() async {
    await _dbHelper.deleteAndRecreateDatabase();
  }
}
