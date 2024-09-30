import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/widgets/custom_form_field.dart';

class EmergencyContactsAndNotifications extends StatefulWidget {
  final Function(String, String, bool, bool, String) onUpdate;
  final String? initialName;
  final String? initialPhone;
  final bool initialEmailNotifications;
  final bool initialSmsNotifications;
  final String initialNotificationFrequency;

  const EmergencyContactsAndNotifications({
    super.key,
    required this.onUpdate,
    this.initialName,
    this.initialPhone,
    this.initialEmailNotifications = true,
    this.initialSmsNotifications = false,
    this.initialNotificationFrequency = 'Immediate',
  });

  @override
  _EmergencyContactsAndNotificationsState createState() => _EmergencyContactsAndNotificationsState();
}

class _EmergencyContactsAndNotificationsState extends State<EmergencyContactsAndNotifications> {
  late final TextEditingController emergencyContactNameController;
  late final TextEditingController emergencyContactPhoneController;
  late bool emailNotifications;
  late bool smsNotifications;
  late String notificationFrequency;

  @override
  void initState() {
    super.initState();
    emergencyContactNameController = TextEditingController(text: widget.initialName);
    emergencyContactPhoneController = TextEditingController(text: widget.initialPhone);
    emailNotifications = widget.initialEmailNotifications;
    smsNotifications = widget.initialSmsNotifications;
    notificationFrequency = widget.initialNotificationFrequency;
  }

  @override
  void dispose() {
    emergencyContactNameController.dispose();
    emergencyContactPhoneController.dispose();
    super.dispose();
  }

  void _updateParent() {
    widget.onUpdate(
      emergencyContactNameController.text,
      emergencyContactPhoneController.text,
      emailNotifications,
      smsNotifications,
      notificationFrequency,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 15,
                vertical: 25,
              ),
              child: Text(
                'Emergency Contacts and Notification Preferences',
                style: GoogleFonts.plusJakartaSans(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Contacts',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: emergencyContactNameController,
                  hintText: 'Emergency Contact Name',
                  validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                  borderRadius: 0,
                  onChange: (_) => _updateParent(),
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: emergencyContactPhoneController,
                  hintText: 'Emergency Contact Phone',
                  validator: (value) => value!.isEmpty ? 'Please enter a phone number' : null,
                  borderRadius: 0,
                  onChange: (_) => _updateParent(),
                ),
                const SizedBox(height: 20),
                Text(
                  'Notification Preferences',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text('Email Notifications'),
                  value: emailNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      emailNotifications = value;
                    });
                    _updateParent();
                  },
                ),
                SwitchListTile(
                  title: const Text('SMS Notifications'),
                  value: smsNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      smsNotifications = value;
                    });
                    _updateParent();
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Notification Frequency',
                  ),
                  value: notificationFrequency,
                  items: ['Immediate', 'Daily Summary', 'Weekly Summary']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      notificationFrequency = newValue!;
                    });
                    _updateParent();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}