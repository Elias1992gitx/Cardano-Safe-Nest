import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';

class MostUsedApps extends StatelessWidget {
  final Map<String, AppUsage>? appUsages;

  const MostUsedApps({Key? key, this.appUsages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPlaceholder = appUsages == null || appUsages!.isEmpty;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: AnimatedContainer(
        duration: const Duration(seconds: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            ],
          ),
        ),
        child: CustomPaint(
          painter: FancyBackgroundPainter(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Most Used Apps',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,

                      ),
                    ),
                    if (isPlaceholder)
                      _buildAnimatedChip(context),
                  ],
                ),
                const SizedBox(height: 20),
                isPlaceholder
                    ? _buildPlaceholderList(context)
                    : _buildAppList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedChip(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Chip(
            label: Text(
              'Updating',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
            avatar: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        );
      },
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
        final percentage = (app.value.usageTime.inMinutes /
                appUsages!.values.fold<int>(
                    0, (sum, usage) => sum + usage.usageTime.inMinutes) *
                100)
            .toStringAsFixed(1);
        return _buildListTile(
          context,
          leading: _buildAppIcon(context, app.value),
          title: app.value.appName,
          subtitle:
              '${app.value.usageTime.inHours}h ${app.value.usageTime.inMinutes.remainder(60)}m',
          trailing: '$percentage%',
        );
      },
    );
  }

  Widget _buildAppIcon(BuildContext context, AppUsage app) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: app.iconData != null
            ? Image.memory(
                app.iconData!,
                fit: BoxFit.cover,
              )
            : Center(
                child: Text(
                  app.appName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
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
        color: isPlaceholder
            ? Colors.grey[100]
            : Theme.of(context).colorScheme.background.withOpacity(0.3),
      ),
      child: ListTile(
        leading: leading,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: isPlaceholder
                ? Colors.grey[600]
                : Theme.of(context).colorScheme.onBackground,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              color: isPlaceholder
                  ? Colors.grey[400]
                  : Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.7)),
        ),
        trailing: Text(
          trailing,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: isPlaceholder
                ? Colors.grey[400]
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class FancyBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
          size.width * 0.25, size.height * 0.8, size.width * 0.5, size.height * 0.7)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.6, size.width, size.height * 0.8)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}