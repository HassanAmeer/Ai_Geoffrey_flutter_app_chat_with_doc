import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class Utils {

  static Future flushBarErrorMessage(String message, BuildContext context) {
    // remove const if it create problem
    final _route = showFlushbar(
        context: context,
        flushbar: Flushbar(
          borderRadius: BorderRadius.circular(10),
          borderColor: Colors.grey,
          borderWidth: 1,
          message: message,
          forwardAnimationCurve: Curves.decelerate,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(15),
          duration: const Duration(seconds: 3),
          reverseAnimationCurve: Curves.easeInOut,
          backgroundColor: Colors.red,
          positionOffset: 20,
          icon: const Icon(
            Icons.error,
            size: 28,
            color: Colors.white,
          ),
        )
    );




    return Navigator.of(context, rootNavigator: true).push(_route);
  }


  static Future flushBarSuccessMessage(String message, BuildContext context) {
    // remove const if it create problem


    final _route = showFlushbar(
        context: context,
        flushbar: Flushbar(
          borderRadius: BorderRadius.circular(10),
          borderColor: Colors.grey,
          borderWidth: 1,
          message: message,
          forwardAnimationCurve: Curves.decelerate,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(15),
          duration: const Duration(seconds: 3),
          reverseAnimationCurve: Curves.easeInOut,
          backgroundColor: AppColors.textFieldColor,
          positionOffset: 20,
          icon: const Icon(
            Icons.check_circle,
            size: 28,
            color: Colors.white,
          ),
        )
    );




    return Navigator.of(context, rootNavigator: true).push(_route);


  }


  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }


  static void shiftFocusOfField(BuildContext context, FocusNode currentFocus, FocusNode nextFocus){
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }


  static bool checkEmail(String email){
    final bool emailValid =
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);


    return emailValid;
  }
}