import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/extensions/context_extensions.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {

  late bool  pauseAllNotification;
  late bool emailNotification;

  @override
  void initState() {
    pauseAllNotification = false;
    emailNotification = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.cardColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.cardColor,
        centerTitle: true,
        toolbarHeight: 70,
        title: Text(
          'Notification Settings',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
          ),
          onPressed: () => context.go('/profile-screen'),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: InkWell(
              onTap: () {},
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              'Pause All',
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Switch(
                            activeColor: context.theme.primaryColor,
                            value: pauseAllNotification,
                            onChanged: (val) {
                              setState(() {
                                pauseAllNotification = val;
                              });
                            },
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
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              'Email Notification',
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Switch(
                            activeColor: context.theme.primaryColor,
                            value: emailNotification,
                            onChanged: (val) {
                              setState(() {
                                emailNotification = val;
                              });
                            },
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
    );
  }
}
