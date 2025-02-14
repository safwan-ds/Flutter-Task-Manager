import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/data/notifiers.dart";
import "package:task_manager/views/pages/charts_page.dart";
import "package:task_manager/views/pages/settings_page.dart";
import "package:task_manager/views/pages/tasks_page.dart";
import "widgets/navbar.dart";

List<Widget> pages = [
  TasksPage(),
  ChartsPage(),
  Text("Completed"),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Task Manager",
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              isDarkModeNotifier.value = !isDarkModeNotifier.value;
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setBool(
                  LocalConstants.themeModeKey, isDarkModeNotifier.value);
            },
            icon: ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (BuildContext context, bool value, Widget? child) {
                return Icon(
                  isDarkModeNotifier.value ? Icons.light_mode : Icons.dark_mode,
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SettingsPage();
                  },
                ),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(),
      drawer: SafeArea(
          child: Drawer(
        width: screenWidth < 500 ? 100 : 300,
      )),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages[selectedPage];
        },
      ),
    );
  }
}
