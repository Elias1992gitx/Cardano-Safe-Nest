import 'package:flutter/material.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';

class MostUsedApps extends StatelessWidget {
  final Map<String, AppUsage>? appUsages;

  const MostUsedApps({Key? key, this.appUsages}) : super(key: key);

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
              Theme.of(context).colorScheme.onSurface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Most Used Apps',
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
              isPlaceholder
                  ? _buildPlaceholderList(context)
                  : _buildAppList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildListTile(
          context,
          leading: CircleAvatar(
            child: Icon(Icons.apps, color: Colors.grey[400]),
            backgroundColor: Colors.grey[200],
          ),
          title: 'App ${index + 1}',
          subtitle: 'No usage data',
          trailing: 'N/A',
          isPlaceholder: true,
        );
      },
    );
  }

  Widget _buildAppList(BuildContext context) {
    final sortedApps = appUsages!.entries.toList()
      ..sort((a, b) => b.value.usageTime.compareTo(a.value.usageTime));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedApps.length > 5 ? 5 : sortedApps.length,
      itemBuilder: (context, index) {
        final app = sortedApps[index];
        final percentage = (app.value.usageTime.inMinutes / appUsages!.values.fold<int>(0, (sum, usage) => sum + usage.usageTime.inMinutes) * 100).toStringAsFixed(1);
        return _buildListTile(
          context,
          leading: CircleAvatar(
            child: Text(app.value.appName[0], style: TextStyle(color: Colors.white)),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          title: app.value.appName,
          subtitle: '${app.value.usageTime.inHours}h ${app.value.usageTime.inMinutes.remainder(60)}m',
          trailing: '$percentage%',
        );
      },
    );
  }

  Widget _buildListTile(BuildContext context, {
    required Widget leading,
    required String title,
    required String subtitle,
    required String trailing,
    bool isPlaceholder = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isPlaceholder ? Colors.grey[100] : Theme.of(context).colorScheme.background.withOpacity(0.5),
      ),
      child: ListTile(
        leading: leading,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isPlaceholder ? Colors.grey[600] : Theme.of(context).colorScheme.onBackground,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: isPlaceholder ? Colors.grey[400] : Theme.of(context).colorScheme.onBackground.withOpacity(0.7)),
        ),
        trailing: Text(
          trailing,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isPlaceholder ? Colors.grey[400] : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}