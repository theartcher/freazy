import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freazy/models/backup_state.dart';
import 'package:freazy/utils/databases/database_backup.dart';
import 'package:freazy/widgets/messenger.dart';
import 'package:freazy/widgets/settings/pressable_setting.dart';

class ExportSettings extends StatefulWidget {
  const ExportSettings({super.key});

  @override
  State<ExportSettings> createState() => _ExportSettingsState();
}

class _ExportSettingsState extends State<ExportSettings> {
  DatabaseBackup backup = DatabaseBackup();

  Future<void> onPress() async {
    BackupStates backupState = await backup.exportDatabaseToJson();

    switch (backupState) {
      case BackupStates.succes:
        MessengerService().showMessage(
          message: 'Export successfully',
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
          message: 'Storage permission is required your items.',
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

  //todo provide localization
  //todo show pop-up if no items are in the db
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PressableSettingTile(
          title: "Export database",
          description: "Stores all the items to a file on the device.",
          onPress: () => onPress(),
          trailing: const Icon(Icons.storage_rounded),
          disabled: !Platform.isAndroid,
        ),
      ],
    );
  }
}
