import "dart:io";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/data/notifiers.dart";
import "package:task_manager/views/widget_tree.dart";
import "package:task_manager/data/database_helper.dart";

// Global singleton instance of DatabaseHelper.
final DatabaseHelper dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved theme mode
  void initThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? savedThemeMode = prefs.getBool(StringConstants.themeModeKey);
    isDarkModeNotifier.value = savedThemeMode ?? false;
  }

  // Initialize sqflite for desktop platforms.
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Load the dark mode setting before running the app.
  initThemeMode();

  final dbHelper = DatabaseHelper();
  await dbHelper.validateDatabase();

  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: Colors.greenAccent,
            brightness:
                isDarkModeNotifier.value ? Brightness.dark : Brightness.light,
            useMaterial3: true,
          ),
          // Pass the global dbHelper instance to the widget tree.
          home: TaskManager(),
        );
      },
    );
  }
}

class TaskManager extends StatefulWidget {
  const TaskManager({
    super.key,
  });

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  @override
  Widget build(BuildContext context) {
    // Now WidgetTree (and its children) can access the same dbHelper instance.
    return WidgetTree();
  }
}
