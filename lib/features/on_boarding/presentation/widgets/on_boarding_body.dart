import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/features/on_boarding/domain/entities/page_content.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({required this.pageContent, super.key});

  final PageContent pageContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (pageContent.image.isNotEmpty)
          pageContent.image.toLowerCase().endsWith('.svg')
              ? SvgPicture.asset(
                  pageContent.image,
                  height: context.height * .4,
                )
              : Image.asset(
                  pageContent.image,
                  height: context.height * .37,
                ),
        SizedBox(
          height: context.height * .03,
        ),
        Padding(
          padding: const EdgeInsets.all(20).copyWith(bottom: 0),
          child: Column(
            children: [
              Text(
                pageContent.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: context.height * .02,
              ),
              Text(
                pageContent.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: context.height * .05,
              ),
              SizedBox(
                height: context.height * .07,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
