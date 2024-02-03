import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle{

  static TextStyle textStyle1 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static TextStyle textStyle4 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static TextStyle textStyle2 = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle textStyle3 = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.grey[600],
  );

  static TextStyle style25W600(Color color){
    return GoogleFonts.workSans(
        fontSize: 25.sp,
        fontWeight: FontWeight.w600,
        color: color
    );
  }

  static TextStyle style16W600(Color color){
    return GoogleFonts.workSans(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: color
    );
  }

  static TextStyle style12W400(Color color){
    return GoogleFonts.workSans(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: color
    );
  }
}