import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/features/profile/domain/entity/create_profile_page_content.dart';

class CreateProfileBody extends StatelessWidget {
  const CreateProfileBody({required this.pageContent, super.key});

  final CreateProfilePageContent pageContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsetsDirectional.only(top:50),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
              child: Text(
                pageContent.title,
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
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20,vertical: 10),
              child: Text(
                pageContent.description,
                textAlign: TextAlign.start,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(height:80),
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
              },
            ),
          ),

        ],
      ),
    );
  }
}
