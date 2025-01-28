import 'package:flutter/material.dart';
import 'package:freazy/utils/background_manager.dart';
import 'package:freazy/utils/databases/item_database_helper.dart';
import 'package:freazy/utils/settings/preferences_manager.dart';
import 'package:freazy/widgets/settings/pressable_setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetAppSetting extends StatefulWidget {
  const ResetAppSetting({super.key});

  @override
  State<ResetAppSetting> createState() => _ResetAppSettingState();
}

class _ResetAppSettingState extends State<ResetAppSetting> {
  static const amountOfSpaceBetween = 16.00;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    void showDeleteConfirmationDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          bool confirmResetApp = false;

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title:
                    Text(localization.settingsPage_resetApp_confirmationTitle),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.settingsPage_resetApp_confirmationContext,
                      ),
                      const SizedBox(height: amountOfSpaceBetween),
                      Row(
                        children: [
                          Checkbox(
                            value: confirmResetApp,
                            onChanged: (newValue) {
                              setState(() {
                                confirmResetApp = newValue ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              localization
                                  .settingsPage_resetApp_checkboxAcceptConsequences,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(localization.generic_cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    onPressed: confirmResetApp
                        ? () async {
                            //Clear all preferences, background tasks and the database.
                            await PreferencesManager.clearAll();
                            await BackgroundManager.clearAllSchedules();
                            await ItemDatabaseHelper()
                                .deleteAndRecreateDatabase();
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: Text(
                      localization.generic_delete,
                      style: TextStyle(
                        color: confirmResetApp ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return PressableSettingTile(
      title: localization.settingsPage_resetApp_resetAppTitle,
      onPress: showDeleteConfirmationDialog,
      color: Colors.red,
      trailing: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }
}
