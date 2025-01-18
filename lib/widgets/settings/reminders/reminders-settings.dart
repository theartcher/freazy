import 'package:flutter/material.dart';
import 'package:freazy/constants/constants.dart';
import 'package:freazy/utils/preferences_manager.dart';
import 'package:freazy/widgets/settings/pressable_setting.dart';
import 'package:freazy/widgets/settings/toggle_switch_setting.dart';
import 'package:go_router/go_router.dart';

class ReminderSettings extends StatefulWidget {
  const ReminderSettings({super.key});

  @override
  State<ReminderSettings> createState() => _ReminderSettingsState();
}

class _ReminderSettingsState extends State<ReminderSettings> {
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
        PressableSetting(
          //TODO: USE LISTTILE INSTEAD
          title: 'Meldingen beheren',
          description: 'Pas aan wanneer u meldingen wilt ontvangen.',
          onPress: () => context.push(ROUTE_REMINDERS_EDIT),
          icon: Icons.notifications,
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
