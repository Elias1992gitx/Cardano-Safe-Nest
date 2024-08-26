import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/features/profile/domain/entity/create_profile_page_content.dart';
import 'package:safenest/features/profile/presentation/widget/create-profile/create_profile_body.dart';
import 'package:safenest/features/profile/presentation/widget/create-profile/create_profile_form.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CreateYourProfileScreen extends StatefulWidget {
  const CreateYourProfileScreen({super.key});

  @override
  State<CreateYourProfileScreen> createState() =>
      _CreateYourProfileScreenState();
}

class _CreateYourProfileScreenState extends State<CreateYourProfileScreen> {
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
          'Create Profile',
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
                          'Continue your Nexus Deep Story!',
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
                            horizontal: 20, vertical: 10),
                        child: Text(
                          'You are just few steps away from potential investment. '
                          "Complete your profile now and we'll help your business "
                          'do the right investment',
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
                          color: context.theme!.primaryColor,
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
