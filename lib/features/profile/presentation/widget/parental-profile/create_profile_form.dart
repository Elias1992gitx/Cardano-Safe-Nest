import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:safenest/features/auth/data/models/user_model.dart';
import 'package:safenest/core/common/app/providers/user_provider.dart';
import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:safenest/core/common/widgets/pattern_painter.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:safenest/features/profile/domain/entity/child.dart';
import 'package:safenest/features/profile/domain/entity/parental_info.dart';
import 'package:safenest/features/profile/presentation/bloc/parental_info_bloc.dart';
import 'package:safenest/features/profile/presentation/widget/parental-profile/child_info.dart';
import 'package:safenest/features/profile/presentation/widget/parental-profile/emergency_notification.dart';
import 'package:safenest/features/profile/presentation/widget/parental-profile/home_address_location.dart';
import 'package:safenest/features/profile/presentation/widget/parental-profile/set_security.dart';
import 'package:safenest/core/common/widgets/dashed_paint.dart';
import 'package:swipe_cards/swipe_cards.dart';

class CreateProfileFormBody extends StatefulWidget {
  const CreateProfileFormBody({super.key});

  @override
  State<CreateProfileFormBody> createState() => _CreateProfileFormBodyState();
}

class _CreateProfileFormBodyState extends State<CreateProfileFormBody> {
  double currentPage = 0;
  final _pageController = PageController();
  final formKey = GlobalKey<FormState>();
  final phoneNumController = TextEditingController();
  final moreDetailsController = TextEditingController();

  // Parent information properties
  final List<Child> _children = [];
  String? emergencyContactName;
  String? emergencyContactPhone;
  bool emailNotifications = true;
  bool smsNotifications = false;
  String notificationFrequency = 'Immediate';
  LatLng? homeLocation;
  String homeAddress = '';
  String? _pin;

  void _onChildAdded(Child child) {
    setState(() {
      _children.add(child);
    });
  }

