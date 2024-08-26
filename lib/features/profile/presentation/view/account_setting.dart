import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/app/providers/user_provider.dart';
import 'package:safenest/core/common/widgets/custom_profile_pic.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/core/utils/constants.dart';
import 'package:provider/provider.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
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
          'Account Settings',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<UserProvider>(
              builder: (context, ref, child) {
                final userProvider = ref.user;
                if (userProvider != null) {
                  final user = userProvider;
                  return Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: SizedBox(
                      width: context.width * .9,
                      child: Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  12, 20, 12, 32),
                              child: Align(
                                alignment: AlignmentDirectional.center,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                    0,
                                    0,
                                    12,
                                    0,
                                  ),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        CustomProfilePic(
                                      imageProvider: const NetworkImage(
                                        kDefaultAvatar,
                                      ),
                                      onClicked: () {},
                                      radius: 120,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        CustomProfilePic(
                                      imageProvider: const NetworkImage(
                                        kDefaultAvatar,
                                      ),
                                      onClicked: () {},
                                      radius: 120,
                                    ),
                                    fit: BoxFit.cover,
                                    imageUrl: user.profilePic ?? kDefaultAvatar,
                                    imageBuilder: (context, imageProvider) {
                                      return CustomProfilePic(
                                        imageProvider: imageProvider,
                                        onClicked: () {},
                                        radius: 120,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: context.theme.colorScheme.secondary,
                    ),
                  );
                }
              },
            ),
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 4,
                ),
                child: Text(
                  'Change Profile Picture',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: context.theme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
              child: Divider(),
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 20,
                  start: 20,
                ),
                child: Text(
                  'Profile Information',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Padding(
                    padding:
                    const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    child: Row(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 20,
                                top: 15
                            ),
                            child: Text(
                              'Name',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: context.theme.primaryColor
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
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    child: Row(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 20,
                                top: 15
                            ),
                            child: Text(
                              'Email',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: context.theme.primaryColor
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: Divider(),
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 20,
                  start: 20,
                  bottom: 5
                ),
                child: Text(
                  'Personal Information',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
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
                      padding:
                      const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      child: Row(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 20,
                                  top: 15
                              ),
                              child: Text(
                                'Phone Number',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: context.theme.primaryColor
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
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
                      padding:
                      const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      child: Row(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 20,
                                  top: 15
                              ),
                              child: Text(
                                'Address Information',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: context.theme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
