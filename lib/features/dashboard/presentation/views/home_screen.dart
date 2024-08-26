import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/widgets/custom_icon_button.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.cardColor,
      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 40, 10, 10),
              child: Container(
                width: 500,
                constraints: const BoxConstraints(
                  maxWidth: 570,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 12, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Institute: ',
                                            style: TextStyle(
                                              color: context
                                                  .theme.colorScheme.onTertiary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'CBE',
                                            style: TextStyle(
                                              color: context.theme.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color:
                                    context.theme.primaryColor.withOpacity(.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: context.theme.primaryColor
                                      .withOpacity(.7),
                                  width: 2,
                                ),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional.center,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 8, 0),
                                  child: Text(
                                    'In Progress',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: context.theme.primaryColor,
                                      fontSize: 14,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 2,
                        thickness: 1,
                        color: Color(0xFFE5E7EB),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
                        child: Text(
                          'Marketing Campaign',
                          textAlign: TextAlign.end,
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF15161E),
                            fontSize: 22,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 0),
                        child: Text(
                          'Plan and execute a comprehensive marketing campaign to promote a new product launch. Coordinate with the marketing team to outline campaign strategies, allocate resources, and set clear targets for lead generation and conversion rates. ',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF606A85),
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: context.theme.primaryColor
                                        .withOpacity(.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: context.theme.primaryColor
                                          .withOpacity(.7),
                                      width: 2,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.network(
                                        'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            CircularPercentIndicator(
                              percent: 0.33,
                              radius: 24,
                              lineWidth: 4,
                              animation: true,
                              animateFromLastPercent: true,
                              progressColor:
                                  context.theme.primaryColor.withOpacity(.9),
                              backgroundColor:
                                  context.theme.primaryColor.withOpacity(.2),
                              center: Text(
                                '1/3',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF15161E),
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
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
            )
          ],
        ),
      ),
    );
  }
}
