import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconly/iconly.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:shimmer/shimmer.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppUsageChart extends StatefulWidget {
  final Map<String, AppUsage>? appUsages;

  const AppUsageChart({Key? key, this.appUsages}) : super(key: key);

  @override
  _AppUsageChartState createState() => _AppUsageChartState();
}

class _AppUsageChartState extends State<AppUsageChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final bool isPlaceholder =
        widget.appUsages == null || widget.appUsages!.isEmpty;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface.withOpacity(0.9),
              Theme.of(context).colorScheme.surface.withOpacity(0.7),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'App Usage',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Icon(
                    IconlyLight.chart,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms).slideX(),
              Text(
                'Distribution',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideX(),
              const SizedBox(height: 16),
              _buildSeparator(context),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: isPlaceholder
                    ? _buildPlaceholderChart(context)
                    : _buildPieChart(context),
              ).animate().scale(duration: 500.ms, curve: Curves.easeInOut),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(delay: 300.ms);
  }

  Widget _buildPieChart(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: PieChart(
        PieChartData(
          sections: _generatePieChartSections(context),
          sectionsSpace: 2,
          centerSpaceRadius: 46,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (event is FlTapDownEvent || event is FlLongPressStart) {
                  touchedIndex =
                      pieTouchResponse?.touchedSection?.touchedSectionIndex ??
                          -1;
                } else if (event is FlTapUpEvent ||
                    event is FlLongPressEnd ||
                    event is FlPanEndEvent) {
                  touchedIndex = -1;
                }
              });
              if (event is FlTapUpEvent &&
                  pieTouchResponse?.touchedSection != null) {
                final index =
                    pieTouchResponse!.touchedSection!.touchedSectionIndex;
                if (index == _generatePieChartSections(context).length - 1) {
                  _showOthersTooltip(context);
                } else {
                  final appName =
                      widget.appUsages!.entries.elementAt(index).value.appName;
                  _showAppNameTooltip(context, appName);
                }
              }
            },
          ),
        ),
      ),
    ).animate().custom(
          duration: 1.seconds,
          builder: (context, value, child) {
            return Transform.rotate(
              angle: 2 * 3.14 * value,
              child: child,
            );
          },
        );
  }

  void _showAppNameTooltip(BuildContext context, String appName) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy,
        width: size.width,
        height: size.height,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 200),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.apps,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      appName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .scale(
                  duration: 200.ms,
                  curve: Curves.easeOutBack,
                )
                .fadeIn(duration: 200.ms),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(Duration(seconds: 2), () {
      entry?.remove();
    });
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

  List<PieChartSectionData> _generatePieChartSections(BuildContext context) {
    final List<PieChartSectionData> sections = [];
    final List<Color> colors = [
      Theme.of(context).colorScheme.primary.withOpacity(0.9),
      Theme.of(context).colorScheme.secondary.withOpacity(0.9),
      Theme.of(context).colorScheme.tertiary.withOpacity(0.9),
      Theme.of(context).colorScheme.error.withOpacity(0.9),
      Theme.of(context).colorScheme.primaryContainer.withOpacity(0.9),
    ];

    const double thresholdHours = 0.5; // Threshold for "Others" category
    double totalMinutes = 0;
    Map<String, double> otherApps = {};

    for (final entry in widget.appUsages!.entries) {
      totalMinutes += entry.value.usageTime.inMinutes.toDouble();
    }

    int colorIndex = 0;
    for (final entry in widget.appUsages!.entries) {
      final double hours = entry.value.usageTime.inMinutes / 60;
      if (hours >= thresholdHours) {
        final isTouched = colorIndex == touchedIndex;
        final double fontSize = isTouched ? 18 : 14;
        final double radius = isTouched ? 90 : 80;

        sections.add(
          PieChartSectionData(
            color: colors[colorIndex % colors.length],
            value: entry.value.usageTime.inMinutes.toDouble(),
            title: '${hours.toStringAsFixed(1)}h',
            radius: radius,
            titleStyle: GoogleFonts.poppins(
              color: context.theme.cardColor,
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
            ),
            badgeWidget: _buildAppIcon(entry.value),
            badgePositionPercentageOffset: 1.2,
          ),
        );
        colorIndex++;
      } else {
        otherApps[entry.key] = hours;
      }
    }

    if (otherApps.isNotEmpty) {
      final double otherHours = otherApps.values.reduce((a, b) => a + b);
      final isTouched = colorIndex == touchedIndex;
      final double fontSize = isTouched ? 18 : 14;
      final double radius = isTouched ? 90 : 80;

      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: otherHours * 60,
          title: 'Others',
          titlePositionPercentageOffset: 0.5,
          radius: radius,
          titleStyle: GoogleFonts.poppins(

            fontWeight: FontWeight.w600,
            fontSize: fontSize,
          ),
          badgeWidget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.more_horiz, size: 24),
              Text(
                '${otherHours.toStringAsFixed(1)}h',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize - 2,
                ),
              ),
            ],
          ),
          badgePositionPercentageOffset: 1.2,
        ),
      );
    }

    return sections;
  }

  Widget _buildAppIcon(AppUsage app) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: app.iconData != null
            ? Image.memory(
                app.iconData!,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              )
            : Icon(Icons.apps, size: 24, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildSeparator(BuildContext context) {
    return SizedBox(
      height: 2,
      child: CustomPaint(
        painter: GradientLinePainter(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ],
          ),
        ),
      ),
    ).animate().shimmer(duration: 2.seconds, curve: Curves.easeInOut);
  }

  void _showOthersTooltip(BuildContext context) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy,
        width: size.width,
        height: size.height,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 300, maxHeight: 400),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Other Apps',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 20),
                        onPressed: () => entry?.remove(),
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: _getOtherApps().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              _buildAppIcon(entry.value),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${entry.value.usageTime.inMinutes} mins',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .scale(
              duration: 200.ms,
              curve: Curves.easeOutBack,
            )
                .fadeIn(duration: 200.ms),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(Duration(seconds: 5), () {
      entry?.remove();
    });
  }

  Map<String, AppUsage> _getOtherApps() {
    const double thresholdHours = 0.5;
    Map<String, AppUsage> otherApps = {};

    for (final entry in widget.appUsages!.entries) {
      final double hours = entry.value.usageTime.inMinutes / 60;
      if (hours < thresholdHours) {
        otherApps[entry.key] = entry.value;
      }
    }

    return otherApps;
  }
}

class GradientLinePainter extends CustomPainter {
  final Gradient gradient;

  GradientLinePainter({required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = gradient.createShader(Offset.zero & size)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}