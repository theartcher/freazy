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

  Future<void> onPressExport() async {
    BackupStates backupState = await backup.exportDatabaseToJson();
    _sendExportMessage(backupState);
  }

  void _sendExportMessage(BackupStates state) {
    switch (state) {
      case BackupStates.succes:
        MessengerService().showMessage(
          message: 'Export successful',
          type: MessageType.success,
        );
        break;

      case BackupStates.userCancel:
        MessengerService().showMessage(
          message: 'The export was cancelled',
          type: MessageType.info,
        );
        break;

      case BackupStates.noItems:
        MessengerService().showMessage(
          message: 'You have no items to export.',
          type: MessageType.info,
        );
        break;

      case BackupStates.permissionsDenied:
        MessengerService().showMessage(
          message: 'Storage permission is required to export your items.',
          type: MessageType.error,
        );
        break;

      case BackupStates.unknownError:
        MessengerService().showMessage(
          message: 'An unknown error occurred during the export..',
          type: MessageType.error,
        );
        break;

      default:
        break;
    }
  }

  void _sendImportMessage(BackupStates state) {
    switch (state) {
      case BackupStates.succes:
        MessengerService().showMessage(
          message: 'Import successful',
          type: MessageType.success,
        );
        break;

      case BackupStates.userCancel:
        MessengerService().showMessage(
          message: 'Import was cancelled',
          type: MessageType.info,
        );
        break;

      case BackupStates.noItems:
        MessengerService().showMessage(
          message: 'This import file has no items.',
          type: MessageType.info,
        );
        break;

      case BackupStates.permissionsDenied:
        MessengerService().showMessage(
          message: 'Storage permission is required to import your items.',
          type: MessageType.error,
        );
        break;

      case BackupStates.unknownError:
        MessengerService().showMessage(
          message: 'An unknown error occurred during the import..',
          type: MessageType.error,
        );
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context)!;

    onConfirmImport(String selectedFilePath, bool clearExistingItems) async {
      BackupStates backupState = await backup.importDatabaseFromJson(
        filePath: selectedFilePath,
        removeExistingItem: clearExistingItems,
      );
      _sendImportMessage(backupState);
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
        _sendImportMessage(BackupStates.userCancel);
        return;
      }

      bool clearExistingItems = false;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text("Configure import "),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                          "Select whether or not to keep existing items."),
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
                          const Expanded(
                            child: Text("Clear existing items"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Cancel"),
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
                      "Import",
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
