import 'package:flutter/material.dart';
import 'package:freazy/constants/constants.dart';
import 'package:freazy/utils/background_manager.dart';
import 'package:freazy/utils/settings/preferences_manager.dart';
import 'package:freazy/widgets/messenger.dart';
import 'package:freazy/widgets/settings/pressable_setting.dart';
import 'package:freazy/widgets/settings/toggle_switch_setting.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReminderSettings extends StatefulWidget {
  const ReminderSettings({super.key});

  @override
  State<ReminderSettings> createState() => _ReminderSettingsState();
}

class _ReminderSettingsState extends State<ReminderSettings> {
  bool UIareNotificationsEnabled = false;
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

    void notifyAboutPermissionProblems() {
      MessengerService().showMessage(
        message: localization.settingsPage_remindersSection_permissionDenied,
        type: MessageType.error,
        closeMessage: localization.generic_openSettings,
        onClose: () => openAppSettings(),
        duration: const Duration(seconds: 15),
      );
    }

    void toggleNotifications(bool enable) async {
      // Check current notification permission status
      var status = await Permission.notification.status;

      if (enable) {
        // If permission is not granted, request it
        if (!status.isGranted) {
          // Handle permanently denied: guide user to settings
          if (status.isPermanentlyDenied) {
            notifyAboutPermissionProblems();
            setState(() {
              UIareNotificationsEnabled = false;
            });
            await PreferencesManager.saveReceiveNotifications(false);
            return;
          }

          // Request permission
          var requestStatus = await Permission.notification.request();

          if (!requestStatus.isGranted) {
            notifyAboutPermissionProblems();
            setState(() {
              UIareNotificationsEnabled = false;
            });
            await PreferencesManager.saveReceiveNotifications(false);
            return;
          }
        }
        // Permission granted
        await PreferencesManager.saveReceiveNotifications(true);
        setState(() {
          UIareNotificationsEnabled = true;
        });
      } else {
        // User turned notifications off
        setState(() {
          UIareNotificationsEnabled = false;
        });
        await PreferencesManager.saveReceiveNotifications(false);
      }
    }

    return Column(
      children: [
        ToggleSwitchSetting(
          title: localization.settingsPage_remindersSection_notificationTitle,
          description: localization
              .settingsPage_remindersSection_notificationDescription,
          isToggled: UIareNotificationsEnabled,
          changeValue: toggleNotifications,
        ),
        PressableSettingTile(
          title: localization.settingsPage_remindersSection_remindersTitle,
          description:
              localization.settingsPage_remindersSection_remindersDescription,
          onPress: () => context.push(ROUTE_REMINDERS_EDIT),
          trailing: const Icon(Icons.notifications),
          disabled: !UIareNotificationsEnabled,
        ),
        PressableSettingTile(
          onPress: selectTime,
          title: localization.settingsPage_remindersSection_reminderTimeTitle,
          description: localization
              .settingsPage_remindersSection_reminderTimeDescription,
          trailing: Text(
            _selectedReminderTime.format(context),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: UIareNotificationsEnabled
                      ? null
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                ),
          ),
          disabled: !UIareNotificationsEnabled,
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
      UIareNotificationsEnabled = enableNotifications;
    });
  }
}
