import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:safenest/core/common/app/providers/user_provider.dart';
import 'package:safenest/core/common/widgets/custom_profile_pic.dart';
import 'package:safenest/core/utils/constants.dart';
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

class _UserProfileScreenState extends State<UserProfileScreen> with TickerProviderStateMixin {

  bool _isParentalModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const UserProfileCard(),
            _buildCenteredCard(context),
            const UserContents(),
            const SettingBody(),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCenteredCard(BuildContext context) {
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
              height: 60.0,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListTile(
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
                  onChanged: (value) {
                    setState(() {
                      _isParentalModeEnabled = value;
                    });
                    if (value) {
                      context.go('/profile-screen/parental-mode');
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ],
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