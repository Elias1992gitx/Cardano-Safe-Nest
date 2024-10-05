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
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
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
            context.go('/profile-screen');
          } else if (state is SocialSignedInState) {
            context.userProvider.initUser(state.user as LocalUserModel);
            context.go('/profile-screen');
          }
        },
        builder: (BuildContext context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      context.height - MediaQuery.of(context).padding.top,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: SvgPicture.asset(
                              MediaRes.ndLightVector,
                              width: 80,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back',
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Sign in to Safe Nest to pick up exactly where you left off.',
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                _buildSignInForm(context,state),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: GestureDetector(
                            onTap: () =>
                                context.go("/${SignupScreen.routeName}"),
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
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSignInForm(BuildContext context,AuthState state) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSocialButton(
                context,
                'Google',
                MediaRes.googleVector,
                const GoogleSignInEvent(),
              ),
              _buildSocialButton(
                context,
                'Facebook',
                MediaRes.facebookVector,
                const FacebookSignInEvent(),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          CustomTextFormField(
            textInputType: TextInputType.emailAddress,
            hintText: 'Email or username',
            validator: (value) {
              return null;
            },
            controller: emailController,
            maxLength: 32,
            borderRadius: 10,
          ),
          const SizedBox(height: 6),
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
          const SizedBox(height: 12),
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
                color: Colors.white,
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
                    email: emailController.value.text.trim(),
                    password: passwordController.value.text.trim(),
                  ),
                );
              }
            },
            showLoadingIndicator: state is AuthLoading,
          ),
          const SizedBox(height: 15),
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
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    String text,
    String iconAsset,
    AuthEvent event,
  ) {
    return FFCustomButton(
      text: text,
      icon: IconButton(
        icon: SvgPicture.asset(
          iconAsset,
          width: 30,
        ),
        onPressed: () {
          context.read<AuthBloc>().add(event);
        },
      ),
      options: FFButtonOptions(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        width: context.width * .4,
        color: context.theme.colorScheme.onSurface,
        elevation: .1,
        textStyle: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      onPressed: () {
        context.read<AuthBloc>().add(event);
      },
    );
  }
}
