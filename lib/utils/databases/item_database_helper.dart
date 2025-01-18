import 'package:freazy/models/item-autocomplete-suggestions.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:freazy/models/item.dart';

class ItemDatabaseHelper {
  static final ItemDatabaseHelper _instance = ItemDatabaseHelper._internal();
  static Database? _database;

  static const _table = "items";

  factory ItemDatabaseHelper() {
    return _instance;
  }

  ItemDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'freazy.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_table(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, weight NUMERIC, weightUnit TEXT, freezeDate DATETIME, expirationDate DATETIME, category TEXT, freezer TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> deleteAndRecreateDatabase() async {
    final path = join(await getDatabasesPath(), 'freazy.db');

    await deleteDatabase(path);
    _database = null;
    await _initDatabase();
  }

  Future<void> deleteDatabase(String path) async {
    await databaseFactory.deleteDatabase(path);
  }

  Future<void> insertItem(Item item) async {
    final db = await database;

    await db.insert(
      _table,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  Future<Item?> getItem(int id) async {
    final db = await database;

    List<Map> maps = await db.query(_table,
        columns: [
          'id',
          'title',
          'weight',
          'weightUnit',
          'freezeDate',
          'expirationDate',
          'category',
          'freezer'
        ],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Item.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateItem(Item item) async {
    final db = await database;

    await db
        .update(_table, item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<List<Item>> fetchItems() async {
    final db = await database;

    final List<Map<String, Object?>> itemMap = await db.query(_table);

    return itemMap.map((map) => Item.fromMap(map)).toList();
  }

  Future<List<String>> fetchExistingTitles() async {
    final db = await database;

    final List<Map<String, Object?>> itemMap = await db.query(_table);

    List<Item> items = itemMap.map((map) => Item.fromMap(map)).toList();

    return items.map((item) => item.title).toSet().toList();
  }

  Future<List<String>> fetchExistingCategories() async {
    final db = await database;

    final List<Map<String, Object?>> itemMap = await db.query(_table);

    List<Item> items = itemMap.map((map) => Item.fromMap(map)).toList();

    return items.map((item) => item.category).toSet().toList();
  }

  Future<List<String>> fetchExistingFreezers() async {
    final db = await database;

    final List<Map<String, Object?>> itemMap = await db.query(_table);

    List<Item> items = itemMap.map((map) => Item.fromMap(map)).toList();

    return items.map((item) => item.freezer).toSet().toList();
  }

  Future<List<String>> fetchExistingWeightUnits() async {
    final db = await database;

    final List<Map<String, Object?>> itemMap = await db.query(_table);

    List<Item> items = itemMap.map((map) => Item.fromMap(map)).toList();

    return items.map((item) => item.weightUnit).toSet().toList();
  }

  Future<ItemAutoCompleteSuggestions> fetchAutocompleteSuggestions() async {
    List<String> existingCategories = await fetchExistingCategories();
    List<String> existingTitles = await fetchExistingTitles();
    List<String> existingFreezers = await fetchExistingFreezers();
    List<String> existingWeightUnits = await fetchExistingWeightUnits();

    return ItemAutoCompleteSuggestions(
        categories: existingCategories,
        titles: existingTitles,
        freezers: existingFreezers,
        weightUnits: existingWeightUnits);
  }

  Future<String> fetchCommonWeightUnit() async {
    final db = await database;

    final List<Map<String, Object?>> itemMap = await db.query(_table);
    List<Item> items = itemMap.map((map) => Item.fromMap(map)).toList();
    Map<String, int> weightUnitCount = {};

    for (var item in items) {
      String weightUnit = item.weightUnit;
      if (weightUnitCount.containsKey(weightUnit)) {
        weightUnitCount[weightUnit] = weightUnitCount[weightUnit]! + 1;
      } else {
        weightUnitCount[weightUnit] = 1;
      }
    }

    String? mostCommonFreezer;
    int maxCount = 0;

    weightUnitCount.forEach((freezer, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommonFreezer = freezer;
      }
    });

    return mostCommonFreezer ?? 'g';
  }
}
