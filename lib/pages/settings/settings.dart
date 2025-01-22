import 'package:flutter/material.dart';
import 'package:freazy/widgets/settings/reminders/reminders-settings.dart';
import 'package:freazy/widgets/settings/reset_app.dart';
import 'package:go_router/go_router.dart';
import 'package:freazy/widgets/settings/toggle_switch_setting.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
        children: [
          // Section: Notifications
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Text(
              'Meldingen',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary),
            ),
          ),
          const ReminderSettings(),
          const Divider(),
          // Section: Appearance
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
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
          const ResetAppSetting(),
        ],
      ),
    );
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkMode = value;
    });
  }
}
