import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:safenest/core/utils/core_utils.dart';
import 'package:safenest/core/utils/custom_snackbar.dart';
import 'package:safenest/core/common/app/providers/user_session.dart';
import 'package:safenest/core/common/app/providers/user_provider.dart';
import 'package:safenest/features/auth/presentation/bloc/auth_bloc.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({
    super.key,
    this.email,
    this.name,
    this.password,
  });

  final String? email;
  final String? name;
  final String? password;

  static const routeName = '/verify-email';

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  late StreamSubscription<bool> _emailVerificationSubscription;

  @override
  void initState() {
    super.initState();
    _startEmailVerificationListener();
  }

  Future<void> _handleLogout() async {
    final userSession = context.read<UserSession>();
    await userSession.logout();
    context.go('/');
  }


  void _startEmailVerificationListener() {
    final userSession = context.read<UserSession>();

    _emailVerificationSubscription = userSession
        .emailVerificationStatus()
        .listen((isVerified) {
      if (isVerified) {
        _handleEmailVerified();
      }
    });
  }

  Future<void> _handleEmailVerified() async {
    final userProvider = context.read<UserProvider>();
    final userSession = context.read<UserSession>();

    // Sign in the user
    final signInResult = await userSession.signIn(
      email: widget.email!,
      password: widget.password!,
    );

    if (signInResult) {
      // Load user data and navigate to the next screen
      await userProvider.loadUserData();
      context.read<AuthBloc>().add(
        VerifyEmailEvent(
          email: widget.email!,
          password: widget.password!,
        ),
      );
    } else {
      CoreUtils.showSnackBar(
        context,
        ContentType.failure,
        'Failed to sign in after email verification',
        'Auth Error',
      );
    }
  }

  @override
  void dispose() {
    _emailVerificationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            const messageTitle = 'Auth Error';
            CoreUtils.showSnackBar(
              context,
              ContentType.failure,
              state.message,
              messageTitle,
            );
          } else if (state is SignedInState) {
            context.go('/');
          }
        },
        builder: (BuildContext context, state) {
          return SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 80, 30, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Verify Your Email',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: context.height * .14,
                        ),
                        Text(
                          'A verification link has been sent to \n${widget.email ?? 'your email'}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        FFCustomButton(
                          text: 'Resend',
                          options: FFButtonOptions(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 22,
                            ),
                            width: context.width * .6,
                            color: context.theme.primaryColor,
                            elevation: .2,
                            textStyle: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: context.theme.cardColor,
                            ),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {
                            if (widget.name != null &&
                                widget.email != null &&
                                widget.password != null) {
                              context.read<AuthBloc>().add(
                                SignUpEvent(
                                  name: widget.name!,
                                  email: widget.email!.trim(),
                                  password: widget.password!,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: _handleLogout,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Change This Email',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: context.theme.primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}