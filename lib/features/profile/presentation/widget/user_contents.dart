import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class UserContents extends StatefulWidget {
  const UserContents({super.key});

  @override
  State<UserContents> createState() => _UserContentsState();
}

class _UserContentsState extends State<UserContents> {
  final isSeller = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [


        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20,),
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
                                  IconlyLight.chart,
                                  color: Colors.blueGrey,
                                  size: 30,
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Your Activity',
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
                                  IconlyLight.bookmark,
                                  color: Colors.blueGrey,
                                  size: 30,
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Saved Listings',
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
                                  IconlyLight.volume_up,
                                  color: Colors.blueGrey,
                                  size: 30,
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 20),
                                child: Text(
                                  'Market Buzz',
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
