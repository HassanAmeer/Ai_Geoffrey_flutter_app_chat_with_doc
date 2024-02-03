import 'dart:io';

import 'package:ask_geoffrey/purchase_api.dart';
import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:ask_geoffrey/utils/app_images.dart';
import 'package:ask_geoffrey/views/buy_premium_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textFieldColor,
        foregroundColor: Colors.grey[200],
        title: const Text('Settings'),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(
                height: 25.h,
              ),
              settingBox(),
              SizedBox(
                height: 10.h,
              ),
              if (!PurchaseApi.isPaid)
                GestureDetector(
                  onTap: () {
                    Get.to(const BuyPremiumScreen());
                  },
                  child: Container(
                    height: 65.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.textFieldColor,
                        borderRadius: BorderRadius.circular(15.r)),
                    child: Center(
                        child: Text(
                      'Buy Premium'.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingBox() {
    return Flexible(
      child: Container(
        //height: 320.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.textFieldColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            CircleAvatar(
              backgroundImage: const AssetImage(AppImages.splashLogo),
              radius: 35.r,
              backgroundColor: AppColors.backgroundColor,
            ),
            const Text("Version"),
            SizedBox(
              height: 5.h,
            ),
            const Divider(
              thickness: 1.5,
              color: AppColors.backgroundColor,
            ),
            Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {
                    launchUrl(
                      Uri.parse(
                          "https://sites.google.com/view/askgeoffrey/home"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'About Us',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {
                    launchUrl(
                      Uri.parse(
                          "https://sites.google.com/view/askgeoffrey/contact-us?authuser=0"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Contact Us',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {
                    if (Platform.isIOS) {
                      Share.share(
                          "https://apps.apple.com/us/app/ask-geoffery/id6450016983");
                    } else {
                      Share.share(
                          "https://play.google.com/store/apps/details?id=com.ask.geoffery");
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Share App',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {
                    if (Platform.isIOS) {
                      launchUrl(
                        Uri.parse(
                            "https://apps.apple.com/us/app/ask-geoffery/id6450016983"),
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      launchUrl(
                        Uri.parse(
                            "https://play.google.com/store/apps/details?id=com.ask.geoffery"),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Rate Us',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {
                    launchUrl(
                      Uri.parse(
                          "https://sites.google.com/view/askgeoffrey/privacy-policy_1?authuser=0"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Privacy Policy',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {
                    launchUrl(
                      Uri.parse(
                          "https://sites.google.com/view/askgeoffrey/terms-and-condition?authuser=0"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Terms and Conditions',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {
                    launchUrl(
                      Uri.parse(
                          "https://sites.google.com/view/ask-geoffrey-eula/home"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'End User License / Terms of Use',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {
                    launchUrl(
                      Uri.parse(
                          "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Terms of Use',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
