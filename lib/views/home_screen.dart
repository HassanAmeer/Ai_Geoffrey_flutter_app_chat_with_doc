// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:ask_geoffrey/network/api_services.dart';
import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:ask_geoffrey/utils/app_textstyle.dart';
import 'package:ask_geoffrey/views/camera_screen.dart';
import 'package:ask_geoffrey/views/category_screen.dart';
import 'package:ask_geoffrey/views/chatHistory.dart';
import 'package:ask_geoffrey/views/new_chat_screen.dart';
import 'package:ask_geoffrey/views/pdf_summarize.dart';
import 'package:ask_geoffrey/views/prompt_screen.dart';
import 'package:ask_geoffrey/views/search_image_screen.dart';
import 'package:ask_geoffrey/views/setting_screen.dart';
import 'package:ask_geoffrey/views/song_identifiction_screen.dart';
import 'package:ask_geoffrey/views/textToPdfPage.dart';
import 'package:ask_geoffrey/views/web_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ask_geoffrey/purchase_api.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_images.dart';
import 'buy_premium_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlatformFile? _file;
  String text = '';
  var _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool isLoading = false;
  int tokenValue = 4000;
  final TextEditingController _chatController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Ask Geoffery',
          style: AppTextStyle.textStyle1,
        ),
        backgroundColor: AppColors.backgroundColor,
        actions: [
          if (!PurchaseApi.isPaid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  Get.to(const BuyPremiumScreen());
                },
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 25.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                          color: AppColors.textFieldColor,
                          borderRadius: BorderRadius.circular(20.r)),
                    ),
                    Container(
                      height: 28.h,
                      width: 28.w,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_cart,
                        size: 15,
                      ),
                    ),
                    Positioned(
                        left: 32.w,
                        child: Text(
                          'BUY NOW',
                          style: AppTextStyle.textStyle2,
                        )),
                  ],
                ),
              ),
            )
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          // gradient: LinearGradient(
          //   begin: Alignment.bottomCenter,
          //   end: Alignment.topCenter,
          //   colors: [
          //     AppColors.containerColor1,
          //     AppColors.containerColor2,
          //     AppColors.containerColor3,
          //   ],
          // ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 180.w,
                    height: 180.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 5.w,
                      ),
                    ),
                  ),
                  Container(
                    width: 260.w,
                    height: 260.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 5.w,
                      ),
                    ),
                  ),
                  Image.asset(
                    AppImages.splashLogo,
                    height: 200.h,
                    width: 200.w,
                  )
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Powered by Chat GPT 3.5 and 4',
                style: AppTextStyle.textStyle4,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50.h,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        chatBox(),
                        const SizedBox(
                          width: 5,
                        ),
                        imageBox(),
                        const SizedBox(
                          width: 5,
                        ),
                        webBox(),
                        const SizedBox(
                          width: 5,
                        ),
                        pdfBox(),
                        const SizedBox(
                          width: 5,
                        ),
                        textToPdf(),
                        const SizedBox(
                          width: 5,
                        ),
                        imageSBox(),
                        const SizedBox(
                          width: 5,
                        ),
                        chat_history(),
                        const SizedBox(
                          width: 5,
                        ),
                        songBox(),
                        const SizedBox(
                          width: 5,
                        ),
                        listBox(),
                        const SizedBox(
                          width: 5,
                        ),
                        promptsBox(),
                        const SizedBox(
                          width: 5,
                        ),
                        settingsBox(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageSBox() {
    return GestureDetector(
      onTap: () async {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext c) {
            return Container(
              height: 180,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      children: [
                        // for email
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: GestureDetector(
                            onTap: () async {
                              Get.to(cameraScreen(chatId: ''));
                            },
                            child: Container(
                              height: 50.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Camera",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(width: 12.0),
                                  Icon(Icons.camera),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // for admin
                        GestureDetector(
                          onTap: () async {
                            var result = await FilePicker.platform.pickFiles(
                              type: FileType.image,
                              // allowedExtensions: [
                              //   'pdf',
                              // ],
                            );
                            setState(() {
                              _file = result!.files.first;
                            });
                            final recognizedText =
                                await _textRecognizer.processImage(
                                    InputImage.fromFilePath(_file!.path!));
                            // text = await ReadPdfText.getPDFtext(_file!.path!);

                            log(recognizedText.text);
                            Get.to(PdfSummarizeScreen(
                              isImage: true,
                              text: recognizedText.text,
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Container(
                              height: 50.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Gallery",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(width: 12.0),
                                  Icon(Icons.image_outlined),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // end
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        width: 120.w,
        height: 120.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   AppImages.chatIcon,
            //   height: 60.h,
            //   width: 60.w,
            // ),
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: Icon(
                Icons.image_outlined,
                color: Colors.white,
                size: 30.h,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Summarize this Text',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pdfBox() {
    return GestureDetector(
      onTap: () async {
        var result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [
            'pdf',
          ],
        );
        setState(() {
          _file = result!.files.first;
        });
        // text = await ReadPdfText.getPDFtext(_file!.path!);

        // log(text);
        // Get.to(PdfSummarizeScreen(
        //   text: text,
        // ));
      },
      child: Container(
        width: 120.w,
        height: 120.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   AppImages.chatIcon,
            //   height: 60.h,
            //   width: 60.w,
            // ),
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: Icon(
                Icons.picture_as_pdf_outlined,
                color: Colors.white,
                size: 30.h,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Summarize this PDF',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  limitReachedDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            backgroundColor: AppColors.primaryColor, //this right here
            child: SizedBox(
              height: 250.h,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Daily Free Limit Reached',
                      style: AppTextStyle.style16W600(Colors.white),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      'Buy Premium to enjoy unlimited Searches',
                      style: AppTextStyle.style12W400(Colors.white),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_sharp,
                          color: Colors.green,
                        ),
                        Text(
                          'Unlimited Images Searches',
                          style: AppTextStyle.style12W400(Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_sharp,
                          color: Colors.green,
                        ),
                        Text(
                          'Unlimited Text Searches',
                          style: AppTextStyle.style12W400(Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_sharp,
                          color: Colors.green,
                        ),
                        Text(
                          'Access to all Categories',
                          style: AppTextStyle.style12W400(Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_sharp,
                          color: Colors.green,
                        ),
                        Text(
                          'Fast Response',
                          style: AppTextStyle.style12W400(Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 35.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                                child: Text(
                              'No, Thansks',
                              style: AppTextStyle.style12W400(Colors.red),
                            )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            Get.to(const BuyPremiumScreen());
                          },
                          child: Container(
                            height: 35.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                                child: Text(
                              'Buy Now',
                              style: AppTextStyle.style12W400(Colors.green),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  sendMessage() async {
    Navigator.pop(context);
    print("hello");

    print("end==");
    String messagePrompt = "";
    if (isLoading) {
      return;
    }
    isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    int searchCount =
        prefs.getInt(DateTime.now().toString().split(" ")[0]) ?? 0;
    bool isPaid = PurchaseApi.isPaid; //prefs.getBool("isPaid") ?? false;
    log("isPaid: $isPaid");
    if (isPaid) {
      messagePrompt = _chatController.text.toString();
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 130,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Center(
                          child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      )),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Loading",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            ),
          );
        },
      );
      setState(() {
        _chatController.clear();
      });
      if (!mounted) return;

      submitGetChatsForm(
        context: context,
        prompt: messagePrompt,
        tokenValue: tokenValue,
      ).then((value1) async {
        log("here");
        isLoading = false;
        Future.delayed(
          Duration(milliseconds: 10),
          () => Navigator.pop(context),
        ).then((value) {
          Get.to(TextToPdfPage(
            content: value1[0].msg.toString(),
          ));
        });
        setState(() {});
      });

      setState(() {});
    } else {
      print("start");
      if (searchCount < 5) {
        messagePrompt = _chatController.text.toString();
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    height: 130,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Center(
                            child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        )),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Loading",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
            );
          },
        );
        setState(() {
          _chatController.clear();
        });

        if (!mounted) return;

        submitGetChatsForm(
          context: context,
          prompt: messagePrompt,
          tokenValue: tokenValue,
        ).then((value1) async {
          log("here");
          isLoading = false;

          log(value1[0].msg.toString());
          Future.delayed(
            Duration(milliseconds: 10),
            () => Navigator.pop(context),
          ).then((value) {
            Get.to(TextToPdfPage(
              content: value1[0].msg.toString(),
            ));
            setState(() {});
            searchCount += 1;
            prefs.setInt(DateTime.now().toString().split(" ")[0], searchCount);
            print("====");
          });
        });
      } else {
        limitReachedDialog();
        // Get.to(const BuyPremiumScreen());
      }
    }
  }

  Widget textToPdf() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 220,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Make Your Text To Pdf With AI",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: _chatController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Enter Your Topic",
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_chatController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Input cannot be empty")));
                                } else {
                                  sendMessage();
                                }
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(vertical: 10)),
                              ),
                              child: Text("Generate")),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: 120.w,
        height: 120.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
          // gradient: const LinearGradient(
          //   begin: Alignment.centerRight,
          //   end: Alignment.centerLeft,
          //   colors: [
          //     AppColors.containerColor1,
          //     AppColors.containerColor2,
          //     AppColors.containerColor3,
          //   ],
          // ),
          color: AppColors.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   AppImages.chatIcon,
            //   height: 60.h,
            //   width: 60.w,
            // ),
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: Icon(
                Icons.picture_as_pdf_outlined,
                color: Colors.white,
                size: 30.h,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Text to PDF',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget webBox() {
    return GestureDetector(
      onTap: () {
        Get.to(const WebScreen());
      },
      child: Container(
        width: 120.w,
        height: 120.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   AppImages.chatIcon,
            //   height: 60.h,
            //   width: 60.w,
            // ),
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: Icon(
                Icons.link,
                color: Colors.white,
                size: 30.h,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Summarize Web',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Widget for song
  Widget songBox() {
    return GestureDetector(
      onTap: () {
        Get.to(const SongIdentification());
      },
      child: Container(
        width: 120.w,
        height: 120.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   AppImages.chatIcon,
            //   height: 60.h,
            //   width: 60.w,
            // ),
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: Icon(
                Icons.music_note_outlined,
                color: Colors.white,
                size: 30.h,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Sound Seeker',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatBox() {
    return GestureDetector(
      onTap: () {
        Get.to(const NewChatScreen());
      },
      child: Container(
        width: 120.w,
        height: 120.h,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
          // gradient: const LinearGradient(
          //   begin: Alignment.centerRight,
          //   end: Alignment.centerLeft,
          //   colors: [
          //     AppColors.containerColor1,
          //     AppColors.containerColor2,
          //     AppColors.containerColor3,
          //   ],
          // ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   AppImages.chatIcon,
            //   height: 60.h,
            //   width: 60.w,
            // ),
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: Icon(
                Icons.chat,
                color: Colors.white,
                size: 30.h,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Start New Chat',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chat_history() {
    return GestureDetector(
      onTap: () {
        Get.to(const ChatHistory());
      },
      child: Container(
        width: 120.w,
        height: 120.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: Icon(
                Icons.history,
                color: Colors.white,
                size: 40.h,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Chat History',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageBox() {
    return GestureDetector(
      onTap: () {
        Get.to(const SearchImageScreen());
      },
      child: Container(
        width: 120.w,
        height: 120.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
          //
          color: AppColors.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   AppImages.imagesIcon,
            //   height: 60.h,
            //   width: 60.w,
            // ),
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 30.h,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Search an Image',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listBox() {
    return GestureDetector(
      onTap: () {
        Get.to(const CategoryScreen());
      },
      child: Container(
        width: 120.w,
        height: 120.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
          // gradient: const LinearGradient(
          //   begin: Alignment.centerRight,
          //   end: Alignment.centerLeft,
          //   colors: [
          //     AppColors.containerColor1,
          //     AppColors.containerColor2,
          //     AppColors.containerColor3,
          //   ],
          // ),
          color: AppColors.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   AppImages.categoryIcon,
            //   height: 60.h,
            //   width: 60.w,
            // ),
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: Icon(
                Icons.list_alt,
                color: Colors.white,
                size: 30.h,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'All list Catagories',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget promptsBox() {
    return GestureDetector(
      onTap: () {
        Get.to(const PromptsScreen());
      },
      child: Container(
        width: 120.w,
        height: 120.h,
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primaryColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(20.r),
            // gradient: const LinearGradient(
            //   begin: Alignment.centerRight,
            //   end: Alignment.centerLeft,
            //   colors: [
            //     AppColors.containerColor1,
            //     AppColors.containerColor2,
            //     AppColors.containerColor3,
            //   ],
            // ),
            color: AppColors.backgroundColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: Icon(
                Icons.bookmark,
                color: Colors.white,
                size: 40.h,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'All Prompts',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  settingsBox() {
    return GestureDetector(
      onTap: () {
        Get.to(const SettingsScreen());
      },
      child: Container(
        width: 120.w,
        height: 120.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
          // gradient: const LinearGradient(
          //   begin: Alignment.centerRight,
          //   end: Alignment.centerLeft,
          //   colors: [
          //     AppColors.containerColor1,
          //     AppColors.containerColor2,
          //     AppColors.containerColor3,
          //   ],
          // ),
          color: AppColors.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: Icon(
                Icons.settings,
                color: Colors.white,
                size: 40.h,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Settings',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
