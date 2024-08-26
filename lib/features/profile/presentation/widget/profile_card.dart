import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:safenest/core/common/app/providers/user_provider.dart';
import 'package:safenest/core/common/widgets/custom_profile_pic.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/core/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:safenest/features/auth/data/models/user_model.dart';
import 'package:shimmer/shimmer.dart';

class UserProfileCard extends StatefulWidget {
  const UserProfileCard({super.key});

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user == null) {
      return Center(
        child: CircularProgressIndicator(
          color: context.theme.colorScheme.secondary,
        ),
      );
    }

    return StreamBuilder<LocalUserModel>(
      stream: userProvider.getUserProfileStream(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: context.theme.colorScheme.secondary,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text('No user data available'),
          );
        }

        final userProfile = snapshot.data!;

        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.onTertiary,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30, top: 25),
                      child: IconButton(
                        icon: const Icon(
                          IconlyBold.notification,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () => context.go('/notification-screen'),
                      ),
                    ),
                  ),
                  Align(
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
                                  12, 0, 12, 32),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional.center,
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(
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
                                          radius: 80,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            CustomProfilePic(
                                          imageProvider: const NetworkImage(
                                            kDefaultAvatar,
                                          ),
                                          onClicked: () {},
                                          radius: 80,
                                        ),
                                        imageUrl: kDefaultAvatar,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userProfile.username,
                                        style: context.theme.textTheme.bodySmall
                                      ),
                                      Text(
                                        userProfile.email,
                                        style: context.theme.textTheme.bodySmall
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.theme.cardColor.withOpacity(.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Shimmer.fromColors(
                        baseColor: Colors.green.withOpacity(.9),
                        highlightColor: Colors.white.withOpacity(1),
                        child: Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional.bottomCenter,
                              child: InkWell(
                                splashColor: Colors.green.withOpacity(.05),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                onTap: () {
                                  context.go('/create-profile');
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.infinity,
                                        color: context.theme.primaryColor,
                                        size: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Text(
                                          'Boost Your Credit Score',
                                          style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: context.theme.primaryColor,
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
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
