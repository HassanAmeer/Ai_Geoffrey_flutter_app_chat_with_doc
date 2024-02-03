import 'dart:developer';
import 'dart:io';

import 'package:ask_geoffrey/purchase_api.dart';
import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:ask_geoffrey/utils/app_textstyle.dart';
import 'package:ask_geoffrey/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyPremiumScreen extends StatefulWidget {
  const BuyPremiumScreen({Key? key}) : super(key: key);

  @override
  State<BuyPremiumScreen> createState() => _BuyPremiumScreenState();
}

class _BuyPremiumScreenState extends State<BuyPremiumScreen> {
  String bullet = "\u2022 ";
  late List<Offering> offerings;
  int selected = -1;
  String testingText = 'Continue Purchase';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOffers();
  }

  fetchOffers() async {
    offerings = await PurchaseApi.fetchOffers();
    log("offerings: $offerings");
    // final packages = offerings
    //     .map((offer) => offer.availablePackages)
    //     .expand((element) => element)
    //     .toList();
    // log("packages: $packages");
    // pmonth = packages.firstWhere(
    //     (element) => element.storeProduct.identifier == "chatfuse_10_1m");
    // pYear = packages.firstWhere(
    //     (element) => element.storeProduct.identifier == "chatfuse_10_1y");

    setState(() {});
  }

  showLinks() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text(
              "Important",
              style: TextStyle(color: Colors.black),
            ),
            content: SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      launchUrl(
                        Uri.parse(
                            "https://sites.google.com/view/askgeoffrey/terms-and-condition?authuser=0"),
                      );
                    },
                    child: const Text(
                      "Terms of Use (EULA)",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      launchUrl(
                        Uri.parse(
                            "https://sites.google.com/view/askgeoffrey/privacy-policy_1?authuser=0"),
                      );
                    },
                    child: const Text(
                      "Privacy Policy",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.textFieldColor,
        title: const Text('Buy-Premium'),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showLinks();
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
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
                height: 20.h,
              ),
              featureBox(),
              SizedBox(
                height: 20.h,
              ),
              planBox(),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (selected == -1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Choose a Package"),
                          ),
                        );
                        return;
                      }
                      if (Platform.isIOS) {
                        testingText = 'ios: true';
                        setState(() {});
                        // showLoadingDialog();
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Note"),
                                content: const Text(
                                    "Wait for the Payment Flow to complete, Then Restart the App."),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("Ok"),
                                  ),
                                ],
                              );
                            });
                        String id = '';
                        switch (selected) {
                          case 0:
                            id = "geoffery_799_w";
                            break;
                          case 1:
                            id = "geoffery_999_m";
                            break;
                          case 2:
                            id = "geoffery_2599_3m";
                            break;
                          case 3:
                            id = "geoffery_5999_y";
                            break;
                        }
                        var detail = await Purchases.purchaseProduct(id);
                        testingText = 'purchase done';
                        setState(() {});
                        if (detail.activeSubscriptions.isNotEmpty) {
                          //if (!mounted) return;
                          Navigator.of(context).pop();
                          testingText = 'in if after pop';
                          setState(() {});
                          showSuccessDialog();
                        } else {
                          //if (!mounted) return;
                          Navigator.of(context).pop();
                          testingText = 'in else after pop';
                          setState(() {});
                          showFailDialog();
                        }
                      } else {
                        getOffers(offerings[0].availablePackages[selected]);
                      }
                    },
                    child: Container(
                      height: 50.h,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.textFieldColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Center(
                          child: Text(
                        'Continue Purchase',
                        style: GoogleFonts.workSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      restorePurchase(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: AppColors.textFieldColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Center(
                          child: Text(
                        'Restore Purchases',
                        style: GoogleFonts.workSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      )),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget featureBox() {
    return Container(
      height: 160.h,
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.textFieldColor,
          borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Features',
              style: AppTextStyle.style16W600(Colors.white),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              '$bullet Unlimited Chats No Restrictions',
              style: AppTextStyle.style12W400(Colors.white),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              '$bullet Fast Response Speed',
              style: AppTextStyle.style12W400(Colors.white),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              '$bullet Accurate Answers',
              style: AppTextStyle.style12W400(Colors.white),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              '$bullet Access Previous Chats',
              style: AppTextStyle.style12W400(Colors.white),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              '$bullet Much More',
              style: AppTextStyle.style12W400(Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget planBox() {
    return Container(
      height: 270.h,
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.textFieldColor,
          borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Choose Your Plan',
                style: AppTextStyle.style16W600(Colors.white),
              ),
              SizedBox(
                height: 10.h,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selected = 0;
                  });
                },
                child: Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: selected == 0 ? Colors.green : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Weekly',
                              style: AppTextStyle.style16W600(Colors.white),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'Enjoy Premium For 1 Week',
                              style: AppTextStyle.style12W400(Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Platform.isAndroid
                                  ? offerings[0]
                                      .availablePackages[0]
                                      .storeProduct
                                      .priceString
                                      .split(".")[0]
                                  : "\$ 7.99",
                              style: AppTextStyle.style16W600(Colors.white),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'Weekly',
                              style: AppTextStyle.style12W400(Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selected = 1;
                  });
                },
                child: Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: selected == 1 ? Colors.green : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Monthly',
                              style: AppTextStyle.style16W600(Colors.white),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'Enjoy Premium For 1 Month',
                              style: AppTextStyle.style12W400(Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Platform.isAndroid
                                  ? offerings[0]
                                      .availablePackages[1]
                                      .storeProduct
                                      .priceString
                                      .split(".")[0]
                                  : "\$ 9.99",
                              style: AppTextStyle.style16W600(Colors.white),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              '1 Month',
                              style: AppTextStyle.style12W400(Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selected = 2;
                  });
                },
                child: Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: selected == 2 ? Colors.green : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '3 Months',
                              style: AppTextStyle.style16W600(Colors.white),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'Enjoy Premium For 3 Month',
                              style: AppTextStyle.style12W400(Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Platform.isAndroid
                                  ? offerings[0]
                                      .availablePackages[2]
                                      .storeProduct
                                      .priceString
                                      .split(".")[0]
                                  : "\$ 25.99",
                              style: AppTextStyle.style16W600(Colors.white),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              '3 Monthly',
                              style: AppTextStyle.style12W400(Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selected = 3;
                  });
                },
                child: Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: selected == 3 ? Colors.green : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Yearly',
                              style: AppTextStyle.style16W600(Colors.white),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'Enjoy Premium For 1 Year',
                              style: AppTextStyle.style12W400(Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Platform.isAndroid
                                  ? offerings[0]
                                      .availablePackages[3]
                                      .storeProduct
                                      .priceString
                                      .split(".")[0]
                                  : "\$ 59.99",
                              style: AppTextStyle.style16W600(Colors.white),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'Yearly',
                              style: AppTextStyle.style12W400(Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getOffers(Package p) async {
    showLoadingDialog();
    log(p.storeProduct.description);
    bool purchaseMade = await PurchaseApi.purchasePackage(p);
    PurchaseApi.isPaid = true;
    log("purchase: $purchaseMade");
    if (!mounted) return;
    if (!purchaseMade) {
      Navigator.of(context).pop();
      showFailDialog();
    } else {
      Navigator.of(context).pop();
      showSuccessDialog();
    }
  }

  showFailDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Payment Failed",
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              "Payment Failed! Please Try Again Later",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"),
              ),
            ],
          );
        });
  }

  showSuccessDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Payment Success",
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              "Payment Done! Thank You for your Purchase",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (ctx) => const HomeScreen()),
                      (route) => false);
                },
                child: const Text("Ok"),
              ),
            ],
          );
        });
  }

  showLoadingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const AlertDialog(
            title: Text(
              "Loading",
              style: TextStyle(color: Colors.black),
            ),
            content: SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }

  restorePurchase(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return const AlertDialog(
          title: Text(
            "Fetching Purchases",
            style: TextStyle(color: Colors.black),
          ),
          content: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

    var cust = await Purchases.getCustomerInfo();
    Navigator.of(context).pop();
    if (cust.activeSubscriptions.isNotEmpty) {
      PurchaseApi.isPaid = true;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text(
              "Purchase Restored",
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              "Restore Done",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text(
              "Purchase Restored",
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              "No Purchases to Restore",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}
