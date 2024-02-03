import 'package:ask_geoffrey/ai_screen.dart';
import 'package:ask_geoffrey/views/authentication/signup.dart';
import 'package:ask_geoffrey/views/chatpage/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_textstyle.dart';
import '../../utils/utils.dart';
import '../components/auth_components.dart';
import 'auth_view_model.dart';
import 'forgotpassword.dart';

class LoginActivated extends StatefulWidget {
  const LoginActivated({super.key});

  @override
  State<LoginActivated> createState() => _LoginActivatedState();
}

class _LoginActivatedState extends State<LoginActivated> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hello Again!",
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
                  "Welcome Back!\nYou’ve been missed",
                  style: AppTextStyle.textStyle3,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            CustomContainer(
              type: Type.withoutPassword,
              hintText: "Enter your email",
              icon: Icons.email_outlined,
              controller: emailController,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            CustomContainer(
              type: Type.password,
              hintText: "Enter your password",
              icon: Icons.lock_outline,
              controller: passwordController,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPassword()));
                  },
                  child: Text(
                    "Forgot Password?",
                    style: AppTextStyle.textStyle2,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            CustomButton(
                text: "Sign In",
                loading: authProvider.isLoading,
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  if (emailController.text.trim().isEmpty) {
                    Utils.flushBarErrorMessage(
                        "Email Field cannot be empty.", context);
                    setState(() {
                      isLoading = false;
                    });
                  } else if (passwordController.text.trim().isEmpty) {
                    Utils.flushBarErrorMessage(
                        "Password Field cannot be empty.", context);
                    setState(() {
                      isLoading = false;
                    });
                  } else if (passwordController.text.trim().length < 6) {
                    Utils.flushBarErrorMessage(
                        "Password must be 6 characters long.", context);
                    setState(() {
                      isLoading = false;
                    });
                  } else {
                    AuthViewModel().loginUser(
                        context: context,
                        email: emailController.text.toString(),
                        password: passwordController.text.toString());
                    setState(() {
                      isLoading = false;
                    });
                  }
                }),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            CustomContainer2(
                text: "Sign with Google",
                icon: const AssetImage("assets/icons/google.png"),
                onPressed: () {}),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            CustomContainer2(
                text: "Sign with Apple",
                icon: const AssetImage("assets/icons/apple.png"),
                onPressed: () {}),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Or",
                  style: AppTextStyle.textStyle3,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: AppTextStyle.textStyle3,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()));
                  },
                  child: const Text(
                    " Sign Up",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
