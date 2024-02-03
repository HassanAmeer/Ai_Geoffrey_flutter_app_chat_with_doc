import 'package:ask_geoffrey/views/authentication/login_activated.dart';
import 'package:ask_geoffrey/views/components/auth_components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_textstyle.dart';
import '../../utils/utils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginActivated()));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColors.arrowContainer,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Forgot Password?",
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
                  "Type your email, we will send you\nverification code via email",
                  style: AppTextStyle.textStyle3, textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            CustomContainer(hintText: "Enter email here", icon: Icons.email_outlined, controller: emailController, type: Type.withoutPassword),
            SizedBox(
              height: MediaQuery.of(context).size.height * .04,
            ),
            CustomButton(text: "Reset Password", onPressed: () {
              setState(() {
                isLoading = true;
              });
              auth
                  .sendPasswordResetEmail(
                  email: emailController.text.toString())
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
                Utils.flushBarSuccessMessage(
                    "We have sent you Email.", context);
              }).onError((error, stackTrace) {
                setState(() {
                  isLoading = false;
                });
                Utils.flushBarErrorMessage("$error", context);
              });
            }, loading: isLoading),
          ],
        ),
      )),
    );
  }
}
