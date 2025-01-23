import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:freazy/constants/constants.dart';
import 'package:freazy/utils/background_manager.dart';
import 'package:freazy/utils/settings/preferences_manager.dart';
import 'package:freazy/widgets/settings/pressable_setting.dart';
import 'package:freazy/widgets/settings/toggle_switch_setting.dart';
import 'package:go_router/go_router.dart';
import 'package:workmanager/workmanager.dart';

class ReminderSettings extends StatefulWidget {
  const ReminderSettings({super.key});

  @override
  State<ReminderSettings> createState() => _ReminderSettingsState();
}

class _ReminderSettingsState extends State<ReminderSettings> {
  bool _UIareNotificationsEnabled = false;
  TimeOfDay _selectedReminderTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _loadInitialSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleSwitchSetting(
          title: 'Meldingen ontvangen',
          description: "Meldingen ontvangen wanneer een product bedorven is.",
          isToggled: _UIareNotificationsEnabled,
          changeValue: _toggleNotifications,
        ),
        PressableSettingTile(
          title: 'Herineringen beheren',
          description: 'Configureer wanneer u herinneringen ontvangt.',
          onPress: () => context.push(ROUTE_REMINDERS_EDIT),
          trailing: Icon(Icons.notifications),
        ),
        //Separate widget since ]PressableSettingTile] does not yet implement [Widget?] instead of icon.
        ListTile(
          onTap: _selectTime,
          title: Text("Tijd selecteren",
              style: Theme.of(context).textTheme.bodyLarge),
          subtitle: Text("Kies op welk tijdstip u meldingen wilt ontvangen.",
              style: Theme.of(context).textTheme.bodySmall),
          trailing: Text(
            _selectedReminderTime.format(context),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          minVerticalPadding: 0,
        ),
      ],
    );
  }

  void _selectTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      initialTime: _selectedReminderTime,
      context: context,
      confirmText: "Bevestigen",
      cancelText: "Annuleren",
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      await PreferencesManager.saveReminderTime(selectedTime);
      setState(() {
        _selectedReminderTime = selectedTime;
      });
      BackgroundManager.scheduleReminder(
        policyOnExistingSchedule: ExistingWorkPolicy.update,
      );
    }
  }

  Future<void> _loadInitialSettings() async {
    TimeOfDay time = await PreferencesManager.loadReminderTime();
    bool enableNotifications =
        await PreferencesManager.loadReceiveNotifications();
    setState(() {
      _selectedReminderTime = time;
      _UIareNotificationsEnabled = enableNotifications;
    });
  }

  void _toggleNotifications(bool toggleEnableNotifications) async {
    //If the user is trying to enable notifications, check and show prompt for permissions.
    var permissionAlreadyGranted =
        await AwesomeNotifications().isNotificationAllowed();
    var permissionRequestSuccess = false;

    //If notification permission has already been granted, don't request.
    if (!permissionAlreadyGranted) {
      permissionRequestSuccess =
          await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    //If notification permission isn't already allowed, nor is allowed by the pop-up. Do not toggle the switch in UI and cancel entire request.
    //TODO: Add notification that permissions have been denied
    if (!permissionRequestSuccess && !permissionAlreadyGranted) {
      setState(() {
        _UIareNotificationsEnabled = false;
      });
      return;
    }

    await PreferencesManager.saveReceiveNotifications(
        toggleEnableNotifications);

    setState(() {
      _UIareNotificationsEnabled = toggleEnableNotifications;
    });
  }
}
