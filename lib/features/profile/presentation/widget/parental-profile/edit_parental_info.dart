import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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

class _EditParentalInfoPageState extends State<EditParentalInfoPage>
    with SingleTickerProviderStateMixin {
  late ParentalInfo _parentalInfo;
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _animation;
  final List<String> validFrequencies = [
    'Immediate',
    'Daily',
    'Weekly',
    'Daily Summary'
  ];

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
      context
          .read<ParentalInfoBloc>()
          .add(UpdateParentalInfoEvent(_parentalInfo));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Edit Parental Info',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.theme.primaryColor,
                      context.theme.primaryColor.withOpacity(0.7),
                      context.theme.primaryColor.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: InkWell(
                  onTap: _saveParentalInfo,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.theme.primaryColor.withOpacity(0.7),
                          context.theme.primaryColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: context.theme.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.save, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Save',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _animation,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        title: 'Kids',
                        content: _buildChildrenList(),
                        icon: Icons.kitesurfing,
                      ),
                      _buildSection(
                        title: 'Emergency Contact',
                        content: _buildEmergencyContactForm(),
                        icon: Icons.emergency,
                      ),
                      _buildSection(
                        title: 'Notifications',
                        content: _buildNotificationSettings(),
                        icon: Icons.notifications,
                      ),
                      _buildSection(
                        title: 'Home Address',
                        content: _buildHomeAddressForm(),
                        icon: Icons.home,
                      ),
                      _buildSection(
                        title: 'Security',
                        content: _buildSecuritySettings(),
                        icon: Icons.security,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget content,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.theme.cardColor,
                context.theme.cardColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: context.theme.primaryColor, size: 28),
              ),
              title: Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.theme.primaryColor,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: content,
                ),
              ],
            ),
          ),
        ),
        Divider(color: context.theme.dividerColor.withOpacity(0.2), height: 1),
        SizedBox(
          height: 10,
        )
      ],
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
            elevation: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildChildItem(Child child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.theme.cardColor,
            context.theme.cardColor.withOpacity(0.8),
          ],
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: context.theme.primaryColor,
          radius: 25,
          child: Text(
            child.name[0],
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          child.name,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Age: ${child.age}',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: context.theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: context.theme.primaryColor),
          onPressed: () => _editChild(child),
        ),
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
            _parentalInfo =
                _parentalInfo.copyWith(emergencyContactPhone: value);
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      children: [
        SwitchListTile(
          title:
              Text('Email Notifications', style: GoogleFonts.plusJakartaSans()),
          value: _parentalInfo.emailNotifications,
          onChanged: (value) {
            setState(() {
              _parentalInfo = _parentalInfo.copyWith(emailNotifications: value);
            });
          },
        ),
        SwitchListTile(
          title:
              Text('SMS Notifications', style: GoogleFonts.plusJakartaSans()),
          value: _parentalInfo.smsNotifications,
          onChanged: (value) {
            setState(() {
              _parentalInfo = _parentalInfo.copyWith(smsNotifications: value);
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: validFrequencies.contains(_parentalInfo.notificationFrequency)
              ? _parentalInfo.notificationFrequency
              : validFrequencies.first,
          items: validFrequencies
              .map((freq) => DropdownMenuItem(
                  value: freq,
                  child: Text(freq, style: GoogleFonts.plusJakartaSans())))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _parentalInfo =
                    _parentalInfo.copyWith(notificationFrequency: value);
              });
            }
          },
          decoration: InputDecoration(
            labelText: 'Notification Frequency',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
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
