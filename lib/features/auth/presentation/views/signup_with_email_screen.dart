import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/app/animations/slide_fade_switcher.dart';
import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:safenest/core/common/widgets/custom_form_field.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/core/utils/core_utils.dart';
import 'package:safenest/core/utils/custom_snackbar.dart';
import 'package:safenest/features/auth/presentation/bloc/auth_bloc.dart';

class SignupWithEmailScreen extends StatefulWidget {
  const SignupWithEmailScreen({super.key});

  static const routeName = '/signup-with-email';
  @override
  State<SignupWithEmailScreen> createState() => _SignupWithEmailScreenState();
}

class _SignupWithEmailScreenState extends State<SignupWithEmailScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> _handleLogout() async {
    context.go('/');
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Sign Up With Email',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
          ),
          onPressed: () => context.go('/sign-up'),
        ),
        toolbarHeight: 90,
      ),
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
          } else if (state is SignedUpState) {

context.go('/');
          }
        },
        builder: (BuildContext context, state) {
          return SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 140, 30, 0),
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              textInputType: TextInputType.name,
                              hintText: 'Full name',
                              validator: (value) {
                                return null;
                              },
                              controller: fullNameController,
                              maxLength: 32,
                              borderRadius: 10,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            CustomTextFormField(
                              textInputType: TextInputType.emailAddress,
                              hintText: 'Email',
                              validator: (value) {
                                return null;
                              },
                              controller: emailController,
                              maxLength: 32,
                              borderRadius: 10,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            CustomTextFormField(
                              textInputType: TextInputType.visiblePassword,
                              isPassword: true,
                              hintText: 'Password',
                              controller: passwordController,
                              maxLines: 1,
                              onChange: (email) {},
                              maxLength: 25,
                              borderRadius: 10,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FFCustomButton(
                              text: 'Sign Up',
                              options: FFButtonOptions(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 18,
                                ),
                                width: context.width * .9,
                                color: context.theme.primaryColor,
                                elevation: .05,
                                iconPadding: EdgeInsetsDirectional.zero,
                                textStyle: GoogleFonts.montserrat(
                                  color: context.theme.canvasColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                        SignUpEvent(
                                          name: fullNameController.value.text,
                                          email:
                                              emailController.value.text.trim(),
                                          password: passwordController
                                              .value.text
                                              .trim(),
                                        ),
                                      );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "By joining, you agree to Safe Nest's",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: SlideFadeSwitcher(
                          child: Text(
                            'Terms of Service',
                            key: const ValueKey('terms-of-service'),
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
                    ],
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
