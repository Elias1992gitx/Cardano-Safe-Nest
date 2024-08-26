import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:safenest/core/utils/core_utils.dart';
import 'package:safenest/core/utils/custom_snackbar.dart';
import 'package:safenest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:safenest/features/profile/presentation/widget/profile_card.dart';
import 'package:safenest/features/profile/presentation/widget/setting_body.dart';
import 'package:safenest/features/profile/presentation/widget/user_contents.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          const UserProfileCard(),
          const UserContents(),
          const SettingBody(),
          _buildFooter(context),
        ]),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (_, state) {
        if (state is AuthError) {
          const messageTitle = 'Auth Error';
          CoreUtils.showSnackBar(
            context,
            ContentType.failure,
            state.message,
            messageTitle,
          );
        } else if (state is LogoutState) {
          context.go('/');
        }
      },
      builder: (BuildContext context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                top: 20,
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
                  context.read<AuthBloc>().add(
                        const LogoutEvent(),
                      );
                },
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
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
          ],
        );
      },
    );
  }
}
