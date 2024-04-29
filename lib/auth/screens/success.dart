import 'package:flutter/material.dart';

import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:glass_login/utils/custom_bg.dart';

import '../../utils/app_colors.dart';

class Success extends StatefulWidget {
  const Success({
    super.key,
    required this.controller,
  });
  final PageController controller;
  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryHighContrast.withOpacity(0.7),
      body: SizedBox.fromSize(
        size: MediaQuery.sizeOf(context),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.ease,
              // left: pageValue * -w,
              top: 0,
              child: Container(
                height: 300,
                width: 200,
                decoration: const BoxDecoration(),
                child: CustomPaint(
                  painter: CustomBackground(
                    firstColor: AppColors.primaryColor,
                    secondColor: AppColors.primaryDark,
                  ),
                ),
              ),
            ),
            // Positioned(
            //   right: 40,
            //   top: 140,
            //   child: Transform.rotate(
            //     angle: pi * .1,
            //     child: Image.asset(
            //       'assets/pngs/medical.png',
            //       width: 60,
            //     ),
            //   ),
            // ),
            Positioned(
              left: 80,
              top: 300,
              child: Transform.rotate(
                angle: -pi * 0.05,
                child: Image.asset(
                  'assets/pngs/health-care.png',
                  width: 50,
                ),
              ),
            ),
            // Positioned(
            //   right: 10,
            //   bottom: 20,
            //   child: Transform.rotate(
            //     angle: -pi * 0.14,
            //     child: Image.asset(
            //       'assets/pngs/antibiotic.png',
            //       width: 120,
            //     ),
            //   ),
            // ),
            Positioned(
              left: -50,
              top: 10,
              child: SvgPicture.asset(
                'assets/svgs/pills.svg',
                width: 300,
              ),
            ),
            Positioned(
              // padding: const EdgeInsets.all(30),
              bottom: 30,
              left: 30,
              right: 30,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.whiteColor.withOpacity(.8),
                ),
                child: Column(
                  // padding: const EdgeInsets.symmetric(horizontal: 50),
                  children: [
                    Text(
                      'Success Sign Up',
                      style: TextStyle(
                        color: AppColors.primaryHighContrast,
                        fontSize: 27,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: AppColors.whiteColor,
                          ),
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                "login", (route) => false);
                          },
                          child: const Text("Sign In")),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
