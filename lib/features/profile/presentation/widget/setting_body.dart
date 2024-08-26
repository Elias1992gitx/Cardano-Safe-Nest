import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:safenest/core/extensions/context_extensions.dart';


class SettingBody extends StatefulWidget {
  const SettingBody({super.key});

  @override
  State<SettingBody> createState() => _SettingBodyState();
}

class _SettingBodyState extends State<SettingBody> {
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
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: InkWell(
                  onTap: () {
                    context.go('/account-setting');
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16, 0, 16, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Align(
                                alignment:
                                AlignmentDirectional.centerStart,
                                child: Icon(
                                  IconlyLight.setting,
                                  color: Colors.blueGrey,
                                  size: 30,
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Account Settings',
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
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: InkWell(
                  onTap: () {
                    context.go('/notification-setting');
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16, 0, 16, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Align(
                                alignment:
                                AlignmentDirectional.centerStart,
                                child: Icon(
                                  IconlyLight.notification,
                                  color: Colors.blueGrey,
                                  size: 30,
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Notification Settings',
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
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: InkWell(
                  onTap: () {

                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16, 0, 16, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Align(
                                alignment:
                                AlignmentDirectional.centerStart,
                                child: Icon(
                                  IconlyLight.shield_done,
                                  color: Colors.blueGrey,
                                  size: 30,
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Set up 2FA',
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
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16, 0, 16, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Align(
                                alignment:
                                AlignmentDirectional.centerStart,
                                child: Icon(
                                  Icons.language,
                                  color: Colors.blueGrey,
                                  size: 30,
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Preferred Language',
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
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: InkWell(
                  onTap: () {
                    context.go('/appearance-setting');
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16, 0, 16, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Align(
                                alignment:
                                AlignmentDirectional.centerStart,
                                child: Icon(
                                  Icons.dark_mode_outlined,
                                  color: Colors.blueGrey,
                                  size: 30,
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Appearance Setting',
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
              ),
            ],
          ),
        ),

      ],
    );
  }
}
