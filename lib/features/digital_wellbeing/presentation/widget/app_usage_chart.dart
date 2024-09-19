import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';

class AppUsageChart extends StatelessWidget {
  final Map<String, AppUsage>? appUsages;

  const AppUsageChart({Key? key, this.appUsages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPlaceholder = appUsages == null || appUsages!.isEmpty;

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
              Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
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
                      Expanded(
                        child: Text(
                          'App Usage Distribution',
                          style: Theme.of(context).textTheme.headline6?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                        : _buildPieChart(context),
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
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 5000),
      baseColor: Theme.of(context).colorScheme.surface,
      highlightColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          Text(
            'N/A',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: _generatePieChartSections(context),
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            // Handle touch events if needed
          },
        ),
      ),
    );
  }

  List<PieChartSectionData> _generatePieChartSections(BuildContext context) {
    final List<PieChartSectionData> sections = [];
    final List<Color> colors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
      Theme.of(context).colorScheme.error,
      Theme.of(context).colorScheme.primaryContainer,
    ];

    int colorIndex = 0;
    for (final entry in appUsages!.entries) {
      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: entry.value.usageTime.inMinutes.toDouble(),
          title: '${(entry.value.usageTime.inMinutes / 60).toStringAsFixed(1)}h',
          radius: 50,
          titleStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
      colorIndex++;
    }

    return sections;
  }

  Widget _buildLegend(BuildContext context, bool isPlaceholder) {
    if (isPlaceholder) {
      return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surface,
        highlightColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        child: Column(
          children: List.generate(3, (index) =>
              Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: appUsages!.entries.map((entry) {
        final color = _getColorForApp(entry.key, context);
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 4,
              ),
              SizedBox(width: 4),
              Text(
                entry.value.appName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getColorForApp(String appName, BuildContext context) {
    final List<Color> colors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
      Theme.of(context).colorScheme.error,
      Theme.of(context).colorScheme.primaryContainer,
    ];

    final int colorIndex = appName.hashCode % colors.length;
    return colors[colorIndex];
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