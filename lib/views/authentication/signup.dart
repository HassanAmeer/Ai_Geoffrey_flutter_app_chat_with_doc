import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_textstyle.dart';
import '../../utils/utils.dart';
import '../components/auth_components.dart';
import 'auth_view_model.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                      },
                      child: Container(
                        width: 45,
                        padding: const EdgeInsets.only(left: 10),
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
                height: MediaQuery.of(context).size.height * .03,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Text(
                      "Create an account",
                      style: AppTextStyle.textStyle1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .04,
              ),
              CustomContainer(
                type: Type.withoutPassword,
                hintText: "Name",
                icon: Icons.person,
                controller: nameController,
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
              CustomButton(
                  loading: authProvider.isLoading,
                  text: "Sign Up",
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      Utils.flushBarErrorMessage(
                          "Name Field Cannot be empty", context);
                    } else if (emailController.text.trim().isEmpty) {
                      Utils.flushBarErrorMessage(
                          "Email Field Cannot be empty", context);
                    } else if (!Utils.checkEmail(
                        emailController.text.trim().toString())) {
                      Utils.flushBarErrorMessage(
                          "Please enter a valid email", context);
                    } else if (passwordController.text.trim().isEmpty) {
                      Utils.flushBarErrorMessage(
                          "Password Field Cannot be empty", context);
                    } else if (passwordController.text.trim().length < 6) {
                      Utils.flushBarErrorMessage(
                          "Password should be greater than 5 characters",
                          context);
                    } else {
                      // every thing is fine
                      authProvider.registerUser(
                          context: context,
                          email: emailController.text.toString(),
                          password: passwordController.text.toString(),
                          name: nameController.text.trim().toString());
                    }
                  }),
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
                height: MediaQuery.of(context).size.height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "By sign in accept the terms of service.\n Guidelines and have read Privacy Policy.",
                    style: AppTextStyle.textStyle3,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
