import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/app/animations/custom_animations.dart';
import 'package:safenest/core/common/app/providers/theme_controller.dart';
import 'package:safenest/core/common/widgets/custom_profile_pic.dart';
import 'package:safenest/core/utils/constants.dart';

class AppearanceSetting extends StatefulWidget {
  const AppearanceSetting({super.key});

  @override
  State<AppearanceSetting> createState() => _AppearanceSettingState();
}

class _AppearanceSettingState extends State<AppearanceSetting> {
  ThemeMode? _themeMode;
  final ThemeController _themeController = Get.find();
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _themeMode = _themeController.currentTheme.value;
    animationsMap.addAll({
      'iconOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effects: [
          VisibilityEffect(duration: 1.ms),
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0,
            end: 1,
          ),
        ],
      ),
      'iconOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effects: [
          VisibilityEffect(duration: 1.ms),
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0,
            end: 1,
          ),
        ],
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        title: Text(
          'Appearance',
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
            height: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _themeMode = ThemeMode.light;
                        });
                        _themeController.changeTheme(ThemeMode.light);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            _themeController.changeTheme(ThemeMode.light);
                          },
                          child: Container(
                            width: 80,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDBE2E7),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                4,
                                12,
                                4,
                                0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                      0,
                                      0,
                                      0,
                                      8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        ),
                                        CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              CustomProfilePic(
                                            imageProvider: const NetworkImage(
                                              kDefaultAvatar,
                                            ),
                                            onClicked: () {},
                                            radius: 16,
                                          ),
                                          height: 16,
                                          width: 16,
                                          imageUrl: kDefaultAvatar,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                      0,
                                      4,
                                      0,
                                      0,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                      0,
                                      4,
                                      0,
                                      0,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Radio(
                      value: ThemeMode.light,
                      groupValue: _themeMode,
                      onChanged: (ThemeMode? mode) {
                        if (mode != null) {
                          setState(() {
                            _themeMode = mode;
                          });
                          _themeController.changeTheme(mode);
                        }
                      },
                    ),
                    Text(
                      'Light',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _themeMode = ThemeMode.dark;
                        });
                        _themeController.changeTheme(ThemeMode.dark);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            _themeController.changeTheme(ThemeMode.dark);
                          },
                          child: Container(
                            width: 80,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2A3137),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                4,
                                12,
                                4,
                                0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                      0,
                                      0,
                                      0,
                                      8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: const Color(0xD81D2429),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        ),
                                        CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              CustomProfilePic(
                                            imageProvider: const NetworkImage(
                                              kDefaultAvatar,
                                            ),
                                            onClicked: () {},
                                            radius: 16,
                                          ),
                                          height: 16,
                                          width: 16,
                                          imageUrl: kDefaultAvatar,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                      0,
                                      4,
                                      0,
                                      0,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: const Color(0xD81D2429),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                      0,
                                      4,
                                      0,
                                      0,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: const Color(0xD81D2429),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Radio(
                      value: ThemeMode.dark,
                      groupValue: _themeMode,
                      onChanged: (ThemeMode? mode) {
                        if (mode != null) {
                          setState(() {
                            _themeMode = mode;
                          });
                          _themeController.changeTheme(mode);
                        }
                      },
                    ),
                    Text(
                      'Dark',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _themeMode = ThemeMode.system;
                        });
                        _themeController.changeTheme(ThemeMode.system);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            _themeController.changeTheme(ThemeMode.system);
                          },
                          child: Container(
                            width: 80,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDBE2E7),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                4,
                                12,
                                4,
                                0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                      0,
                                      0,
                                      0,
                                      8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: const Color(0xD81D2429),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        ),
                                        CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              CustomProfilePic(
                                            imageProvider: const NetworkImage(
                                              kDefaultAvatar,
                                            ),
                                            onClicked: () {},
                                            radius: 16,
                                          ),
                                          height: 16,
                                          width: 16,
                                          imageUrl: kDefaultAvatar,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                      0,
                                      4,
                                      0,
                                      0,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: const Color(0xD81D2429),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                      0,
                                      4,
                                      0,
                                      0,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        color: const Color(0xD81D2429),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Radio(
                      value: ThemeMode.system,
                      groupValue: _themeMode,
                      onChanged: (ThemeMode? mode) {
                        if (mode != null) {
                          setState(() {
                            _themeMode = mode;
                          });
                          _themeController.changeTheme(mode);
                        }
                      },
                    ),
                    Text(
                      'System',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.topStart,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                top: 20,
                start: 20,
                bottom: 5,
              ),
              child: Text(
                "If 'System' is selected, Nexus Deep app will automatically "
                'adjust your appearance based on your devices system setting',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
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
