import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';

class AppUsageChart extends StatelessWidget {
  final Map<String, AppUsage> appUsages;

  const AppUsageChart({Key? key, required this.appUsages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Usage Distribution',

            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _generatePieChartSections(),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _generatePieChartSections() {
    final List<PieChartSectionData> sections = [];
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
    ];

    int colorIndex = 0;
    for (final entry in appUsages.entries) {
      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: entry.value.usageTime.inMinutes.toDouble(),
          title: '${(entry.value.usageTime.inMinutes / 60).toStringAsFixed(1)}h',
          radius: 50,
          titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
      colorIndex++;
    }

    return sections;
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: appUsages.entries.map((entry) {
        return Chip(
          label: Text(entry.value.appName),
          backgroundColor: Colors.grey[200],
        );
      }).toList(),
    );
  }
}