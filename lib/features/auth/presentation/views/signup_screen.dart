import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:safenest/core/common/app/animations/slide_fade_switcher.dart';
import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/core/res/media_res.dart';
import 'package:safenest/core/utils/core_utils.dart';
import 'package:safenest/core/utils/custom_snackbar.dart';
import 'package:safenest/features/auth/presentation/bloc/auth_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const routeName = 'sign-up';
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final topPadding = context.height * .25;
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
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
          } else if (state is SignedUpState) {
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
                      padding: const EdgeInsets.fromLTRB(30, 80, 30, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            MediaRes.ndLightVector,
                            width: 80,
                          ),
                          const SizedBox(height: 100),
                          Text(
                            'Join Safe Nest',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Ensure Your Child's Safety Online – Sign Up Now!",
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color:
                                          context.theme.colorScheme.onSurface,
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
                                      color:
                                          context.theme.colorScheme.onSurface,
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
                              FFCustomButton(
                                text: 'Sign Up With Email',
                                icon: IconButton(
                                  icon: const Icon(
                                    IconlyLight.message,
                                  ),
                                  onPressed: () =>
                                      context.go('/signup-with-email'),
                                ),
                                options: FFButtonOptions(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  width: context.width * .9,
                                  color: context.theme.colorScheme.onSurface,
                                  elevation: .1,
                                  iconPadding: EdgeInsetsDirectional.zero,
                                  textStyle: GoogleFonts.montserrat(
                                    color: context.theme.colorScheme.secondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () =>
                                    context.go('/signup-with-email'),
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
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => context.go('/sign-in'),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, topPadding, 20, 0),
                    child: SlideFadeSwitcher(
                      child: Text(
                        'Already have account? Sign In',
                        key: const ValueKey('sign up'),
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
