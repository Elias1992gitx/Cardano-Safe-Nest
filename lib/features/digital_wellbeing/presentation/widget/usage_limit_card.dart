import 'package:flutter/material.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';

class UsageLimitCard extends StatelessWidget {
  final Map<String, UsageLimit>? usageLimits;
  final Function(String, Duration) onSetLimit;
  final Function(String) onRemoveLimit;

  const UsageLimitCard({
    super.key,
    required this.usageLimits,
    required this.onSetLimit,
    required this.onRemoveLimit,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPlaceholder = usageLimits == null || usageLimits!.isEmpty;

    return Card(
      elevation: 0.05,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          width: .1,
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
              Theme.of(context).colorScheme.surface.withOpacity(.4),
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
                    'App Usage Limits',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  if (isPlaceholder)
                    Chip(
                      label: const Text('Placeholder'),
                      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              isPlaceholder
                  ? _buildPlaceholderList(context)
                  : _buildLimitsList(context),
              const SizedBox(height: 16),
              _buildSetLimitButton(context, isPlaceholder),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSetLimitButton(BuildContext context, bool isPlaceholder) {
    return ElevatedButton(
      onPressed: isPlaceholder ? null : () => _showSetLimitDialog(context),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, size: 18),
          SizedBox(width: 8),
          Text('Set New Limit', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildLimitsList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: usageLimits!.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final packageName = usageLimits!.keys.elementAt(index);
        final limit = usageLimits![packageName]!;
        return _buildLimitTile(context, packageName, limit);
      },
    );
  }

  Widget _buildLimitTile(BuildContext context, String packageName, UsageLimit limit) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: Icon(Icons.lock_clock, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(
        packageName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Daily limit: ${limit.dailyLimit.inHours}h ${limit.dailyLimit.inMinutes.remainder(60)}m',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
        onPressed: () => onRemoveLimit(packageName),
      ),
    );
  }

  Widget _buildPlaceholderList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.lock_clock, color: Colors.grey[400]),
          ),
          title: Text(
            'App ${index + 1}',
            style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'No limit set',
            style: TextStyle(color: Colors.grey[400]),
          ),
          trailing: Icon(Icons.more_vert, color: Colors.grey[400]),
        );
      },
    );
  }

  void _showSetLimitDialog(BuildContext context) {
    if (usageLimits == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot set limits with placeholder data')),
      );
      return;
    }
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
                decoration:
                    const InputDecoration(labelText: 'App Package Name'),
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
                  onSetLimit(
                      packageName, Duration(hours: hours, minutes: minutes));
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