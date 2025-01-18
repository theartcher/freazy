import 'package:flutter/material.dart';
import 'package:freazy/models/reminder.dart';
import 'package:freazy/utils/databases/reminder_database_helper.dart';
import 'package:freazy/utils/preferences_manager.dart';
import 'package:freazy/widgets/settings/reminder_selector.dart';
import 'package:freazy/widgets/settings/toggle_switch_setting.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool _areNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleSwitchSetting(
          title: 'Meldingen ontvangen',
          description: "Meldingen ontvangen wanneer een product bedorven is.",
          isToggled: _areNotificationsEnabled,
          changeValue: _toggleNotifications,
        ),
      ],
    );
  }

  void _toggleNotifications(bool enableNotifications) async {
    await PreferencesManager().saveReceiveNotifications(enableNotifications);

    setState(() {
      _areNotificationsEnabled = enableNotifications;
    });
  }
}
