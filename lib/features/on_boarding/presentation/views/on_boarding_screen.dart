import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/app/views/loading_view.dart';
import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:safenest/core/common/widgets/gradient_bg.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/features/on_boarding/domain/entities/page_content.dart';
import 'package:safenest/features/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:safenest/features/on_boarding/presentation/widgets/on_boarding_body.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<OnBoardingCubit>().checkIfUserFirstTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: GradientBg(
        child: BlocConsumer<OnBoardingCubit, OnBoardingState>(
          listener: (context, state) {
            if (state is UserCached) {

              context.go('/sign-in');
            }
          },
          builder: (context, state) {
            if (state is CheckIfUserIsFirstTimer || state is CachingFirstTimer) {
              return const LoadingView();
            }
            return Stack(
              children: [
                PageView(
                  controller: _pageController,
                  children: const [
                    OnBoardingBody(pageContent: PageContent.first()),
                    OnBoardingBody(pageContent: PageContent.second()),
                    OnBoardingBody(pageContent: PageContent.third()),
                  ],
                ),

                Align(
                  alignment: const Alignment(0, .06),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    onDotClicked: (index) => _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    effect: WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 40,
                      activeDotColor: context.theme!.primaryColor,
                      dotColor: Colors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, .8),
                  child: FFCustomButton(
                    text: 'Get Started',
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
                      context.read<OnBoardingCubit>().cacheFirstTimer();

                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
