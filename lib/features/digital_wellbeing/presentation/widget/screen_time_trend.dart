


import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';

class ScreenTimeTrend extends StatelessWidget {
  final List<DigitalWellbeing>? history;

  const ScreenTimeTrend({Key? key, this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPlaceholder = history == null || history!.isEmpty;

    return Card(
      elevation: 0.05,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.onSurface,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: PatternPainter(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Screen Time Trend',
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      if (isPlaceholder)
                        Chip(
                          label: Text('Placeholder'),
                          backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: isPlaceholder
                        ? _buildPlaceholderChart(context)
                        : _buildLineChart(context),
                  ),
                  const SizedBox(height: 16),
                  _buildLegend(context, isPlaceholder),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderChart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timeline,
            size: 48,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'No data available',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < history!.length) {
                  return Transform.rotate(
                    angle: 45 * 3.1415926535 / 180,
                    child: Text(
                      DateFormat('dd/MM').format(history![index].date),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    ),
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
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: Theme.of(context).colorScheme.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  Theme.of(context).colorScheme.primary.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context, bool isPlaceholder) {
    final averageScreenTime = _calculateAverageScreenTime();
    final trend = _calculateTrend();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem(
          context,
          'Average',
          isPlaceholder ? 'N/A' : '${averageScreenTime.toStringAsFixed(1)}h',
          Icons.access_time,
          isPlaceholder: isPlaceholder,
        ),
        _buildLegendItem(
          context,
          'Trend',
          isPlaceholder ? 'N/A' : trend,
          trend == 'Increasing' ? Icons.trending_up : Icons.trending_down,
          color: trend == 'Increasing' ? Colors.red : Colors.green,
          isPlaceholder: isPlaceholder,
        ),
      ],
    );
  }

  Widget _buildLegendItem(
      BuildContext context,
      String title,
      String value,
      IconData icon, {
        Color? color,
        bool isPlaceholder = false,
      }) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isPlaceholder
                ? Colors.grey
                : (color ?? Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: isPlaceholder
                  ? Colors.grey
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isPlaceholder
                  ? Colors.grey
                  : Theme.of(context).colorScheme.onSurface,
              fontStyle: isPlaceholder ? FontStyle.italic : null,
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateSpots() {
    if (history == null || history!.isEmpty) {
      return [FlSpot(0, 0)];
    }
    return history!.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final hours = entry.value.totalScreenTime.inMinutes / 60;
      return FlSpot(index, hours);
    }).toList();
  }

  double _calculateAverageScreenTime() {
    if (history == null || history!.isEmpty) return 0;
    final totalHours = history!.fold<double>(
      0,
          (sum, item) => sum + (item.totalScreenTime.inMinutes / 60),
    );
    return totalHours / history!.length;
  }

  String _calculateTrend() {
    if (history == null || history!.length < 2) return 'Not enough data';
    final firstHalf = history!.sublist(0, history!.length ~/ 2);
    final secondHalf = history!.sublist(history!.length ~/ 2);

    final firstHalfAvg = firstHalf.fold<double>(
      0,
          (sum, item) => sum + (item.totalScreenTime.inMinutes / 60),
    ) /
        firstHalf.length;

    final secondHalfAvg = secondHalf.fold<double>(
      0,
          (sum, item) => sum + (item.totalScreenTime.inMinutes / 60),
    ) /
        secondHalf.length;

    return secondHalfAvg > firstHalfAvg ? 'Increasing' : 'Decreasing';
  }
}

class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final spacing = 20.0;
    for (double i = 0; i < size.width + size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(i, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
