import "package:flutter/material.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/data/notifiers.dart";

class NavRail extends StatelessWidget {
  const NavRail({super.key, required this.selectedPage});

  final int selectedPage;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
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
    );
  }
}
