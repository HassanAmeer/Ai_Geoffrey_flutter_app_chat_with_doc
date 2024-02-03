import 'package:ask_geoffrey/views/authentication/login_activated.dart';
import 'package:ask_geoffrey/views/authentication/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_textstyle.dart';
import '../components/auth_components.dart';
import 'auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Lets Get Started!",
                  style: AppTextStyle.textStyle1,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Find the right ticket and what\nyou want only in my ticket",
                  style: AppTextStyle.textStyle3,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.textFieldColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen()));
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 80,
                    ),
                    Text(
                      'Sign Up Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Or Use Instant Sign Up",
                  style: AppTextStyle.textStyle3,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            CustomContainer2(
                text: "Sign with Google",
                icon: const AssetImage("assets/icons/google.png"),
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();
                }),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            CustomContainer2(
                text: "Sign with Apple",
                icon: const AssetImage("assets/icons/apple.png"),
                onPressed: () {}),
            SizedBox(
              height: MediaQuery.of(context).size.height * .04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already Have an Account?",
                  style: AppTextStyle.textStyle3,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginActivated()));
                  },
                  child: const Text(
                    " Sign In",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ])),
    );
  }
}
