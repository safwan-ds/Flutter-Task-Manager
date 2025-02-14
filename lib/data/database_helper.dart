import "package:sqflite/sqflite.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import "package:path/path.dart";
import "package:task_manager/data/classes/task.dart";

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), "task_manager.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        dueDate TEXT,
        createdAt TEXT NOT NULL
      )
    """);
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert("tasks", task.toMap());
  }

  Future<List<Task>> getTasks({bool? isCompleted}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;

    if (isCompleted != null) {
      maps = await db.query(
        "tasks",
        where: "isCompleted = ?",
        whereArgs: [isCompleted ? 1 : 0],
        orderBy: "dueDate ASC",
      );
    } else {
      maps = await db.query("tasks", orderBy: "dueDate ASC");
    }

    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      "tasks",
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      "tasks",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
