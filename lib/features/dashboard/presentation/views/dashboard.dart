import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:safenest/core/common/app/providers/user_provider.dart';
import 'package:safenest/core/common/widgets/custom_profile_pic.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/core/utils/constants.dart';
import 'package:safenest/features/dashboard/presentation/views/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:safenest/features/digital_wellbeing/presentation/views/analysis_page.dart';
import 'package:safenest/features/location/domain/entity/child_location.dart';
import 'package:safenest/features/location/domain/entity/safe_location.dart';
import 'package:safenest/features/location/presentation/views/location_page.dart';
import 'package:safenest/features/notification/presentation/view/notification_page.dart';
import 'package:shimmer/shimmer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const routeName = '/dashboard';
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> pages = [
    HomeScreen(),
    DigitalWellbeingAnalysisPage(),
    NotificationScreen(),
    LocationDashboard(
      safeLocations: [
        SafeLocation(
          id: '1',
          name: 'Home',
          location: GeoPoint(37.7749, -122.4194),
          radius: 100,
        ),
        SafeLocation(
          id: '2',
          name: 'School',
          location: GeoPoint(37.7739, -122.4312),
          radius: 200,
        ),
        SafeLocation(
          id: '3',
          name: 'Park',
          location: GeoPoint(37.7694, -122.4862),
          radius: 150,
        ),
      ],
      childLocations: [
        ChildLocation(
          childId: 'child1',
          location: GeoPoint(37.7749, -122.4194),
          timestamp: DateTime.now(),
          isInSafeZone: true,
          nearestSafeZone: SafeLocation(
            id: '1',
            name: 'Home',
            location: GeoPoint(37.7749, -122.4194),
            radius: 100,
          ),
        ),
        ChildLocation(
          childId: 'child2',
          location: GeoPoint(37.7739, -122.4312),
          timestamp: DateTime.now().subtract(Duration(minutes: 30)),
          isInSafeZone: true,
          nearestSafeZone: SafeLocation(
            id: '2',
            name: 'School',
            location: GeoPoint(37.7739, -122.4312),
            radius: 200,
          ),
        ),
        ChildLocation(
          childId: 'child3',
          location: GeoPoint(37.7694, -122.4862),
          timestamp: DateTime.now().subtract(Duration(hours: 1)),
          isInSafeZone: false,
        ),
      ],
    ),
  ];
  List<String> titles = const [
    'Nexus Deep',
    'Review',
    'Activity',
    'Location',
  ];

  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: (currentIndex == 0) ? CustomAppBar(titles[currentIndex]) : null,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: context.theme.cardColor,
        currentIndex: currentIndex,
        selectedItemColor: context.theme!.primaryColor.withOpacity(.8),
        unselectedItemColor: Colors.grey.withOpacity(.6),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        elevation: 2,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              IconlyLight.home,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Review',
            icon: Icon(
              IconlyLight.chart,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Activity',
            icon: Icon(
              IconlyLight.notification,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Location',
            icon: Icon(
              IconlyLight.location,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.cardColor,
      centerTitle: true,
      toolbarHeight: 70,
      title: Row(
        children: [],
      ),
      actions: [
        Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final user = userProvider.user;
            return Container(
              margin: const EdgeInsetsDirectional.fromSTEB(0, 12, 12, 0),
              child: CachedNetworkImage(
                placeholder: (context, url) => CustomProfilePic(
                  imageProvider: const NetworkImage(
                    kDefaultAvatar,
                  ),
                  onClicked: () {},
                  radius: 45,
                ),
                errorWidget: (context, url, error) => CustomProfilePic(
                  imageProvider: const NetworkImage(
                    kDefaultAvatar,
                  ),
                  onClicked: () {},
                  radius: 45,
                ),
                fit: BoxFit.cover,
                imageUrl: user?.profilePic ?? kDefaultAvatar,
                imageBuilder: (context, imageProvider) {
                  return CustomProfilePic(
                    imageProvider: imageProvider,
                    onClicked: () => context.go('/profile-screen'),
                    radius: 45,
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
