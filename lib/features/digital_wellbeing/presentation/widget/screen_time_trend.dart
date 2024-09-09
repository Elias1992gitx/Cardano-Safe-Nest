import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' show pi;
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:intl/intl.dart';

class ScreenTimeTrend extends StatelessWidget {
  final List<DigitalWellbeing> history;

  const ScreenTimeTrend({Key? key, required this.history}) : super(key: key);

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
              'Screen Time Trend',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < history.length) {
                              return Transform.rotate(
                                angle: 45 * 3.1415926535 / 180,
                                child: Text(DateFormat('dd/MM').format(history[index].date)),
                              );
                            }
                            return const SizedBox();
                          },
                          reservedSize: 30,
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _generateSpots(),
                        isCurved: true,
                        color: Theme.of(context).primaryColor,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.2),
                              Theme.of(context).primaryColor.withOpacity(0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(context),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateSpots() {
    return history.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final hours = entry.value.totalScreenTime.inMinutes / 60;
      return FlSpot(index, hours);
    }).toList();
  }

  Widget _buildLegend(BuildContext context) {
    final averageScreenTime = _calculateAverageScreenTime();
    final trend = _calculateTrend();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLegendItem(
          context,
          'Average',
          '${averageScreenTime.toStringAsFixed(1)}h',
          Icons.access_time,
        ),
        _buildLegendItem(
          context,
          'Trend',
          trend,
          trend == 'Increasing' ? Icons.trending_up : Icons.trending_down,
          color: trend == 'Increasing' ? Colors.red : Colors.green,
        ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, String title, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(title, style: Theme.of(context).textTheme.caption),
        Text(value, style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  double _calculateAverageScreenTime() {
    final totalHours = history.fold<double>(
      0,
          (sum, item) => sum + (item.totalScreenTime.inMinutes / 60),
    );
    return totalHours / history.length;
  }

  String _calculateTrend() {
    if (history.length < 2) return 'Not enough data';
    final firstHalf = history.sublist(0, history.length ~/ 2);
    final secondHalf = history.sublist(history.length ~/ 2);

    final firstHalfAvg = firstHalf.fold<double>(
      0,
          (sum, item) => sum + (item.totalScreenTime.inMinutes / 60),
    ) / firstHalf.length;

    final secondHalfAvg = secondHalf.fold<double>(
      0,
          (sum, item) => sum + (item.totalScreenTime.inMinutes / 60),
    ) / secondHalf.length;

    return secondHalfAvg > firstHalfAvg ? 'Increasing' : 'Decreasing';
  }
}