import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safenest/features/profile/domain/entity/child.dart';
import 'package:safenest/features/profile/domain/entity/parental_info.dart';
import 'package:safenest/features/profile/presentation/bloc/parental_info_bloc.dart';
import 'package:safenest/features/profile/presentation/widget/parental-profile/child_info.dart';
import 'package:safenest/features/profile/presentation/widget/parental-profile/emergency_notification.dart';
import 'package:safenest/features/profile/presentation/widget/parental-profile/home_address_location.dart';
import 'package:safenest/features/profile/presentation/widget/parental-profile/set_security.dart';

class EditParentalInfoPage extends StatefulWidget {
  final ParentalInfo initialParentalInfo;

  const EditParentalInfoPage({super.key, required this.initialParentalInfo});

  @override
  _EditParentalInfoPageState createState() => _EditParentalInfoPageState();
}

class _EditParentalInfoPageState extends State<EditParentalInfoPage> {
  late ParentalInfo _parentalInfo;
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _parentalInfo = widget.initialParentalInfo;
  }

  void _updateChildren(List<Child> children) {
    setState(() {
      _parentalInfo = _parentalInfo.copyWith(children: children);
    });
  }

  void _updateEmergencyContact(
      String name, String phone, bool email, bool sms, String frequency) {
    setState(() {
      _parentalInfo = _parentalInfo.copyWith(
        emergencyContactName: name,
        emergencyContactPhone: phone,
        emailNotifications: email,
        smsNotifications: sms,
        notificationFrequency: frequency,
      );
    });
  }

  void _updateHomeLocation(LatLng location, String address) {
    setState(() {
      _parentalInfo = _parentalInfo.copyWith(
        homeLocation: location,
        homeAddress: address,
      );
    });
  }

  void _updatePin(String pin) {
    setState(() {
      _parentalInfo = _parentalInfo.copyWith(pin: pin);
    });
  }

  void _saveParentalInfo() {
    context
        .read<ParentalInfoBloc>()
        .add(UpdateParentalInfoEvent(_parentalInfo));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Parental Info', style: GoogleFonts.plusJakartaSans()),
      ),
      body: PageView(controller: _pageController, children: [
        ChildInfo(
          onChildAdded: (child) =>
              _updateChildren([..._parentalInfo.children, child]),
          children: _parentalInfo.children,
        ),
        EmergencyContactsAndNotifications(
          onUpdate: _updateEmergencyContact,
          initialName: _parentalInfo.emergencyContactName,
          initialPhone: _parentalInfo.emergencyContactPhone,
          initialEmailNotifications: _parentalInfo.emailNotifications,
          initialSmsNotifications: _parentalInfo.smsNotifications,
          initialNotificationFrequency: _parentalInfo.notificationFrequency,
        ),
        HomeAddressLocation(
          onLocationSelected: _updateHomeLocation,
          initialLocation: _parentalInfo.homeLocation,
          initialAddress: _parentalInfo.homeAddress,
        ),
        SetPinPage(
          onPinSet: _updatePin,
          initialPin: _parentalInfo.pin,
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                if (_pageController.page! > 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text('Previous', style: GoogleFonts.plusJakartaSans()),
            ),
            TextButton(
              onPressed: () {
                if (_pageController.page! < 3) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _saveParentalInfo();
                }
              },
              child: Text(_pageController.page == 3 ? 'Save' : 'Next',
                  style: GoogleFonts.plusJakartaSans()),
            ),
          ],
        ),
      ),
    );
  }
}
