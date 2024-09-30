import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/features/profile/presentation/widget/parental-profile/create_profile_form.dart';

class ManageParentalScreen extends StatefulWidget {
  const ManageParentalScreen({super.key});

  @override
  State<ManageParentalScreen> createState() =>
      _ManageParentalScreenState();
}

class _ManageParentalScreenState extends State<ManageParentalScreen> {
  final _pageController = PageController(
  );
  double currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        title: Text(
          'Manage Parental Info',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Divider(
            color: context.theme.primaryColor,
          ),
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 50),
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 15),
                        child: Text(
                          'Continue your Safe Nest Story!',
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Text(
                          'You are just a few steps away from creating a safe digital environment for your child. '"Complete few questions now to start monitoring and protecting them online.",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                    Align(
                      alignment: const Alignment(0, .15),
                      child: FFCustomButton(
                        text: 'Continue',
                        options: FFButtonOptions(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 22,
                          ),
                          width: context.width * .6,
                          color: context.theme.primaryColor,
                          elevation: .2,
                          textStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          setState(() {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const CreateProfileFormBody()
            ],
          ),
        ],
      ),
    );
  }
}
