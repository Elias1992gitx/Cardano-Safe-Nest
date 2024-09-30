import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safenest/features/profile/domain/entity/child.dart';
import 'package:safenest/features/profile/domain/entity/parental_info.dart';
import 'package:safenest/features/profile/presentation/bloc/parental_info_bloc.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:animations/animations.dart';
import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:safenest/core/common/widgets/custom_form_field.dart';

class EditParentalInfoPage extends StatefulWidget {
  final ParentalInfo initialParentalInfo;

  const EditParentalInfoPage({super.key, required this.initialParentalInfo});

  @override
  _EditParentalInfoPageState createState() => _EditParentalInfoPageState();
}

class _EditParentalInfoPageState extends State<EditParentalInfoPage> with SingleTickerProviderStateMixin {
  late ParentalInfo _parentalInfo;
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _parentalInfo = widget.initialParentalInfo;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _saveParentalInfo() {
    if (_formKey.currentState!.validate()) {
      context.read<ParentalInfoBloc>().add(UpdateParentalInfoEvent(_parentalInfo));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Parental Info', style: GoogleFonts.plusJakartaSans()),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveParentalInfo,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _animation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: 'Children',
                    content: _buildChildrenList(),
                  ),
                  _buildSection(
                    title: 'Emergency Contact',
                    content: _buildEmergencyContactForm(),
                  ),
                  _buildSection(
                    title: 'Notifications',
                    content: _buildNotificationSettings(),
                  ),
                  _buildSection(
                    title: 'Home Address',
                    content: _buildHomeAddressForm(),
                  ),
                  _buildSection(
                    title: 'Security',
                    content: _buildSecuritySettings(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: context.theme.dividerColor.withOpacity(0.1)),
      ),
      color: context.theme.cardColor.withOpacity(0.5),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenList() {
    return Column(
      children: [
        ..._parentalInfo.children.map((child) => _buildChildItem(child)),
        FFCustomButton(
          text: 'Add Child',
          onPressed: _addChild,
          options: FFButtonOptions(
            width: double.infinity,
            height: 50,
            color: context.theme.primaryColor,
            textStyle: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            borderRadius: BorderRadius.circular(25),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildChildItem(Child child) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: context.theme.primaryColor,
        child: Text(child.name[0], style: const TextStyle(color: Colors.white)),
      ),
      title: Text(child.name, style: GoogleFonts.plusJakartaSans()),
      subtitle: Text('Age: ${child.age}', style: GoogleFonts.plusJakartaSans()),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => _editChild(child),
      ),
    );
  }

  void _addChild() {
    // Implement add child logic
  }

  void _editChild(Child child) {
    // Implement edit child logic
  }

  Widget _buildEmergencyContactForm() {
    return Column(
      children: [
        CustomTextFormField(
          initialValue: _parentalInfo.emergencyContactName,
          labelText: 'Name',
          onChange: (value) {
            _parentalInfo = _parentalInfo.copyWith(emergencyContactName: value);
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          initialValue: _parentalInfo.emergencyContactPhone,
          labelText: 'Phone',
          textInputType: TextInputType.phone,
          onChange: (value) {
            _parentalInfo = _parentalInfo.copyWith(emergencyContactPhone: value);
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      children: [
        SwitchListTile(
          title: Text('Email Notifications', style: GoogleFonts.plusJakartaSans()),
          value: _parentalInfo.emailNotifications,
          onChanged: (value) {
            setState(() {
              _parentalInfo = _parentalInfo.copyWith(emailNotifications: value);
            });
          },
        ),
        SwitchListTile(
          title: Text('SMS Notifications', style: GoogleFonts.plusJakartaSans()),
          value: _parentalInfo.smsNotifications,
          onChanged: (value) {
            setState(() {
              _parentalInfo = _parentalInfo.copyWith(smsNotifications: value);
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _parentalInfo.notificationFrequency,
          items: ['Immediate', 'Daily', 'Weekly', 'Daily Summary']
              .map((freq) => DropdownMenuItem(value: freq, child: Text(freq, style: GoogleFonts.plusJakartaSans())))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _parentalInfo = _parentalInfo.copyWith(notificationFrequency: value);
              });
            }
          },
          decoration: InputDecoration(
            labelText: 'Notification Frequency',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: context.theme.cardColor,
          ),
        ),
      ],
    );
  }

  Widget _buildHomeAddressForm() {
    return Column(
      children: [
        CustomTextFormField(
          initialValue: _parentalInfo.homeAddress,
          labelText: 'Address',
          prefixIcon: const Icon(Icons.location_on),
          onChange: (value) {
            _parentalInfo = _parentalInfo.copyWith(homeAddress: value);
          },
        ),
        const SizedBox(height: 16),
        FFCustomButton(
          text: 'Select Location on Map',
          onPressed: _selectHomeLocation,
          options: FFButtonOptions(
            width: double.infinity,
            height: 50,
            color: context.theme.primaryColor,
            textStyle: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            borderRadius: BorderRadius.circular(25),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  void _selectHomeLocation() {
    // Implement location selection logic
  }

  Widget _buildSecuritySettings() {
    return FFCustomButton(
      text: 'Change PIN',
      onPressed: _changePin,
      options: FFButtonOptions(
        width: double.infinity,
        height: 50,
        color: context.theme.primaryColor,
        textStyle: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        borderRadius: BorderRadius.circular(25),
        elevation: 0,
      ),
    );
  }

  void _changePin() {
    // Implement PIN change logic
  }
}