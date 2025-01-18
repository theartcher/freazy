// import 'package:freazy/models/reminder.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class RemindersDatabaseHelper {
//   static final RemindersDatabaseHelper _instance =
//       RemindersDatabaseHelper._internal();
//   static Database? _database;

//   static const _table = "reminders";

//   factory RemindersDatabaseHelper() {
//     return _instance;
//   }

//   RemindersDatabaseHelper._internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<bool> _checkTableExists(Database db, String tableName) async {
//     final result = await db.rawQuery(
//         "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
//         [tableName]);
//     return result.isNotEmpty;
//   }

//   Future<Database> _initDatabase() async {
//     print("Initializing database...");
//     final db = await openDatabase(
//       join(await getDatabasesPath(), 'freazy.db'),
//       onCreate: (db, version) async {
//         print("Creating tables...");
//         await db.execute(
//           'CREATE TABLE $_table(id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, amount INTEGER)',
//         );
//       },
//       version: 1,
//     );

//     //TODO: Generic database helper, 2 tables means generic shit yippie
//     //TODO: Fix getting all reminders
//     //TODO: Remove prefernces reminders bullshit
//     //TODO: dont cry or go insane
//     //TODO: Add setting to select a time to receive notifications at

//     final tableExists = await _checkTableExists(db, _table);
//     if (!tableExists) {
//       print("Table does not exist. Creating now...");
//       await db.execute(
//         'CREATE TABLE $_table(id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, amount INTEGER)',
//       );
//     }

//     return db;
//   }

//   Future<int> insertReminder(Reminder reminder) async {
//     print("Adding a new reminder");
//     final db = await database;

//     return await db.insert(
//       _table,
//       reminder.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.rollback,
//     );
//   }

//   Future<Reminder?> getReminder(int id) async {
//     print("Got a new reminder");
//     final db = await database;

//     List<Map> maps = await db.query(
//       _table,
//       columns: ['id', 'type', 'amount'],
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (maps.isNotEmpty) {
//       return Reminder.fromMap(maps.first);
//     }
//     return null;
//   }

//   Future<List<Reminder>> fetchReminders() async {
//     print("Got all reminders");
//     final db = await database;

//     final List<Map<String, Object?>> remindersMap = await db.query(_table);

//     return remindersMap.map((map) => Reminder.fromMap(map)).toList();
//   }

//   Future<void> updateReminder(Reminder reminder) async {
//     print("Updated reminder ${reminder.id}");

//     final db = await database;

//     await db.update(
//       _table,
//       reminder.toMap(),
//       where: 'id = ?',
//       whereArgs: [reminder.id],
//     );
//   }

//   Future<int> deleteReminder(int id) async {
//     print("Deleted reminder ${id}");

//     final db = await database;

//     return await db.delete(_table, where: 'id = ?', whereArgs: [id]);
//   }

//   Future<void> deleteAndRecreateTable() async {
//     final db = await database;

//     await db.execute('DROP TABLE IF EXISTS $_table');
//     await db.execute(
//       'CREATE TABLE $_table(id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, amount INTEGER)',
//     );
//   }
// }
