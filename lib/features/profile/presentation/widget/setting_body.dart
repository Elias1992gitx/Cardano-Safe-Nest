import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:safenest/features/profile/presentation/bloc/parental_info_bloc.dart';

class SettingBody extends StatefulWidget {
  final ParentalInfoState parentalInfoState;

  const SettingBody({super.key, required this.parentalInfoState});

  @override
  _SettingBodyState createState() => _SettingBodyState();
}

class _SettingBodyState extends State<SettingBody> {
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: InkWell(
        onTap: onTap,
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
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Icon(
                        icon,
                        color: Colors.blueGrey,
                        size: 30,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        title,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 20,
                  start: 20,
                ),
                child: Text(
                  'Settings',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              _buildSettingItem(
                icon: IconlyLight.setting,
                title: 'Account Settings',
                onTap: () => context.go('/account-setting'),
              ),
              _buildSettingItem(
                icon: IconlyLight.notification,
                title: 'Notification Settings',
                onTap: () => context.go('/notification-setting'),
              ),
              _buildSettingItem(
                icon: Icons.language,
                title: 'Preferred Language',
                onTap: () => context.go('/language-selection'),
              ),
              _buildSettingItem(
                icon: Icons.dark_mode_outlined,
                title: 'Appearance Setting',
                onTap: () => context.go('/appearance-setting'),
              ),
              if (widget.parentalInfoState is ParentalInfoLoaded)
                _buildSettingItem(
                  icon: IconlyLight.shield_done,
                  title: 'Manage Parental Info',
                  onTap: () {
                    final parentalInfo = (widget.parentalInfoState as ParentalInfoLoaded).parentalInfo;
                    context.go('/profile-screen/edit-parental-info', extra: parentalInfo);
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}