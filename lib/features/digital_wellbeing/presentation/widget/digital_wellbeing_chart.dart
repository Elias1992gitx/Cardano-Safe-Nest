import 'package:flutter/material.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';

class DigitalWellbeingSummary extends StatelessWidget {
  final DigitalWellbeing digitalWellbeing;

  const DigitalWellbeingSummary({Key? key, required this.digitalWellbeing}) : super(key: key);

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
              'Today\'s Summary',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            _buildSummaryItem(
              context,
              'Total Screen Time',
              '${digitalWellbeing.totalScreenTime.inHours}h ${digitalWellbeing.totalScreenTime.inMinutes.remainder(60)}m',
              Icons.access_time,
            ),
            const SizedBox(height: 8),
            _buildSummaryItem(
              context,
              'Most Used App',
              _getMostUsedApp(),
              Icons.star,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.subtitle1),
        ),
        Text(value, style: Theme.of(context).textTheme.headline6),
      ],
    );
  }

  String _getMostUsedApp() {
    final mostUsedApp = digitalWellbeing.appUsages.values.reduce(
          (a, b) => a.usageTime > b.usageTime ? a : b,
    );
    return mostUsedApp.appName;
  }
}