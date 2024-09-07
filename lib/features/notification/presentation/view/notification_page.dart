import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/widgets/custom_tab_bar_button.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/core/common/widgets/dashed_paint.dart'; // Import the DashedBorderContainer

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
                          unselectedLabelColor: context.theme.colorScheme.secondary,
                          backgroundColor: context.theme.primaryColor,
                          borderRadius: 12,
                          labelPadding:
                          const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                          padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
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
                            Container(
                              width: 400,
                            ),
                            Container(
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 1),
                                    child: Container(
                                      width: 100,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        color: context.theme.cardColor,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0xFFE0E3E7),
                                            offset: Offset(0, 1),
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            4, 0, 0, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 24,
                                              child: Stack(
                                                alignment:
                                                AlignmentDirectional.center,
                                                children: [
                                                  Align(
                                                    alignment:
                                                    const AlignmentDirectional(
                                                      0,
                                                      -0.70,
                                                    ),
                                                    child: Container(
                                                      width: 12,
                                                      height: 12,
                                                      decoration: BoxDecoration(
                                                        color: context
                                                            .theme.primaryColor,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      VerticalDivider(
                                                        thickness: 2,
                                                        color: context
                                                            .theme.primaryColor,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                const EdgeInsetsDirectional.all(
                                                  16,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [],
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