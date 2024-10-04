import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/widgets/custom_tab_bar_button.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/core/common/widgets/dashed_paint.dart';
import 'package:safenest/features/notification/domain/entity/notification.dart';
import 'package:safenest/features/notification/presentation/widgets/notification_list.dart'; // Import the DashedBorderContainer

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  final unFocusNode = FocusNode();
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  List<AppNotification> tempNotifications = [
    AppNotification(
      id: '1',
      title: 'Daily Summary',
      description: 'Your child spent 2 hours on educational apps today.',
      type: AppNotificationType.info,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AppNotification(
      id: '2',
      title: 'Usage Limit Exceeded',
      description:
          'Your child has exceeded the daily usage limit for gaming apps.',
      type: AppNotificationType.warning,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    AppNotification(
      id: '3',
      title: 'New Task Assigned',
      description: 'A new task "Complete Math Homework" has been assigned.',
      type: AppNotificationType.info,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  @override
  void initState() {
    super.initState();

    tabBarController = TabController(
      vsync: this,
      length: 2,
    );
  }

  @override
  void dispose() {
    super.dispose();
    unFocusNode.dispose();
    tabBarController?.dispose();
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
          'Notifications',
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: const Icon(
        //     FontAwesomeIcons.arrowLeft,
        //   ),
        //   onPressed: () => context.go('/profile-screen'),
        // ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
                  child: Text(
                    'A summary of your Nexus Deep activity',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomButtonTabBar(
                          labelStyle: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          unselectedLabelStyle: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          labelColor: context.theme.cardColor,
                          unselectedLabelColor:
                              context.theme.colorScheme.secondary,
                          backgroundColor: context.theme.primaryColor,
                          borderRadius: 12,
                          labelPadding: const EdgeInsetsDirectional.fromSTEB(
                              16, 0, 16, 0),
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 4, 16, 0),
                          tabs: const [
                            Tab(
                              text: 'Activity',
                            ),
                            Tab(
                              text: 'History',
                            ),
                          ],
                          controller: tabBarController,
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabBarController,
                          children: [
                            NotificationList(
                              notifications: tempNotifications,
                              onNotificationTap: (notification) {
                                // Handle notification tap
                                print(
                                    'Tapped on notification: ${notification.title}');
                              },
                              onNotificationDismiss: (notification) {
                                // Handle notification dismiss
                                setState(() {
                                  tempNotifications.removeWhere(
                                      (n) => n.id == notification.id);
                                });
                                print(
                                    'Dismissed notification: ${notification.title}');
                              },
                            ),
                            Container(
                              child: Center(
                                child: Text('History tab content'),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: DashedBorderContainer(
                borderColor: context.theme.primaryColor,
                borderWidth: 2.0,
                dashWidth: 5.0,
                dashSpace: 3.0,
                borderRadius: BorderRadius.circular(50),
                child: FloatingActionButton(
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: Icon(Icons.task, color: context.theme.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
