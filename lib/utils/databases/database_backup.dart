import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:freazy/models/backup_state.dart';
import 'package:freazy/models/item.dart';
import 'package:freazy/utils/databases/item_database_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class DatabaseBackup {
  /// Prompts the user to select a file to import from.
  Future<String?> selectBackupFile() async {
    var backupJsonFiles = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    if (backupJsonFiles == null || backupJsonFiles.count <= 0) {
      // User canceled the file picker.
      return null;
    }

    return backupJsonFiles.files.first.path;
  }

  /// Imports items from a JSON file to the database.
  Future<BackupStates> importDatabaseFromJson(
      {required String filePath, bool removeExistingItem = false}) async {
    final ItemDatabaseHelper dbHelper = ItemDatabaseHelper();

    String unparsedFileContents = File(filePath).readAsStringSync();
    List<dynamic> jsonList = jsonDecode(unparsedFileContents);
    List<Item> itemsToImport =
        jsonList.map((item) => Item.fromJson(item)).toList();

    itemsToImport = removeInvalidItems(itemsToImport);

    if (removeExistingItem) {
      await dbHelper.deleteAndRecreateDatabase();
    }

    await dbHelper.insertItems(itemsToImport);

    return BackupStates.succes;
  }

  /// Exports all items in the database to a selected location in the form of a JSON file.
  Future<BackupStates> exportDatabaseToJson() async {
    final ItemDatabaseHelper dbHelper = ItemDatabaseHelper();
    List<Item> itemsToExport = await dbHelper.fetchItems();

    //Don't export an empty database.
    if (itemsToExport.isEmpty) {
      return BackupStates.noItems;
    }

    String exportFileName =
        "freazy_${DateTime.now().toString().replaceAll(':', '-')}_export.json";
    String itemsAsJson = jsonEncode(itemsToExport);

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) {
      // User canceled the picker
      return BackupStates.userCancel;
    }

    String fileNameWithPath =
        "$selectedDirectory${Platform.pathSeparator}$exportFileName";
    return _saveToFile(fileNameWithPath, itemsAsJson);
  }

  /// Stores a list of items to an export file in the specified directory.
  Future<BackupStates> _saveToFile(
      String fileLocation, String exportedJsonItems) async {
    if (Platform.isAndroid) {
      // For Android 10 (API level 29) and below
      final storagePermission =
          await Permission.manageExternalStorage.request();
      if (!storagePermission.isGranted) {
        return BackupStates.permissionsDenied;
      }
    }

    try {
      final exportFile = File(fileLocation);
      // Create parent directories if they don't exist
      await exportFile.parent.create(recursive: true);
      await exportFile.writeAsString(exportedJsonItems);
      return BackupStates.succes;
    } catch (error) {
      return BackupStates.unknownError;
    }
  }

  ///Filter out any items with invalid properties. (e.g. id that's null, freeze date being after the expiration date etc.)
  List<Item> removeInvalidItems(List<Item> unfilteredItems) {
    unfilteredItems.removeWhere(
      (item) =>
          item.id == null ||
          item.expirationDate.isBefore(item.freezeDate) ||
          item.title.isEmpty ||
          item.weight.isInfinite ||
          item.weight.isNaN ||
          item.weight <= 0 ||
          item.category.isEmpty ||
          item.freezer.isEmpty ||
          item.weightUnit.isEmpty,
    );

    return unfilteredItems;
  }
}
