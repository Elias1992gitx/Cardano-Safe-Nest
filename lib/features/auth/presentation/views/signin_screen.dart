import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/app/animations/slide_fade_switcher.dart';
import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:safenest/core/common/widgets/custom_form_field.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/core/res/media_res.dart';
import 'package:safenest/core/utils/core_utils.dart';
import 'package:safenest/core/utils/custom_snackbar.dart';
import 'package:safenest/features/auth/data/models/user_model.dart';
import 'package:safenest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:safenest/features/auth/presentation/views/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const routeName = 'sign-in';
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumController.dispose();
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = context.height * .04;
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
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
            context.userProvider.initUser(state.user as LocalUserModel);
            context.go('/');
          } else if (state is SocialSignedInState) {
            context.userProvider.initUser(state.user as LocalUserModel);
            context.go('/');
          }
        },
        builder: (BuildContext context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 180, 30, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            MediaRes.ndLightVector,
                            width: 80,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Welcome back',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Sign in to Safe Nest to pick up exactly where you left off.',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FFCustomButton(
                                    text: 'Google',
                                    icon: IconButton(
                                      icon: SvgPicture.asset(
                                        MediaRes.googleVector,
                                        width: 30,
                                      ),
                                      onPressed: () {
                                        context.read<AuthBloc>().add(
                                              const GoogleSignInEvent(),
                                            );
                                      },
                                    ),
                                    options: FFButtonOptions(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      width: context.width * .4,
                                      color: context
                                          .theme.colorScheme.onBackground,
                                      elevation: .1,
                                      textStyle: GoogleFonts.montserrat(
                                        color:
                                            context.theme.colorScheme.secondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: () {
                                      context.read<AuthBloc>().add(
                                            const GoogleSignInEvent(),
                                          );
                                    },
                                  ),
                                  FFCustomButton(
                                    text: 'Facebook',
                                    icon: IconButton(
                                      icon: SvgPicture.asset(
                                        MediaRes.facebookVector,
                                        width: 30,
                                      ),
                                      onPressed: () {
                                        context.read<AuthBloc>().add(
                                              const FacebookSignInEvent(),
                                            );
                                      },
                                    ),
                                    options: FFButtonOptions(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      width: context.width * .4,
                                      color: context
                                          .theme.colorScheme.onBackground,
                                      elevation: .1,
                                      textStyle: GoogleFonts.montserrat(
                                        color:
                                            context.theme.colorScheme.secondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: () {
                                      context.read<AuthBloc>().add(
                                            const FacebookSignInEvent(),
                                          );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Or sign in with email',
                                key: const ValueKey('sign-in-with-email'),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: context.theme.primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomTextFormField(
                                textInputType: TextInputType.emailAddress,
                                hintText: 'Email or username',
                                validator: (value) {},
                                controller: emailController,
                                maxLength: 32,
                                borderRadius: 10,
                              ),
                              const SizedBox(
                                height: 6,
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
                                height: 12,
                              ),
                              FFCustomButton(
                                text: 'Continue',
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
                                          SignInEvent(
                                            email: emailController.value.text
                                                .trim(),
                                            password: passwordController
                                                .value.text
                                                .trim(),
                                          ),
                                        );
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.go('/forgot-password');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 4,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Forgot Password',
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
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => context.go(
                    "/${SignupScreen.routeName}",
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, topPadding, 20, 0),
                    child: SlideFadeSwitcher(
                      child: Text(
                        "Don't have account? Sign Up",
                        key: const ValueKey('/sign-up'),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
