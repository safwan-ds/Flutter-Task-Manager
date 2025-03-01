import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:task_manager/data/styles.dart";
import "package:task_manager/main.dart";
import "package:task_manager/views/widgets/task_card.dart";

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dbHelper.getTaskCountPerCategory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "You have no categories to show",
              style: LocalTextStyles.emptyPageText,
            ),
          );
        }

        List<PieChartSectionData> data = snapshot.data!.asMap().entries.map(
          (entry) {
            int index = entry.key;
            Map<String, dynamic> category = entry.value;

            // Define a list of available colors
            List<Color> availableColors = [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.orange,
              Colors.purple,
              Colors.cyan,
            ];

            return PieChartSectionData(
              color: availableColors[index % availableColors.length],
              value: (category["taskCount"] as int).toDouble(),
              title: category["categoryName"] as String,
              radius: 150.0,
            );
          },
        ).toList();
        List<DetailsText> stats = snapshot.data!
            .asMap()
            .entries
            .map((entry) => DetailsText(
                title: entry.value["categoryName"] + ": ",
                text: "${entry.value["taskCount"]} tasks"))
            .toList();

        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: stats,
              ),
              Flexible(
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 0,
                    sections: data,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