  @override
  void dispose() {
    phoneNumController.dispose();
    moreDetailsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!;
      });
    });
    super.initState();
  }

  void _updateEmergencyContact(String name, String phone) {
    setState(() {
      emergencyContactName = name;
      emergencyContactPhone = phone;
    });
  }

  void _updateNotificationPreferences(bool email, bool sms, String frequency) {
    setState(() {
      emailNotifications = email;
      smsNotifications = sms;
      notificationFrequency = frequency;
    });
  }

  void _updateHomeLocation(LatLng location, String address) {
    setState(() {
      homeLocation = location;
      homeAddress = address;
    });
  }

  Future<void> _navigateToSetPinPage() async {
    final pin = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => SetPinPage(
          onPinSet: (pin) {},
        ),
      ),
    );

    if (pin != null) {
      setState(() {
        _pin = pin;
      });
      _saveParentalInfo();
    }
  }

  void _saveParentalInfo() {
    final parentalInfo = ParentalInfo(
      children: _children,
      emergencyContactName: emergencyContactName ?? '',
      emergencyContactPhone: emergencyContactPhone ?? '',
      emailNotifications: emailNotifications,
      smsNotifications: smsNotifications,
      notificationFrequency: notificationFrequency,
      homeLocation: homeLocation ?? const LatLng(0, 0),
      homeAddress: homeAddress,
      pin: _pin ?? '',
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    context.read<ParentalInfoBloc>().add(SaveParentalInfoEvent(parentalInfo));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ParentalInfoBloc, ParentalInfoState>(
      listener: (context, state) {
        if (state is ParentalInfoSaved) {
          Navigator.of(context).pop(); // Dismiss the loading dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: context.theme.canvasColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset('assets/lottie/success.json',
                        width: 150, height: 150),
                    const SizedBox(height: 16),
                    Text(
                      'Parental information saved successfully!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.go("/");
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (state is ParentalInfoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 32),
              child: LinearPercentIndicator(
                percent: currentPage / 4,
                width: 330,
                lineHeight: 12,
                animation: true,
                animateFromLastPercent: true,
                progressColor: context.theme.primaryColor.withOpacity(.9),
                backgroundColor: context.theme.primaryColor.withOpacity(.3),
                barRadius: const Radius.circular(16),
                padding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: Form(
                key: formKey,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ChildInfo(
                      onChildAdded: _onChildAdded,
                      children: _children,
                    ),
                    Consumer<UserProvider>(
                      builder: (context, userProvider, _) {
                        final currentUser = userProvider.user!;
                        return EmergencyContactsAndNotifications(
                          onUpdate: (name, phone, email, sms, frequency) {
                            setState(() {
                              emergencyContactName = name;
                              emergencyContactPhone = phone;
                              emailNotifications = email;
                              smsNotifications = sms;
                              notificationFrequency = frequency;
                            });
                          },
                          currentUser: currentUser,
                          initialName: emergencyContactName,
                          initialPhone: emergencyContactPhone,
                          initialEmailNotifications: emailNotifications,
                          initialSmsNotifications: smsNotifications,
                          initialNotificationFrequency: notificationFrequency,
                        );
                      },
                    ),
                    HomeAddressLocation(
                      onLocationSelected: (LatLng location, String address) {
                        _updateHomeLocation(location, address);
                      },
                    ),
                    buildSwipableCard(context),
                  ],
                ),
              ),
            ),
            buildNavigationControls(context),
          ],
        ),
      ),
    );
  }

  Widget buildSwipableCard(BuildContext context) {
    List<SwipeItem> swipeItems = [
      SwipeItem(
        content: buildConfirmationCard(context),
      ),
    ];

    MatchEngine matchEngine = MatchEngine(swipeItems: swipeItems);

    return Container(
      padding: const EdgeInsetsDirectional.all(20),
      child: Column(
        children: [
          Text(
            "swipe the card to any direction to save",
            textAlign: TextAlign.start,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SwipeCards(
              matchEngine: matchEngine,
              itemBuilder: (BuildContext context, int index) {
                return swipeItems[index].content;
              },
              onStackFinished: () {
                _navigateToSetPinPage();
              },
              itemChanged: (SwipeItem item, int index) {},
              upSwipeAllowed: false,
              fillSpace: true,
            ),
          ),
          Align(
            alignment: const Alignment(0, .15),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(top: 20),
              child: FFCustomButton(
                text: 'Discard',
                options: FFButtonOptions(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  splashColor: context.theme.colorScheme.error.withOpacity(.1),
                  width: context.width * .4,
                  color: context.theme.cardColor,
                  elevation: .2,
                  textStyle: GoogleFonts.outfit(
                    fontSize: 16,
                    color: context.theme.colorScheme.error,
                  ),
                  borderSide: BorderSide(
                    color: context.theme.colorScheme.error,
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: context.theme.cardColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        title: Text(
                          'Discard Changes',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: context.theme.primaryColor,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to discard all changes?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                           
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                color: context.theme.primaryColor,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              context
                                  .go("/"); // Navigate back to the home screen
                            },
                            child: Text(
                              'Discard',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                color: context.theme.colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConfirmationCard(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      width: double.infinity,
      child: DashedBorderContainer(
        borderColor: context.theme.primaryColor,
        borderWidth: .5,
        dashWidth: 8.0,
        dashSpace: 3.0,
        borderRadius: BorderRadius.zero,
        child: Card(
          color: context.theme.cardColor,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: CustomPaint(
              painter: PatternPainter(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Summary',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: context.theme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Children'),
                      ..._children.map((child) => _buildInfoItem(
                          '${child.name}, ${child.age} years old')),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Emergency Contact'),
                      _buildInfoItem('Name: $emergencyContactName'),
                      _buildInfoItem('Phone: $emergencyContactPhone'),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Notification Preferences'),
                      _buildInfoItem(
                          'Email: ${emailNotifications ? 'Enabled' : 'Disabled'}'),
                      _buildInfoItem(
                          'SMS: ${smsNotifications ? 'Enabled' : 'Disabled'}'),
                      _buildInfoItem('Frequency: $notificationFrequency'),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Home Address'),
                      _buildInfoItem(homeAddress),
                      if (homeLocation != null)
                        _buildInfoItem(
                            'Coordinates: ${homeLocation!.latitude}, ${homeLocation!.longitude}'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: context.theme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          textStyle: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget buildNavigationControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_pageController.hasClients && _pageController.page! > 0)
            GestureDetector(
              onTap: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Text(
                  'Back',
                  key: const ValueKey('back'),
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: context.theme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          if (_pageController.hasClients && _pageController.page! == 0)
            Container(),
          if (_pageController.hasClients && _pageController.page! != 3)
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: GestureDetector(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    if (_pageController.page! == 4) {
                      await _navigateToSetPinPage();
                      if (_pin != null) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please correct the errors in the form before proceeding.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: Text(
                    'Next',
                    key: const ValueKey('next'),
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
