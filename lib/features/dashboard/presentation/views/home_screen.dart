import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:safenest/core/utils/constants.dart';
import 'package:flutter_svg/svg.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {


  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fetchParentalInfo();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
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
              Padding(
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
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 2,
                          thickness: 1,
                          color: Color(0xFFE5E7EB),
                        ),

                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _fetchParentalInfo() {
    final parentalInfoBloc = context.read<ParentalInfoBloc>();
    parentalInfoBloc.add(GetParentalInfoEvent());
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

}
