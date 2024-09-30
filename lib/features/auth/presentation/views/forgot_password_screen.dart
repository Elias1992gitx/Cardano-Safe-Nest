// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/app/animations/slide_fade_switcher.dart';
import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:safenest/core/common/widgets/custom_form_field.dart';
import 'package:safenest/core/utils/custom_snackbar.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/core/utils/core_utils.dart';
import 'package:safenest/features/auth/presentation/bloc/auth_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const routeName = '/forgot-password';
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
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
          }
        },
        builder: (BuildContext context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Form(
                key: formKey,
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 80, 30, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Forgotten Password',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: context.height * .02,
                        ),
                        Text(
                          'Provide your Email and we will send you a link to '
                          'reset your password.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        CustomTextFormField(
                          textInputType: TextInputType.emailAddress,
                          hintText: 'Email address',
                          validator: (value) {
                            return null;
                          },
                          controller: emailController,
                          maxLength: 35,
                          borderRadius: 10,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FFCustomButton(
                          text: 'Reset Password',
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
                              color: Colors.white,
                            ),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/'),
                      child: SlideFadeSwitcher(
                        child: Text(
                          'Go Back',
                          key: const ValueKey('sign in'),
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFF9A9A9A),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
