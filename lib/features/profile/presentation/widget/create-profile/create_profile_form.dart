import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/core/res/media_res.dart';
import 'package:safenest/core/utils/constants.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CreateProfileFormBody extends StatefulWidget {
  const CreateProfileFormBody({super.key});

  @override
  State<CreateProfileFormBody> createState() => _CreateProfileFormBodyState();
}

class _CreateProfileFormBodyState extends State<CreateProfileFormBody> {
  double currentPage = 0;
  final _pageController = PageController();
  final formKey = GlobalKey<FormState>();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final phoneNumController = TextEditingController();
  final moreDetailsController = TextEditingController();
  final zipCodeController = TextEditingController();
  bool isIndividualSelected = false;
  bool isCompanySelected = false;
  bool isBusinessLocationDifferent = false;

  @override
  void dispose() {
    countryController.dispose();
    cityController.dispose();
    phoneNumController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    moreDetailsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 32),
            child: LinearPercentIndicator(
              percent: currentPage / 6,
              width: 330,
              lineHeight: 12,
              animation: true,
              animateFromLastPercent: true,
              progressColor: context.theme.primaryColor.withOpacity(.9),
              backgroundColor: context.theme.primaryColor.withOpacity(.3),
              barRadius: const Radius.circular(16),
              padding: EdgeInsets.zero,
            ),
          ),
          Expanded(
            child: Form(
              key: formKey,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(top: 50),
                      child: Column(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 15,
                              ),
                              child: Text(
                                "Let's get started! First, tell us a little "
                                'about your business.',
                                style: GoogleFonts.plusJakartaSans(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: context.theme.primaryColor,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  setState(() {
                                    isIndividualSelected = true;
                                    isCompanySelected = false;
                                  });
                                },
                                child: Container(
                                  width: 310,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                      8,
                                      12,
                                      8,
                                      0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8, 0, 0, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 4, 0, 4),
                                                child: Text(
                                                  'Individual',
                                                  style: GoogleFonts.outfit(
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                              ),
                                              if (isIndividualSelected)
                                                const Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .topEnd,
                                                  child: Icon(
                                                    Icons.check_circle_rounded,
                                                    size: 32,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 270,
                                          height: 120,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional
                                                    .topCenter,
                                                child: Stack(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .bottomEnd,
                                                  children: [
                                                    const Icon(
                                                      IconlyLight.profile,
                                                      size: 45,
                                                    ),
                                                    Icon(
                                                      IconlyBold.star,
                                                      size: 28,
                                                      color: context
                                                          .theme.primaryColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "I'm an individual running my "
                                                'own business',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  textStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "(My business isn't "
                                                'registered)',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  color:
                                                      const Color(0xFF606A85),
                                                  fontSize: 14,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
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
                            ),
                          ),
                          const SizedBox(height: 15),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: context.theme.primaryColor,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  setState(() {
                                    isIndividualSelected = false;
                                    isCompanySelected = true;
                                  });
                                },
                                child: Container(
                                  width: 310,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                      8,
                                      12,
                                      8,
                                      0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8, 0, 0, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 4, 0, 4),
                                                child: Text(
                                                  'Company',
                                                  style: GoogleFonts.outfit(
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                              ),
                                              if (isCompanySelected)
                                                const Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .topEnd,
                                                  child: Icon(
                                                    Icons.check_circle_rounded,
                                                    size: 32,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 270,
                                          height: 120,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional
                                                    .topCenter,
                                                child: Stack(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .bottomEnd,
                                                  children: [
                                                    const Icon(
                                                      FontAwesomeIcons.building,
                                                      size: 40,
                                                    ),
                                                    Icon(
                                                      FontAwesomeIcons
                                                          .fileImport,
                                                      size: 28,
                                                      color: context
                                                          .theme.primaryColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                'I own or represent '
                                                'registered a company',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  textStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '(Sole Proprietorship, '
                                                'Corporation ...)',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  color:
                                                      const Color(0xFF606A85),
                                                  fontSize: 14,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
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
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Visibility(
                              visible: isCompanySelected,
                              child: CheckboxListTile(
                                title: Text(
                                  'My business is registered in a different location',
                                  style: GoogleFonts.plusJakartaSans(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                value: isBusinessLocationDifferent,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isBusinessLocationDifferent = value!;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                activeColor: context.theme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 15,
                              vertical: 50,
                            ),
                            child: Text(
                              "To get started, tell us where you're located.",
                              style: GoogleFonts.plusJakartaSans(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 30,
                          ),
                          child: Column(
                            children: [

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 15,
                              vertical: 50,
                            ),
                            child: Text(
                              'Ready to Scan',
                              style: GoogleFonts.plusJakartaSans(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          MediaRes.scanId,
                          height: context.height * .3,
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Text(
                            'We need to verify your Digital ID (Fayda)/ Passport',
                            style: GoogleFonts.outfit(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Text(
                            'Your Digital Id / Passport will help us verify your account quickly and easily',
                            style: GoogleFonts.plusJakartaSans(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Align(
                          alignment: const Alignment(0, .15),
                          child: FFCustomButton(
                            text: 'Continue Scan',
                            options: FFButtonOptions(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 18,
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
                              context.go('/create-profile/scan-user-id');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 15,
                              vertical: 50,
                            ),
                            child: Text(
                              'Get Ready for your video selfie',
                              style: GoogleFonts.plusJakartaSans(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        CachedNetworkImage(
                          placeholder: (context, url) => Image.network(
                            kSelfieOvalAvatar,
                            width: context.height * .3,
                            height: context.height * .3,
                          ),
                          errorWidget: (context, url, error) => Container(),
                          fit: BoxFit.cover,
                          imageUrl: kSelfieOvalAvatar,
                          imageBuilder: (context, imageProvider) {
                            return Image.network(
                              kSelfieOvalAvatar,
                              width: context.height * .3,
                              height: context.height * .3,
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Text(
                            'Please frame your face in the '
                            'the big oval',
                            style: GoogleFonts.plusJakartaSans(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Text(
                            'This is to make sure its really you. '
                            'we use this for added security',
                            style: GoogleFonts.plusJakartaSans(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Align(
                          alignment: const Alignment(0, .15),
                          child: FFCustomButton(
                            text: "I'm Ready",
                            options: FFButtonOptions(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 18,
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
                              context.go('/create-profile/liveliness');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 15,
                              vertical: 50,
                            ),
                            child: Text(
                              'Which content areas align with your interests?',
                              style: GoogleFonts.plusJakartaSans(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 15,
                              vertical: 50,
                            ),
                            child: Text(
                              'Swipe to approve!',
                              style: GoogleFonts.plusJakartaSans(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, .15),
                          child: FFCustomButton(
                            text: 'Discard',
                            options: FFButtonOptions(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              splashColor: context.theme.colorScheme.error
                                  .withOpacity(.1),
                              width: context.width * .4,
                              color: context.theme.cardColor,
                              elevation: .2,
                              textStyle: GoogleFonts.outfit(
                                fontSize: 16,
                                color: context.theme.colorScheme.error,
                              ),
                              borderSide: BorderSide(
                                color: context.theme.colorScheme.error,
                              ),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          buildNavigationControls(context),
        ],
      ),
    );
  }

  Widget buildNavigationControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_pageController.hasClients && _pageController.page! > 0)
            GestureDetector(
              onTap: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Text(
                  'Back',
                  key: const ValueKey('back'),
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: context.theme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          if (_pageController.hasClients && _pageController.page! == 0)
            Container(),
          if (_pageController.hasClients && _pageController.page! != 5)
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: GestureDetector(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please correct the errors in the form before proceeding.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: Text(
                    'Next',
                    key: const ValueKey('next'),
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
