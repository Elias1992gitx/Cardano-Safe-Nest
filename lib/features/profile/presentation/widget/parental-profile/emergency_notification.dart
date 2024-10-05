import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:safenest/core/common/widgets/custom_form_field.dart';
import 'package:safenest/features/auth/data/models/user_model.dart';

class EmergencyContactsAndNotifications extends StatefulWidget {
  final Function(String, String, bool, bool, String) onUpdate;
  final String? initialName;
  final String? initialPhone;
  final bool initialEmailNotifications;
  final bool initialSmsNotifications;
  final String initialNotificationFrequency;
  final LocalUserModel currentUser;

  const EmergencyContactsAndNotifications({
    super.key,
    required this.onUpdate,
    required this.currentUser,
    this.initialName,
    this.initialPhone,
    this.initialEmailNotifications = true,
    this.initialSmsNotifications = false,
    this.initialNotificationFrequency = 'Immediate',
  });

  @override
  _EmergencyContactsAndNotificationsState createState() =>
      _EmergencyContactsAndNotificationsState();
}

class _EmergencyContactsAndNotificationsState
    extends State<EmergencyContactsAndNotifications> {
  late final TextEditingController emergencyContactNameController;
  late final PhoneController emergencyContactPhoneController;
  late bool emailNotifications;
  late bool smsNotifications;
  late String notificationFrequency;

  @override
  void initState() {
    super.initState();
    emergencyContactNameController = TextEditingController(
      text: widget.initialName ?? widget.currentUser.username,
    );
    emergencyContactPhoneController = PhoneController();

    // Set the phone number value after initializing the controller
    if (widget.initialPhone != null || widget.currentUser.phoneNumber != null) {
      emergencyContactPhoneController.value = PhoneNumber(
        isoCode: IsoCode
            .US, // You might want to set this dynamically based on the user's country
        nsn: widget.initialPhone ?? widget.currentUser.phoneNumber ?? '',
      );
    }

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
    final name = emergencyContactNameController.text.isNotEmpty
        ? emergencyContactNameController.text
        : widget.currentUser.username;
    final phone = emergencyContactPhoneController.value?.nsn ??
        widget.currentUser.phoneNumber ??
        '';

    widget.onUpdate(
      name,
      phone,
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
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                  borderRadius: 0,
                  onChange: (_) => _updateParent(),
                ),
                const SizedBox(height: 10),
                PhoneFormField(
                  controller: emergencyContactPhoneController,
                  isCountryButtonPersistent: true,
                  countryButtonStyle: const CountryButtonStyle(
                    showIsoCode: true,
                    flagSize: 15,
                  ),
                  validator: (value) {
                    if (value == null || !value.isValid()) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Emergency Contact Phone',
                    filled: true,
                    prefixStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                    counterText: '',
                    labelStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                      ),
                    ),
                    hintStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Theme.of(context)
                        .colorScheme
                        .tertiaryContainer
                        .withOpacity(.5),
                    contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(20, 18, 0, 18),
                  ),
                  onChanged: (_) => _updateParent(),
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
