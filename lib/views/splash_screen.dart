import 'dart:async';

import 'package:ask_geoffrey/ai_screen.dart';
import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:ask_geoffrey/views/authentication/login.dart';
import 'package:ask_geoffrey/views/authentication/login_activated.dart';
import 'package:ask_geoffrey/views/authentication/signup.dart';
import 'package:ask_geoffrey/views/home_screen.dart';
import 'package:ask_geoffrey/views/onboarding/first_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../utils/app_images.dart';
import '../utils/app_textstyle.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    initOneSignal();
    Timer(const Duration(seconds: 2), () {
      // Navigate to the desired screen after the splash screen.
      Get.off(
        const OnboardingScreen(),
      );
    });
    super.initState();
  }

  initOneSignal() async {
    await OneSignal.shared.setAppId("4de60682-89ed-4f9d-ada7-f0393b3c822c");

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print(
          '"OneSignal: notification opened: ${result.notification.launchUrl}');

      result.notification.launchUrl;
    });
    print('id Attached');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
         color: Colors.black,
        ),
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.bottomCenter,
        //     end: Alignment.topCenter,
        //     colors: [
        //       AppColors.containerColor1,
        //       AppColors.containerColor2,
        //       AppColors.containerColor3,
        //     ],
        //   ),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            Center(
                child: Image.asset(
              AppImages.splashLogo,
              height: 180.h,
              width: 180.w,
            )),
            Text(
              'Ask Geoffrey',
              style: AppTextStyle.style25W600(Colors.blue),
            ),
            SizedBox(
              height: 150.h,
            ),
            const CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
            Text(
              'Loading',
              style: AppTextStyle.style16W600(AppColors.primaryColor),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
