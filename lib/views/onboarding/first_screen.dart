
import 'package:ask_geoffrey/views/authentication/login.dart';
import 'package:ask_geoffrey/views/authentication/login_activated.dart';
import 'package:ask_geoffrey/views/components/auth_components.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/app_images.dart';
import '../../utils/app_textstyle.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController(initialPage: 1);
  bool page = true;
  int transition = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height * .5,
        width: double.infinity,
        color: Colors.black,
        child: Center(
          child: CircleAvatar(
            radius: 138,
            backgroundColor: Colors.blue,
            child: CircleAvatar(
              radius: 135,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 123,
                backgroundColor: Colors.blue,
                child: CircleAvatar(
                  radius: 120,
                  backgroundColor: Colors.black,
                  child: Center(
                      child: Image.asset(
                    AppImages.splashLogo,
                    width: 250,
                    height: 250,
                  )),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: page ? Container(
        alignment: Alignment.bottomCenter,
        color: const Color(0xff111728),
        height: MediaQuery.of(context).size.height * .5,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to Ask Geoffrey",
                  style: AppTextStyle.textStyle1,
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Get updated AI models and many\nmore, Lets Sign-up Today",
                  style: AppTextStyle.textStyle3,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: SmoothPageIndicator(
                controller: controller,
                count: 2,
                // forcing the indicator to use a specific direction
                textDirection: TextDirection.values[transition],
                effect: const ExpandingDotsEffect(),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const LoginActivated()));
                    },
                    child: const CustomButton2(text: "Skip", loading: false, color: Status.grey)),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      page = false;
                      transition = 1;
                    });
                  },
                    child: const CustomButton2(text: "Next", loading: false, color: Status.blue)),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "By Continuing, you agree to our Privacy\nPolicy & Terms Of Use.",
                  style: AppTextStyle.textStyle3,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ) : Container(
        alignment: Alignment.bottomCenter,
        color: const Color(0xff111728),
        height: MediaQuery.of(context).size.height * .5,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "The Power Of AI\nIn Your Pocket",
                    style: AppTextStyle.textStyle1,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "We are a leading chat platform\nwith the latest updates.",
                    style: AppTextStyle.textStyle3,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: SmoothPageIndicator(
                controller: controller,
                count: 2,
                // forcing the indicator to use a specific direction
                textDirection: TextDirection.values[transition],
                effect: const ExpandingDotsEffect(),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        page = true;
                        transition = 0;
                      });
                    },
                    child: const CustomButton2(text: "Back", loading: false, color: Status.grey)),
                GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: const CustomButton2(text: "Next", loading: false, color: Status.blue)),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "By Continuing, you agree to our Privacy\nPolicy & Terms Of Use.",
                  style: AppTextStyle.textStyle3,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
