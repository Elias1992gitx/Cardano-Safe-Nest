import 'package:flutter/material.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';

class UsageLimitCard extends StatelessWidget {
  final Map<String, Duration> usageLimits;
  final Function(String, Duration) onSetLimit;
  final Function(String) onRemoveLimit;

  const UsageLimitCard({
    Key? key,
    required this.usageLimits,
    required this.onSetLimit,
    required this.onRemoveLimit,
  }) : super(key: key);

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
              'App Usage Limits',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: usageLimits.length,
              itemBuilder: (context, index) {
                final entry = usageLimits.entries.elementAt(index);
                return ListTile(
                  title: Text(entry.key),
                  subtitle: Text('${entry.value.inHours}h ${entry.value.inMinutes.remainder(60)}m'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onRemoveLimit(entry.key),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showSetLimitDialog(context),
              child: const Text('Set New Limit'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSetLimitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String packageName = '';
        int hours = 0;
        int minutes = 0;

        return AlertDialog(
          title: const Text('Set Usage Limit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'App Package Name'),
                onChanged: (value) => packageName = value,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Hours'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => hours = int.tryParse(value) ?? 0,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Minutes'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => minutes = int.tryParse(value) ?? 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (packageName.isNotEmpty) {
                  onSetLimit(packageName, Duration(hours: hours, minutes: minutes));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Set Limit'),
            ),
          ],
        );
      },
    );
  }
}