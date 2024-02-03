import 'dart:async';

import 'package:ask_geoffrey/ai_screen.dart';
import 'package:ask_geoffrey/views/authentication/login.dart';
import 'package:ask_geoffrey/views/authentication/signup.dart';
import 'package:ask_geoffrey/views/components/auth_components.dart';
import 'package:ask_geoffrey/views/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_textstyle.dart';
import '../../utils/utils.dart';
import 'authRepository.dart';

class AuthViewModel with ChangeNotifier {
  final _authRepo = AuthRepository();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  String getUserUid() {
    return _authRepo.userUid();
  }

  registerUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name}) {
    setLoading(true);
    _authRepo
        .registerUser(email: email, password: password, name: name)
        .then((value) {
      setLoading(false);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                contentPadding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                backgroundColor: AppColors.textFieldColor,
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 400,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Image(
                        image: AssetImage("assets/icons/tick.png"),
                        height: 130,
                        width: 130,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Successfully\nRegistered",
                            style: AppTextStyle.textStyle1,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Congratulations, your account\nhas been registered in this application.",
                            style: AppTextStyle.textStyle3,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen()));
                          },
                          child:
                              const CustomButton(text: "Home", loading: false)),
                    ],
                  ),
                ),
              ));
      Timer(const Duration(seconds: 3), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      });
      Utils.flushBarSuccessMessage("Welcome!!", context);
    }).onError((error, stackTrace) {
      setLoading(false);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                contentPadding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                backgroundColor: AppColors.textFieldColor,
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 400,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Image(
                        image: AssetImage("assets/icons/cross.png"),
                        height: 130,
                        width: 130,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Failed\nRegistration",
                            style: AppTextStyle.textStyle1,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Registration Failed! Please try again.",
                            style: AppTextStyle.textStyle3,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignupScreen()));
                          },
                          child: const CustomButton(
                            text: "Re-Registration",
                            loading: false,
                          )),
                    ],
                  ),
                ),
              ));
      Utils.flushBarErrorMessage(error.toString(), context);
    });
  }

  loginUser(
      {required BuildContext context,
      required String email,
      required String password}) {
    setLoading(true);

    _authRepo.loginUser(email: email, password: password).then((value) {
      setLoading(false);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
      Utils.flushBarSuccessMessage("Welcome!!", context);
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.flushBarErrorMessage(error.toString(), context);
    });
  }

  signOutUser({required BuildContext context}) {
    _authRepo.logoutUser().then((value) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      Utils.flushBarSuccessMessage("Logout successfully", context);
    }).onError((error, stackTrace) {
      Utils.flushBarSuccessMessage("Logout Failed", context);
    });
  }

  bool checkIsUserLoggedIn() {
    return _authRepo.isUserLoggedIn();
  }
}

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    notifyListeners();
  }
}
