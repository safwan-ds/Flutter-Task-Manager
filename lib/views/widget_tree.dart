import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/data/notifiers.dart";
import "package:task_manager/data/styles.dart";
import "package:task_manager/views/pages/statistics_page.dart";
import "package:task_manager/views/pages/settings_page.dart";
import "package:task_manager/views/pages/tasks_page.dart";
import "package:task_manager/views/widgets/navbar.dart";
import "package:task_manager/views/widgets/navrail.dart";
import "package:task_manager/views/widgets/new_task_dialog.dart";

final GlobalKey<TasksPageState> uncompletedTasksKey =
    GlobalKey<TasksPageState>();

class WidgetTree extends StatefulWidget {
  const WidgetTree({
    super.key,
  });

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      TasksPage(
        key: uncompletedTasksKey,
        completed: false,
      ),
      StatisticsPage(),
      ListenableBuilder(
        builder: (context, child) {
          return TasksPage(
            key: const ValueKey("completed"),
            completed: true,
          );
        },
        listenable: categoryDeleteNotifier,
      ),
    ];
    double screenWidth = MediaQuery.of(context).size.width;

    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, int selectedPage, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              selectedPage,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              StringConstants.taskManager,
              style: LocalTextStyles.boldText,
            ),
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
          bottomNavigationBar: screenWidth < DoubleConstants.responsiveWidth
              ? NavBar(
                  selectedPage: selectedPage,
                )
              : null,
          body: Row(
            children: [
              if (screenWidth >= DoubleConstants.responsiveWidth)
                NavRail(
                  selectedPage: selectedPage,
                ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: pages,
                ),
              ),
            ],
          ),
          floatingActionButton: (selectedPage == 0)
              ? FloatingActionButton(
                  // elevation: 0.0,
                  child: const Icon(Icons.add_task),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return NewTaskDialog(
                          widget: uncompletedTasksKey.currentState!,
                        );
                      },
                    );
                  },
                )
              : null,
          // drawer: selectedPage == 1 ? child : null,
        );
      },
    );
  }
}
