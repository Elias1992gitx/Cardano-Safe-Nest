import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:safenest/core/common/widgets/swipeable_calendar_view.dart';
import 'package:app_usage/app_usage.dart';
import 'package:app_settings/app_settings.dart';
import 'package:safenest/core/utils/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safenest/core/common/widgets/custom_profile_pic.dart';
import 'package:safenest/core/common/app/providers/user_provider.dart';
import 'package:safenest/features/profile/presentation/bloc/parental_info_bloc.dart';
import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:safenest/core/common/widgets/custom_icon_button.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safenest/core/common/widgets/qr_scanner_screen.dart';
import 'package:safenest/features/profile/presentation/view/child_qr_code_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isPageReady = false;

  @override
  void initState() {
    super.initState();
    _fetchParentalInfo();
    _checkAndRequestUsagePermission();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();

    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        _isPageReady = true;
      });
    });
  }

  Future<void> _checkAndRequestUsagePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.activityRecognition.status;
      if (!status.isGranted) {
        status = await Permission.activityRecognition.request();
        if (!status.isGranted) {
          _showSettingsDialog();
        } else {
          _handleGrantedPermission();
        }
      } else {
        _handleGrantedPermission();
      }
    } else if (Platform.isIOS) {

      _handleGrantedPermission();
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text('To access app usage data, please enable the "Physical Activity" permission in your device settings.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              Navigator.of(context).pop();
              AppSettings.openAppSettings();
            },
          ),
        ],
      ),
    );
  }

  void _handleGrantedPermission() {
    if (Platform.isAndroid) {
      try {
        final appUsage = AppUsage();
        appUsage.getAppUsage(
          DateTime.now().subtract(const Duration(days: 1)),
          DateTime.now(),
        ).then((usageList) {
          print('App usage data: $usageList');
          // Process the app usage data here
        }).catchError((error) {
          print('Error accessing app usage: $error');
        });
      } catch (e) {
        print('Error initializing app usage: $e');
      }
    } else if (Platform.isIOS) {
      // Implement iOS-specific app usage tracking here
      print('App usage tracking not implemented for iOS');
    }
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: context.theme.cardColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildWelcomeText(),
              const SizedBox(height: 5),
              _isPageReady?Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 40, 10, 10),
                child: Container(
                  width: 500,
                  constraints: const BoxConstraints(
                    maxWidth: 570,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 12, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        textScaler:
                                            MediaQuery.of(context).textScaler,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Scan Child Phone',
                                              style: TextStyle(
                                                color: context.theme.primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 16,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              BlocBuilder<ParentalInfoBloc, ParentalInfoState>(
                                builder: (context, state) {
                                  if (state is ParentalInfoLoaded) {
                                    return IconButton(
                                      icon: Icon(IconlyLight.scan),
                                      onPressed: () async {
                                        final result = await Navigator.of(context).push<String>(
                                          MaterialPageRoute(
                                            builder: (context) => const QRScannerScreen(),
                                          ),
                                        );
                                        if (result != null) {
                                          // Handle the scanned result here
                                          print('Scanned result: $result');
                                          // You can add logic to process the scanned data
                                        }
                                      },
                                      tooltip: 'Scan Child\'s Phone',
                                      iconSize: 30,
                                      color: context.theme.primaryColor,
                                    );
                                  } else {
                                    return FFCustomButton(
                                      text: 'Connect Me',
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ChildQRCodeScreen(),
                                          ),
                                        );
                                      },
                                      options: FFButtonOptions(
                                        width: 130,
                                        height: 40,
                                        color: context.theme.primaryColor,
                                        textStyle: GoogleFonts.plusJakartaSans(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          height: 2,
                          thickness: 1,
                          color: Color(0xFFE5E7EB),
                        ),
                        SizedBox(
                          height: 360,
                          child: SwipeableCalendarView(
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                // Update state if needed
                                print('Selected day: $selectedDay');
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  :Center(
                child: _buildLoadingAnimation(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _fetchParentalInfo() {
    context.read<ParentalInfoBloc>().add(GetParentalInfoEvent());
  }

  Widget _buildWelcomeText() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Welcome back,',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      '${user?.username ?? 'Parent'}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                margin: const EdgeInsetsDirectional.fromSTEB(0, 12, 12, 0),
                child: CachedNetworkImage(
                  placeholder: (context, url) => CustomProfilePic(
                    imageProvider: const NetworkImage(
                      kDefaultAvatar,
                    ),
                    onClicked: () {},
                    radius: 45,
                  ),
                  errorWidget: (context, url, error) => CustomProfilePic(
                    imageProvider: const NetworkImage(
                      kDefaultAvatar,
                    ),
                    onClicked: () {},
                    radius: 45,
                  ),
                  fit: BoxFit.cover,
                  imageUrl: user?.profilePic ?? kDefaultAvatar,
                  imageBuilder: (context, imageProvider) {
                    return CustomProfilePic(
                      imageProvider: imageProvider,
                      onClicked: () => context.go('/profile-screen'),
                      radius: 45,
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
  Widget _buildCalendarContent(DateTime selectedDay, DateTime focusedDay) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Selected day: ${selectedDay.toString().split(' ')[0]}',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }


  Widget _buildLoadingAnimation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/lottie/loading_animation.json',
          width: 200,
          height: 200,
        ),
      ],
    );
  }

}
