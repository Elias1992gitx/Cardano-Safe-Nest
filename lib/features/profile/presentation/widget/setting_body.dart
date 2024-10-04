import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:safenest/core/common/app/providers/language_provider.dart';
import 'package:safenest/core/localization/app_localization.dart';
import 'package:safenest/features/profile/presentation/bloc/parental_info_bloc.dart';

class SettingBody extends StatelessWidget {
  final ParentalInfoState parentalInfoState;

  const SettingBody({Key? key, required this.parentalInfoState})
      : super(key: key);

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String titleKey,
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
                        AppLocalizations.of(context).translate(titleKey),
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
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) {
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
                      AppLocalizations.of(context).translate('settings'),
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    context: context,
                    icon: IconlyLight.setting,
                    titleKey: 'account_settings',
                    onTap: () => context.go('/account-setting'),
                  ),
                  _buildSettingItem(
                    context: context,
                    icon: IconlyLight.notification,
                    titleKey: 'notification_settings',
                    onTap: () => context.go('/notification-setting'),
                  ),
                  _buildSettingItem(
                    context: context,
                    icon: Icons.language,
                    titleKey: 'preferred_language',
                    onTap: () => context.go('/language-selection'),
                  ),
                  _buildSettingItem(
                    context: context,
                    icon: Icons.dark_mode_outlined,
                    titleKey: 'appearance_setting',
                    onTap: () => context.go('/appearance-setting'),
                  ),
                  if (parentalInfoState is ParentalInfoLoaded)
                    _buildSettingItem(
                      context: context,
                      icon: IconlyLight.shield_done,
                      titleKey: 'manage_parental_info',
                      onTap: () {
                        final parentalInfo =
                            (parentalInfoState as ParentalInfoLoaded)
                                .parentalInfo;
                        context.go('/profile-screen/edit-parental-info',
                            extra: parentalInfo);
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
