import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/core/extensions/context_extensions.dart';

class DailyDigitalWellbeingSummary extends StatelessWidget {
  final DigitalWellbeing digitalWellbeing;

  const DailyDigitalWellbeingSummary({Key? key, required this.digitalWellbeing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),

        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Digital Wellbeing Summary',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.theme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildSummaryItem(context, 'Total Screen Time', _formatDuration(digitalWellbeing.totalScreenTime)),
              const SizedBox(height: 8),
              _buildSummaryItem(context, 'Most Used App', _getMostUsedApp()),
              const SizedBox(height: 8),
              _buildSummaryItem(context, 'App Unlocks', digitalWellbeing.appUsages.values.fold(0, (sum, usage) => sum + usage.openCount).toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: context.theme.textTheme.bodyMedium?.color,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: context.theme.primaryColor,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  String _getMostUsedApp() {
    final mostUsedApp = digitalWellbeing.appUsages.values.reduce(
          (a, b) => a.usageTime > b.usageTime ? a : b,
    );
    return mostUsedApp.appName;
  }
}