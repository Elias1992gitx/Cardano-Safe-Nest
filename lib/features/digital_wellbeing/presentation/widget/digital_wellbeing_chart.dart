import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';

class DigitalWellbeingSummary extends StatelessWidget {
  final DigitalWellbeing? digitalWellbeing;

  const DigitalWellbeingSummary({Key? key, this.digitalWellbeing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPlaceholder = digitalWellbeing == null;

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
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.05),
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
                        'Today\'s Summary',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isPlaceholder)
                        Chip(
                          label: Text(
                            'Placeholder',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.1),
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSummaryItem(
                    context,
                    'Total Screen Time',
                    _getTotalScreenTime(isPlaceholder),
                    Icons.access_time,
                    isPlaceholder: isPlaceholder,
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryItem(
                    context,
                    'Most Used App',
                    _getMostUsedApp(isPlaceholder),
                    Icons.star,
                    isPlaceholder: isPlaceholder,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
      BuildContext context, String title, String value, IconData icon,
      {required bool isPlaceholder}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isPlaceholder
                  ? Colors.grey.withOpacity(0.1)
                  : Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isPlaceholder
                  ? Colors.grey
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTotalScreenTime(bool isPlaceholder) {
    if (isPlaceholder) {
      return 'No data available';
    }
    final hours = digitalWellbeing!.totalScreenTime.inHours;
    final minutes = digitalWellbeing!.totalScreenTime.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  String _getMostUsedApp(bool isPlaceholder) {
    if (isPlaceholder) {
      return 'No data available';
    }
    final mostUsedApp = digitalWellbeing!.appUsages.values.reduce(
      (a, b) => a.usageTime > b.usageTime ? a : b,
    );
    return mostUsedApp.appName;
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
