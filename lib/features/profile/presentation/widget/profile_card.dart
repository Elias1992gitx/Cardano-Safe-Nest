import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:safenest/core/common/app/providers/user_provider.dart';
import 'package:safenest/core/common/widgets/custom_profile_pic.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/core/utils/constants.dart';
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

    return Consumer<UserProvider>(builder: (context, ref, child) {
      final userProvider = ref.user;
      if (userProvider != null) {
        final user = userProvider;
        return Container(
          decoration: BoxDecoration(
            color: context.theme.colorScheme.onTertiary,
          ),
          child: Align(
            alignment: AlignmentDirectional.topCenter,
            child: SizedBox(
              width: context.width * .9,
              child: Align(
                alignment: AlignmentDirectional.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 70, 12, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    user.username,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24,
                                          color: context.theme.cardColor),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                      top: 5,
                                      start: 2,
                                    ),
                                    child: Text(
                                      user.email,
                                      style: GoogleFonts.raleway(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: context.theme.cardColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.center,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                0,
                                0,
                                6,
                                0,
                              ),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => CustomProfilePic(
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
                                fit: BoxFit.cover,
                                imageUrl: user.profilePic ?? kDefaultAvatar,
                                imageBuilder: (context, imageProvider) {
                                  return CustomProfilePic(
                                    imageProvider: imageProvider,
                                    onClicked: () => {},
                                    radius: 80,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
    });
  }
}
