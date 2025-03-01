import "dart:developer";
import "package:sqflite/sqflite.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import "package:path/path.dart";
import "package:task_manager/data/classes/category.dart";
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
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create the categories table
    await db.execute("""
    CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    )
  """);

    // Create the tasks table with an optional category_id column.
    // Note: Foreign key constraints in SQLite need to be enabled explicitly.
    await db.execute(
      """
        CREATE TABLE tasks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          isCompleted INTEGER NOT NULL,
          dueDate TEXT,
          createdAt TEXT NOT NULL,
          category_id INTEGER,
          priority INTEGER,
          FOREIGN KEY (category_id) REFERENCES categories(id)
        )
      """,
    );
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert("tasks", task.toMap());
  }

  Future<List<Task>> getTasks({bool? isCompleted}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;

    if (isCompleted != null) {
      maps = await db.rawQuery(
        """
          SELECT tasks.*, categories.name as categoryName
          FROM tasks
          LEFT JOIN categories ON tasks.category_id = categories.id
          WHERE tasks.isCompleted = ?
          ORDER BY tasks.dueDate ASC
        """,
        [isCompleted ? 1 : 0],
      );
    } else {
      maps = await db.rawQuery(
        """
          SELECT tasks.*, categories.name as categoryName
          FROM tasks
          LEFT JOIN categories ON tasks.category_id = categories.id
          ORDER BY tasks.dueDate ASC
        """,
      );
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

  // Insert a new category
  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert("categories", category.toMap());
  }

// Get all categories
  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query("categories", orderBy: "name ASC");
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.transaction((txn) async {
      // Disassociate tasks from the category by setting category_id to null
      await txn.update(
        "tasks",
        {"category_id": null},
        where: "category_id = ?",
        whereArgs: [id],
      );
      // Now safely delete the category
      return await txn.delete(
        "categories",
        where: "id = ?",
        whereArgs: [id],
      );
    });
  }

  Future<List<Map<String, dynamic>>> getTaskCountPerCategory() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      """
        SELECT 
          categories.id AS categoryId, 
          categories.name AS categoryName, 
          COUNT(tasks.id) AS taskCount
        FROM categories
        LEFT JOIN tasks ON categories.id = tasks.category_id
        GROUP BY categories.id
        ORDER BY categories.name ASC
      """,
    );
    return results;
  }

  // Add this to your DatabaseHelper class
  Future<void> validateDatabase() async {
    try {
      final db = await database;

      // Check if required tables exist with correct schema
      bool isValid = true;

      // Verify tasks table schema
      final taskTableCheck = await db.rawQuery(
          "SELECT name FROM pragma_table_info('tasks') ORDER BY name");
      final expectedTaskColumns = [
        "category_id",
        "createdAt",
        "description",
        "dueDate",
        "id",
        "isCompleted",
        "priority",
        "title",
      ];

      if (taskTableCheck.length != expectedTaskColumns.length) {
        isValid = false;
      } else {
        for (int i = 0; i < expectedTaskColumns.length; i++) {
          if (taskTableCheck[i]["name"] != expectedTaskColumns[i]) {
            isValid = false;
            break;
          }
        }
      }

      // Verify categories table schema
      final categoryTableCheck = await db.rawQuery(
          "SELECT name FROM pragma_table_info('categories') ORDER BY name");
      final expectedCategoryColumns = ["id", "name"];

      if (categoryTableCheck.length != expectedCategoryColumns.length) {
        isValid = false;
      } else {
        for (int i = 0; i < expectedCategoryColumns.length; i++) {
          if (categoryTableCheck[i]["name"] != expectedCategoryColumns[i]) {
            isValid = false;
            break;
          }
        }
      }

      // If database is invalid, recreate it
      if (!isValid) {
        log("Database format invalid. Recreating database...");
        await recreateDatabase(db);
      }
    } catch (e) {
      log("Error validating database: $e");
      // Database might be corrupted, recreate it
      await recreateDatabase(await database);
    }
  }

  Future<void> recreateDatabase(Database db) async {
    // Get database path
    String path = join(await getDatabasesPath(), "task_manager.db");

    // Close the database
    await db.close();

    // Delete the existing database file
    await deleteDatabase(path);

    // Reinitialize database
    _database = null;
    await database;

    log("Database recreated successfully!");
  }
}
