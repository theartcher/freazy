import 'package:flutter/material.dart';
import 'package:freazy/utils/background_manager.dart';
import 'package:freazy/utils/databases/item_database_helper.dart';
import 'package:freazy/utils/settings/preferences_manager.dart';
import 'package:freazy/widgets/settings/pressable_setting.dart';

class ResetAppSetting extends StatefulWidget {
  const ResetAppSetting({super.key});

  @override
  State<ResetAppSetting> createState() => _ResetAppSettingState();
}

class _ResetAppSettingState extends State<ResetAppSetting> {
  @override
  Widget build(BuildContext context) {
    void showDeleteConfirmationDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          bool confirmResetApp = false;

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Weet u zeker dat u de app wilt resetten?'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Deze actie kan niet ongedaan worden gemaakt. Dit verwijderd al uw producten, instellingen en andere voorkeuren.',
                      ),
                      const SizedBox(height: 10), // Add spacing
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
                          const Expanded(
                            child:
                                Text('Ik begrijp de gevolgen van deze actie.'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Annuleren'),
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
                      'Verwijderen',
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
      title: 'Reset app',
      onPress: showDeleteConfirmationDialog,
      color: Colors.red,
      icon: Icons.delete,
    );
  }
}
