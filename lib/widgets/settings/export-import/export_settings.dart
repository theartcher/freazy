import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freazy/models/backup_state.dart';
import 'package:freazy/utils/databases/database_backup.dart';
import 'package:freazy/widgets/messenger.dart';
import 'package:freazy/widgets/settings/pressable_setting.dart';
import 'package:go_router/go_router.dart';

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
          position: MessagePosition.bottom,
        );
        break;

      case BackupStates.userCancel:
        MessengerService().showMessage(
          message: 'The export was cancelled',
          type: MessageType.info,
          position: MessagePosition.top,
        );
        break;

      case BackupStates.noItems:
        MessengerService().showMessage(
          message: 'You have no items to export.',
          type: MessageType.info,
          position: MessagePosition.bottom,
        );
        break;

      case BackupStates.permissionsDenied:
        MessengerService().showMessage(
          message: 'Storage permission is required to export your items.',
          type: MessageType.error,
          position: MessagePosition.bottom,
        );
        break;

      case BackupStates.unknownError:
        MessengerService().showMessage(
          message: 'An unknown error occurred during the export..',
          type: MessageType.error,
          position: MessagePosition.bottom,
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
          position: MessagePosition.bottom,
        );
        break;

      case BackupStates.userCancel:
        MessengerService().showMessage(
          message: 'Import was cancelled',
          type: MessageType.info,
          position: MessagePosition.top,
        );
        break;

      case BackupStates.noItems:
        MessengerService().showMessage(
          message: 'This import file has no items.',
          type: MessageType.info,
          position: MessagePosition.bottom,
        );
        break;

      case BackupStates.permissionsDenied:
        MessengerService().showMessage(
          message: 'Storage permission is required to import your items.',
          type: MessageType.error,
          position: MessagePosition.bottom,
        );
        break;

      case BackupStates.unknownError:
        MessengerService().showMessage(
          message: 'An unknown error occurred during the import..',
          type: MessageType.error,
          position: MessagePosition.bottom,
        );
        break;

      default:
        break;
    }
  }

  //todo provide localization
  //todo show toast if no items are in the db
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void showClearExistingItemsDialogue() {
      bool clearExistingItems = false;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text("Clear existing items?"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      BackupStates backupState =
                          await backup.importDatabaseFromJson(
                        removeExistingItem: clearExistingItems,
                      );

                      //Double pop to close the dialog and the settings page
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pop(true);

                      _sendImportMessage(backupState);
                    },
                    child: Text(
                      "Select file",
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
          title: "Export database",
          description: "Stores all the items to a file on the device.",
          onPress: () => onPressExport(),
          trailing: const Icon(Icons.file_upload),
          disabled: !Platform.isAndroid,
        ),
        PressableSettingTile(
          title: "Import database",
          description: "Recovers items from an export file.",
          onPress: () => showClearExistingItemsDialogue(),
          trailing: const Icon(Icons.file_download),
          disabled: !Platform.isAndroid,
        ),
      ],
    );
  }
}
