import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/core/common/widgets/custom_form_field.dart';

class UsageLimitCard extends StatefulWidget {
  final Map<String, AppUsage> appUsages;
  final Map<String, UsageLimit>? usageLimits;
  final Function(String, Duration) onSetLimit;
  final Function(String) onRemoveLimit;

  const UsageLimitCard({
    Key? key,
    required this.appUsages,
    required this.usageLimits,
    required this.onSetLimit,
    required this.onRemoveLimit,
  }) : super(key: key);

  @override
  _UsageLimitCardState createState() => _UsageLimitCardState();
}

class _UsageLimitCardState extends State<UsageLimitCard> {
  List<MapEntry<String, AppUsage>> _socialMediaApps = [];

  @override
  void initState() {
    super.initState();
    _updateSocialMediaApps();
  }

  @override
  void didUpdateWidget(UsageLimitCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.appUsages != oldWidget.appUsages) {
      _updateSocialMediaApps();
    }
  }

  void _updateSocialMediaApps() {
    setState(() {
      _socialMediaApps = _getSocialMediaApps();
    });
  }

  List<MapEntry<String, AppUsage>> _getSocialMediaApps() {
    final socialMediaPackages = [
      'com.facebook.katana',
      'com.instagram.android',
      'com.twitter.android',
      'com.snapchat.android',
      'com.tiktok.android',
    ];
    return widget.appUsages.entries
        .where((entry) => socialMediaPackages.contains(entry.key))
        .toList()
      ..sort((a, b) => b.value.usageTime.compareTo(a.value.usageTime));
  }

  @override
  Widget build(BuildContext context) {
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
              
              _buildLimitsList(context),
              const SizedBox(height: 16),
              _buildSetLimitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLimitsList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _socialMediaApps.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final app = _socialMediaApps[index];
        final limit = widget.usageLimits?[app.key];
        return _buildLimitTile(context, app.value, limit);
      },
    );
  }

  Widget _buildLimitTile(
      BuildContext context, AppUsage app, UsageLimit? limit) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: Icon(Icons.lock_clock,
            color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(
        app.appName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usage: ${app.usageTime.inHours}h ${app.usageTime.inMinutes.remainder(60)}m',
            style: TextStyle(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
          ),
          if (limit != null)
            Text(
              'Limit: ${limit.dailyLimit.inHours}h ${limit.dailyLimit.inMinutes.remainder(60)}m',
              style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
            ),
        ],
      ),
      trailing: limit != null
          ? IconButton(
              icon: Icon(Icons.delete,
                  color: Theme.of(context).colorScheme.error),
              onPressed: () => widget.onRemoveLimit(app.packageName),
            )
          : null,
    );
  }

  Widget _buildSetLimitButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _showSetLimitDialog(context),
      icon: Icon(Icons.add,
          size: 18, color: Theme.of(context).colorScheme.primary),
      label: Text(
        'Set New Limit',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  void _showSetLimitDialog(BuildContext context) {
    String? selectedApp;
    int hours = 0;
    int minutes = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Set Usage Limit',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select App',
                      labelStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    dropdownColor: Theme.of(context).colorScheme.surface,
                    items: _socialMediaApps.map((app) {
                      return DropdownMenuItem(
                        value: app.key,
                        child: Text(app.value.appName),
                      );
                    }).toList(),
                    onChanged: (value) => selectedApp = value,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: 'Hours',
                        textInputType: TextInputType.number,
                        borderRadius: 5,
                        onChange: (value) => hours = int.tryParse(value) ?? 0,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: 'Minutes',
                        borderRadius: 5,

                        textInputType: TextInputType.number,
                        onChange: (value) => minutes = int.tryParse(value) ?? 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (selectedApp != null) {
                  widget.onSetLimit(
                      selectedApp!, Duration(hours: hours, minutes: minutes));
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Set Limit',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppIcon(BuildContext context, AppUsage app) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
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
            : Container(
                color: Theme.of(context).colorScheme.primary,
                child: Center(
                  child: Text(
                    app.appName[0].toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
