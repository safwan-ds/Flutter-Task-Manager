import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/data/database_helper.dart";
import "package:task_manager/data/notifiers.dart";
import "package:task_manager/views/pages/statistics_page.dart";
import "package:task_manager/views/pages/settings_page.dart";
import "package:task_manager/views/pages/tasks_page.dart";
import "package:task_manager/views/widgets/navbar.dart";
import "package:task_manager/views/widgets/new_task_dialog.dart";

final GlobalKey<TasksPageState> uncompletedTasksKey =
    GlobalKey<TasksPageState>();

class WidgetTree extends StatelessWidget {
  const WidgetTree({
    super.key,
    required this.dbHelper,
  });

  final DatabaseHelper dbHelper;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      TasksPage(
        key: uncompletedTasksKey,
        completed: false,
        dbHelper: dbHelper,
      ),
      StatisticsPage(),
      TasksPage(
        key: const ValueKey("completed"),
        completed: true,
        dbHelper: dbHelper,
      ),
    ];
    double screenWidth = MediaQuery.of(context).size.width;

    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, int selectedPage, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(StringConstants.taskManager),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () async {
                  isDarkModeNotifier.value = !isDarkModeNotifier.value;
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool(
                    StringConstants.themeModeKey,
                    isDarkModeNotifier.value,
                  );
                },
                icon: ValueListenableBuilder(
                  valueListenable: isDarkModeNotifier,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return Icon(
                      isDarkModeNotifier.value
                          ? Icons.light_mode
                          : Icons.dark_mode,
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
                        return const SettingsPage();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          bottomNavigationBar: screenWidth < 640
              ? NavBar(
                  selectedPage: selectedPage,
                )
              : null,
          body: Row(
            children: [
              if (screenWidth >= 640)
                NavigationRail(
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.event_note_outlined),
                      selectedIcon: Icon(Icons.event_note),
                      label: Text(StringConstants.tasks),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.pie_chart_outline),
                      selectedIcon: Icon(Icons.pie_chart),
                      label: Text(StringConstants.statistics),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.event_available_outlined),
                      selectedIcon: Icon(Icons.event_available),
                      label: Text(StringConstants.completed),
                    ),
                  ],
                  selectedIndex: selectedPage,
                  onDestinationSelected: (int selectedPage) {
                    selectedPageNotifier.value = selectedPage;
                  },
                ),
              Expanded(child: pages[selectedPage]),
            ],
          ),
          floatingActionButton: (selectedPage == 0)
              ? FloatingActionButton(
                  child: const Icon(Icons.add_task),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return NewTaskDialog(
                          dbHelper: dbHelper,
                          // Here you can pass a callback to trigger a refresh if needed.
                          setState: uncompletedTasksKey.currentState?.refresh,
                        );
                      },
                    );
                  },
                )
              : null,
          drawer: selectedPage == 1 ? child : null,
        );
      },
      child: SafeArea(
        child: const Drawer(),
      ),
    );
  }
}
