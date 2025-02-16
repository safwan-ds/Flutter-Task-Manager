import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 7,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 3),
                      FlSpot(1, 1),
                      FlSpot(2, 4),
                      FlSpot(3, 1),
                      FlSpot(4, 2),
                      FlSpot(5, 4),
                      FlSpot(6, 1),
                    ],
                    isCurved: true,
                    color: Theme.of(context).colorScheme.primary,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 40,
                    title: "Flutter",
                    color: Colors.blue,
                    radius: 50,
                    titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 30,
                    title: "React",
                    color: Colors.green,
                    radius: 50,
                    titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 20,
                    title: "Xamarin",
                    color: Colors.red,
                    radius: 50,
                    titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 10,
                    title: "Ionic",
                    color: Colors.orange,
                    radius: 50,
                    titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: true),
                borderData: FlBorderData(show: true),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(toY: 8, color: Colors.blue),
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(toY: 10, color: Colors.blue),
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(toY: 14, color: Colors.blue),
                  ]),
                  BarChartGroupData(x: 3, barRods: [
                    BarChartRodData(toY: 15, color: Colors.blue),
                  ]),
                  BarChartGroupData(x: 4, barRods: [
                    BarChartRodData(toY: 13, color: Colors.blue),
                  ]),
                  BarChartGroupData(x: 5, barRods: [
                    BarChartRodData(toY: 10, color: Colors.blue),
                  ]),
                  BarChartGroupData(
                    x: 6,
                    barRods: [
                      BarChartRodData(toY: 8, color: Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
