import "package:flutter/material.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/data/notifiers.dart";

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.selectedPage,
  });

  final int selectedPage;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedPage,
      onDestinationSelected: (int selectedPage) {
        selectedPageNotifier.value = selectedPage;
      },
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.event_note_outlined),
          selectedIcon: Icon(Icons.event_note),
          label: StringConstants.tasks,
        ),
        NavigationDestination(
          icon: Icon(Icons.pie_chart_outline),
          selectedIcon: Icon(Icons.pie_chart),
          label: StringConstants.statistics,
        ),
        NavigationDestination(
          icon: Icon(Icons.event_available_outlined),
          selectedIcon: Icon(Icons.event_available),
          label: StringConstants.completed,
        ),
      ],
    );
  }
}
