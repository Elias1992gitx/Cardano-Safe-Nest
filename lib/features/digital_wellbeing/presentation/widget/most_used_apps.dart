import 'package:flutter/material.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';

class MostUsedApps extends StatelessWidget {
  final Map<String, AppUsage> appUsages;

  const MostUsedApps({Key? key, required this.appUsages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedApps = appUsages.entries.toList()
      ..sort((a, b) => b.value.usageTime.compareTo(a.value.usageTime));

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Most Used Apps',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedApps.length > 5 ? 5 : sortedApps.length,
              itemBuilder: (context, index) {
                final app = sortedApps[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(app.value.appName[0]),
                  ),
                  title: Text(app.value.appName),
                  subtitle: Text('${app.value.usageTime.inHours}h ${app.value.usageTime.inMinutes.remainder(60)}m'),
                  trailing: Text(
                    '${(app.value.usageTime.inMinutes / appUsages.values.fold<int>(0, (sum, usage) => sum + usage.usageTime.inMinutes) * 100).toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.caption,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}