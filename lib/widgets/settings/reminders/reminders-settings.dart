import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:freazy/constants/constants.dart';
import 'package:freazy/utils/background_manager.dart';
import 'package:freazy/utils/settings/preferences_manager.dart';
import 'package:freazy/widgets/settings/pressable_setting.dart';
import 'package:freazy/widgets/settings/toggle_switch_setting.dart';
import 'package:go_router/go_router.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final localization = AppLocalizations.of(context)!;

    void selectTime() async {
      TimeOfDay? selectedTime = await showTimePicker(
        initialTime: _selectedReminderTime,
        context: context,
        confirmText: localization.generic_confirm,
        cancelText: localization.generic_cancel,
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

    return Column(
      children: [
        ToggleSwitchSetting(
          title: localization.settingsPage_remindersSection_notificationTitle,
          description: localization
              .settingsPage_remindersSection_notificationDescription,
          isToggled: _UIareNotificationsEnabled,
          changeValue: _toggleNotifications,
        ),
        PressableSettingTile(
          title: localization.settingsPage_remindersSection_remindersTitle,
          description:
              localization.settingsPage_remindersSection_remindersDescription,
          onPress: () => context.push(ROUTE_REMINDERS_EDIT),
          trailing: const Icon(Icons.notifications),
        ),
        PressableSettingTile(
          onPress: selectTime,
          title: localization.settingsPage_remindersSection_reminderTimeTitle,
          description: localization
              .settingsPage_remindersSection_reminderTimeDescription,
          trailing: Text(
            _selectedReminderTime.format(context),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
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
