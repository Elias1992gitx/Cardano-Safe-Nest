import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:safenest/features/profile/presentation/bloc/parental_info_bloc.dart';
import 'package:safenest/features/profile/presentation/widget/parental-profile/set_security.dart';
import 'package:safenest/core/utils/core_utils.dart';
import 'package:safenest/core/utils/custom_snackbar.dart';
import 'package:safenest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:safenest/features/profile/presentation/widget/profile_card.dart';
import 'package:safenest/features/profile/presentation/widget/setting_body.dart';
import 'package:safenest/features/profile/presentation/widget/user_contents.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  bool _isLoggingOut = false;
  bool _isParentalModeEnabled = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fetchParentalInfo();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _fetchParentalInfo() {
    context.read<ParentalInfoBloc>().add(GetParentalInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ParentalInfoBloc, ParentalInfoState>(
      listener: (context, state) {
        if (state is ParentalInfoLoaded) {
          setState(() {
            _isParentalModeEnabled = true;
          });
        } else if (state is ParentalInfoInitial || state is ParentalInfoError) {
          setState(() {
            _isParentalModeEnabled = false;
          });
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: context.theme.colorScheme.surface,
            body: AnimatedOpacity(
              opacity: _isLoggingOut ? 0.5 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const UserProfileCard(),
                    _buildCenteredCard(context),
                    const UserContents(),
                    BlocBuilder<ParentalInfoBloc, ParentalInfoState>(
                      builder: (context, state) {
                        return SettingBody(parentalInfoState: state);
                      },
                    ),
                    _buildFooter(context),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoggingOut)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Lottie.asset(
                    'assets/lottie/loading_animation.json',
                    width: 200,
                    height: 200,
                    controller: _animationController,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCenteredCard(BuildContext context) {
    return BlocBuilder<ParentalInfoBloc, ParentalInfoState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              height: 30.0,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.onTertiary,
              ),
            ),
            Container(
              height: 30.0,
            ),
            Center(
              child: Card(
                elevation: 0,
                color: context.theme.cardColor,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(
                          IconlyLight.shield_done,
                        ),
                        title: Text(
                          "Parental Mode",
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        trailing: Switch(
                          value: _isParentalModeEnabled,
                          onChanged: _isParentalModeEnabled
                              ? null
                              : (value) async {
                                  if (value) {
                                    final pin = await Navigator.of(context)
                                        .push<String>(
                                      MaterialPageRoute(
                                        builder: (context) => SetPinPage(
                                          onPinSet: (pin) {
                                            return pin;
                                          },
                                        ),
                                      ),
                                    );
                                    if (pin != null) {
                                      setState(() {
                                        _isParentalModeEnabled = true;
                                      });
                                      context
                                          .go('/profile-screen/parental-mode');
                                    }
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.theme.cardColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  radius: 45,
                  child: const Icon(
                    IconlyBold.logout,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Log Out',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: context.theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Are you sure you want to log out?',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    color: context.theme.hintColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Any unsaved data will remain on this device.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: context.theme.hintColor.withOpacity(0.4),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Divider(color: context.theme.dividerColor),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.plusJakartaSans(
                            color: context.theme.hintColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: context.theme.dividerColor,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(
                          'Log Out',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          const messageTitle = 'Auth Error';
          CoreUtils.showSnackBar(
              context, ContentType.failure, state.message, messageTitle);
        } else if (state is LogoutState) {
          setState(() {
            _isLoggingOut = true;
          });
          _animationController.forward().then((_) {
            Future.delayed(const Duration(seconds: 2), () {
              context.go('/');
            });
          });
        }
      },
      builder: (BuildContext context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                top: 80,
                start: 20,
              ),
              child: Text(
                'Exit',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: InkWell(
                onTap: () async {
                  if (!_isLoggingOut) {
                    final shouldLogout =
                        await _showLogoutConfirmationDialog(context);
                    if (shouldLogout) {
                      context.read<AuthBloc>().add(const LogoutEvent());
                    }
                  }
                },
                child: AnimatedOpacity(
                  opacity: _isLoggingOut ? 0.5 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Icon(
                                  IconlyLight.logout,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Log Out',
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
