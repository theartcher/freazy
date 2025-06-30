import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freazy/models/backup_state.dart';
import 'package:freazy/models/item.dart';
import 'package:freazy/utils/databases/database_backup.dart';
import 'package:freazy/utils/databases/item_database_helper.dart';
import 'package:freazy/widgets/messenger.dart';
import 'package:freazy/widgets/settings/pressable_setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExportSettings extends StatefulWidget {
  const ExportSettings({super.key});

  @override
  State<ExportSettings> createState() => _ExportSettingsState();
}

class _ExportSettingsState extends State<ExportSettings> {
  DatabaseBackup backup = DatabaseBackup();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context)!;

    void sendExportMessage(BackupStates state) {
      switch (state) {
        case BackupStates.succes:
          MessengerService().showMessage(
            message:
                localization.settingsPage_exportDatabase_exportDatabaseSuccess,
            type: MessageType.success,
          );
          break;

        case BackupStates.userCancel:
          MessengerService().showMessage(
            message: localization
                .settingsPage_exportDatabase_exportDatabaseCancelled,
            type: MessageType.error,
          );
          break;

        case BackupStates.noItems:
          MessengerService().showMessage(
            message: localization.settingsPage_exportDatabase_exportNoItems,
            type: MessageType.error,
          );
          break;

        case BackupStates.permissionsDenied:
          MessengerService().showMessage(
            message: localization
                .settingsPage_exportDatabase_exportStoragePermissionRequired,
            type: MessageType.error,
          );
          break;

        case BackupStates.unknownError:
          MessengerService().showMessage(
            message:
                localization.settingsPage_exportDatabase_exportUnknownError,
            type: MessageType.error,
          );
          break;

        default:
          break;
      }
    }

    void sendImportMessage(BackupStates state) {
      switch (state) {
        case BackupStates.succes:
          MessengerService().showMessage(
            message:
                localization.settingsPage_exportDatabase_importDatabaseSuccess,
            type: MessageType.success,
          );
          break;

        case BackupStates.userCancel:
          MessengerService().showMessage(
            message: localization
                .settingsPage_exportDatabase_importDatabaseCancelled,
            type: MessageType.error,
          );
          break;

        case BackupStates.noItems:
          MessengerService().showMessage(
            message: localization.settingsPage_exportDatabase_importNoItems,
            type: MessageType.error,
          );
          break;

        case BackupStates.permissionsDenied:
          MessengerService().showMessage(
            message: localization
                .settingsPage_exportDatabase_importStoragePermissionRequired,
            type: MessageType.error,
          );
          break;

        case BackupStates.unknownError:
          MessengerService().showMessage(
            message:
                localization.settingsPage_exportDatabase_importUnknownError,
            type: MessageType.error,
          );
          break;

        default:
          break;
      }
    }

    Future<void> onPressExport() async {
      BackupStates backupState = await backup.exportDatabaseToJson();
      sendExportMessage(backupState);
    }

    onConfirmImport(String selectedFilePath, bool clearExistingItems) async {
      BackupStates backupState = await backup.importDatabaseFromJson(
        filePath: selectedFilePath,
        removeExistingItem: clearExistingItems,
      );
      sendImportMessage(backupState);
    }

    void showClearExistingItemsDialogue() async {
      String? selectedFilePath = await backup.selectBackupFile();
      List<Item> currentItems = await ItemDatabaseHelper().fetchItems();
      if (currentItems.isEmpty) {
        onConfirmImport(selectedFilePath!, false);
        // Close the settings page
        Navigator.of(context).pop(true);
        return;
      }

      if (selectedFilePath == null) {
        sendImportMessage(BackupStates.userCancel);
        return;
      }

      bool clearExistingItems = false;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text(
                  localization.settingsPage_importDatabase_dialogueTitle,
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization
                            .settingsPage_importDatabase_dialogueDescription,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: clearExistingItems,
                            onChanged: (newValue) {
                              setState(() {
                                clearExistingItems = newValue ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              localization
                                  .settingsPage_importDatabase_dialogueRemoveExistingItems,
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
                      //Single pop to kill dialogue only.
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      await onConfirmImport(
                        selectedFilePath,
                        clearExistingItems,
                      );

                      // Double pop to close the dialog and the settings page
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      localization
                          .settingsPage_importDatabase_dialogueImportConfirmation,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
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

    return Column(
      children: [
        PressableSettingTile(
          title: localization.settingsPage_exportDatabase_exportDatabaseTitle,
          description: localization
              .settingsPage_exportDatabase_exportDatabaseDescription,
          onPress: () => onPressExport(),
          trailing: const Icon(Icons.file_upload),
          disabled: !Platform.isAndroid,
        ),
        PressableSettingTile(
          title: localization.settingsPage_importDatabase_importDatabaseTitle,
          description: localization
              .settingsPage_importDatabase_importDatabaseDescription,
          onPress: () => showClearExistingItemsDialogue(),
          trailing: const Icon(Icons.file_download),
          disabled: !Platform.isAndroid,
        ),
      ],
    );
  }
}
