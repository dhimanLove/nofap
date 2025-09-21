import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nofap/routes/routes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController pageController = PageController();

  final List<Map<String, String>> pages = [
    {
      'title': 'Build Streaks ',
      'description': 'Every day is a win.\nStay strong, keep going!',
      'type': 'asset',
      'animation': 'Assets/Fire.json',
    },
    {
      'title': 'Stay Motivated ',
      'description': 'Count your days,\nsee your journey clearly.',
      'type': 'asset',
      'animation': 'Assets/Olympics.json',
    },
    {
      'title': 'Unlock Rewards ',
      'description': '20 days, 30 days...\nCelebrate milestones!',
      'type': 'asset',
      'animation': 'Assets/Champion.json',
    },
  ];

  int currentPage = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Widget buildLottieOrImage(String type, String path, double height) {
    if (path.endsWith('.json')) {
      return Lottie.asset(
        path,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error, color: Colors.red);
        },
      );
    } else {
      return Image.asset(
        path,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error, color: Colors.red);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight = media.size.height;

    final isDark = Get.isDarkMode;
    final bgColor = isDark ? Colors.black : Colors.white;
    final titleColor = isDark ? Colors.white : Colors.black;
    final descColor = isDark
        ? Colors.white.withOpacity(0.8)
        : Colors.black.withOpacity(0.7);
    final dotInactive = isDark ? Colors.white30 : Colors.black26;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (index) => setState(() => currentPage = index),
                itemBuilder: (context, index) {
                  final item = pages[index];
                  final isNetworkImage = item['type'] == 'network';

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: buildLottieOrImage(
                            item['type']!,
                            item['animation']!,
                            isNetworkImage && (index == 1 || index == 2)
                                ? screenHeight * 0.30
                                : screenHeight * 0.30,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          item['title']!,
                          textAlign: TextAlign.center,
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navLargeTitleTextStyle
                              .copyWith(
                                color: titleColor,
                                fontFamily: "Chillax",
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item['description']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Chillax",
                            color: descColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: BottomControls(
                controller: pageController,
                currentPage: currentPage,
                totalPages: pages.length,
                dotInactive: dotInactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomControls extends StatelessWidget {
  final PageController controller;
  final int currentPage;
  final int totalPages;
  final Color dotInactive;

  const BottomControls({
    super.key,
    required this.controller,
    required this.currentPage,
    required this.totalPages,
    required this.dotInactive,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final isLast = currentPage == totalPages - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Column(
        children: [
          SmoothPageIndicator(
            controller: controller,
            count: totalPages,
            axisDirection: Axis.horizontal,
            effect: WormEffect(
              dotColor: dotInactive,
              activeDotColor: currentPage == 0
                  ? Colors.red
                  : currentPage == totalPages - 1
                  ? const Color.fromARGB(255, 242, 153, 0)
                  : const Color(0xFF306833),
              dotHeight: 15,
              dotWidth: 15,
              spacing: 20,
              radius: 15,
            ),
          ),
          const SizedBox(height: 30),
          Hero(
            tag: "login",
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
              borderRadius: BorderRadius.circular(20),
              color: currentPage == 0
                  ? Colors.red
                  : currentPage == totalPages - 1
                  ? const Color.fromARGB(255, 242, 153, 0)
                  : const Color(0xFF306833),
              child: Text(
                isLast ? "Next" : "Get Started",
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: "Chillax",
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                if (isLast) {
                  // Navigate to signup page
                  // Get.to(
                  //   () => const Signup(),
                  //   transition: Transition.cupertinoDialog,
                  // );
                  Get.offAllNamed(AppRoutes.gnav);
                } else {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                children: [
                  const TextSpan(text: "Already have an account? "),
                  TextSpan(
                    text: "Login",
                    style: TextStyle(
                      fontFamily: "Chillax",
                      color: isDark
                          ? CupertinoColors.activeBlue
                          : CupertinoColors.systemRed,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
