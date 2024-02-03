import 'dart:convert';
import 'dart:developer';

import 'package:ask_geoffrey/models/images.dart';
import 'package:ask_geoffrey/network/api_services.dart';
import 'package:ask_geoffrey/purchase_api.dart';
import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:ask_geoffrey/utils/app_textstyle.dart';
import 'package:ask_geoffrey/views/buy_premium_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SearchImageScreen extends StatefulWidget {
  const SearchImageScreen({Key? key}) : super(key: key);

  @override
  State<SearchImageScreen> createState() => _SearchImageScreenState();
}

class _SearchImageScreenState extends State<SearchImageScreen> {
  final TextEditingController _chatController = TextEditingController();
  bool imagesAvailable = false;
  bool searching = false;
  final double _value = 3;
  List<Images> imagesList = [];
  //late SharedPreferences prefs;
  bool isPaid = false;
  int searchCount = 0;
  stt.SpeechToText speech = stt.SpeechToText();
  bool speechAvailable = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    initPrefs();
    imagesAvailable = imagesList.isNotEmpty ? true : false;
    //initSpeech();
  }

  initSpeech() async {
    speechAvailable = await speech.initialize(
        onStatus: (s) {},
        onError: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Unable to use MicroPhone"),
            ),
          );
        });
  }

  void initPrefs() async {
    //prefs = await SharedPreferences.getInstance();
    //isPaid = prefs.getBool("isPaid") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: true,
      key: _key,
      appBar: AppBar(
        title: const Text("Image Bot"),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.textFieldColor,
      ),
      body: Container(
        //height: double.infinity,
        //width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: imagesAvailable
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      //crossAxisCount: 3,
                      //mainAxisSpacing: 10,
                      itemCount: imagesList.length, // > 4 && isPaid ? 4 : 2,
                      //crossAxisSpacing: 10,
                      semanticChildCount: 6,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return SimpleDialog(
                                  insetPadding: const EdgeInsets.symmetric(
                                      horizontal: 0.0, vertical: 0.0),
                                  contentPadding: const EdgeInsets.all(0),
                                  alignment: Alignment.center,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  children: [
                                    CachedNetworkImage(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      imageUrl: imagesList[index].url,
                                      placeholder: (context, url) => Container(
                                        color: const Color(0xfff5f8fd),
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: InkWell(
                                        onTap: () async {
                                          log("here");
                                          // String? out = await ImageDownloader
                                          //     .downloadImage(
                                          //         imagesList[index].url);
                                          // log("$out");
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff1C1B1B)
                                                    .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              height: 50,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white24,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                        Color(0x36FFFFFF),
                                                        Color(0x0FFFFFFF)
                                                      ],
                                                          begin:
                                                              FractionalOffset
                                                                  .topLeft,
                                                          end: FractionalOffset
                                                              .bottomRight)),
                                              child: const Text(
                                                "Download",
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          },
                          child: Hero(
                            tag: imagesList[index].url,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6)),
                              height: index % 2 == 0 ? 180 : 250,
                              width: MediaQuery.of(context).size.width / 3,
                              child: ImageCard(
                                imageData: imagesList[index].url,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: searchingWidget(),
                    ),
            ),
            buildInput(),
          ],
        ),
      ),
    );
  }

  Widget searchingWidget() {
    if (searching) {
      return const CircularProgressIndicator(
        color: Colors.blue,
      );
    } else {
      return const Text(
        "Search for any image",
        style: TextStyle(color: Colors.grey),
      );
    }
  }

  Widget buildInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 5, bottom: 10, top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                //textAlignVertical: TextAlignVertical.center,
                style: TextStyle(fontSize: 13.sp, color: Colors.black),
                textCapitalization: TextCapitalization.sentences,
                controller: _chatController,
                cursorColor: AppColors.primaryColor,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      await Permission.microphone.request();
                      speechAvailable = await speech.initialize(
                        onStatus: (s) {},
                        onError: (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Unable to use MicroPhone"),
                            ),
                          );
                        },
                      );
                      if (speechAvailable) {
                        speech.listen(
                          onResult: (result) {
                            log(result.recognizedWords);
                            _chatController.text = result.recognizedWords;
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Unable to use MicroPhone"),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.mic,
                      size: 22.h,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  //isDense: true,
                  hintText: 'What image would you like to see?',
                  hintStyle: AppTextStyle.style12W400(Colors.white),
                  fillColor: AppColors.textFieldColor,
                  filled: true,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => sendMessage(),
            child: CircleAvatar(
              radius: 22.r,
              backgroundColor: AppColors.primaryColor,
              child: Center(
                child: Image.asset(
                  "assets/images/send_button.png",
                  height: 30.h,
                  width: 30.w,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
    );
  }

  sendMessage() async {
    if (_chatController.text == '') return;
    FocusManager.instance.primaryFocus?.unfocus();
    final prefs = await SharedPreferences.getInstance();
    int searchCount =
        prefs.getInt(DateTime.now().toString().split(" ")[0]) ?? 0;
    if (PurchaseApi.isPaid) {
      // await prefs.setInt(
      //     "${DateTime.now().toString().split(" ")[0]}-image",
      //     searchCount + 1);

      // if (searching) {
      //   return;
      // }
      setState(() {
        searching = true;
        imagesAvailable = false;
      });
      submitGetImagesForm(
        context: context,
        prompt: _chatController.text.toString(),
        n: _value.round(),
      ).then((value) async {
        // searching = false;
        imagesList = value;
        final dataToStore =
            jsonEncode(imagesList.map((e) => e.toJson()).toList());
        print(dataToStore);
        final date = DateTime.now().toString().split(" ")[0];

        // await prefs.setString(
        //     "${searchController.text}_$date", dataToStore);
        // coins = coins - 3;
        // await prefs.setInt("coins", coins);
        // List<String> list = prefs.getStringList("oldImages") ?? [];
        // if (!list.contains("${searchController.text}_$date")) {
        //   list.add("${searchController.text}_$date");
        //   await prefs.setStringList("oldImages", list);
        // }
        setState(() {
          imagesAvailable = imagesList.isNotEmpty ? true : false;
        });
      });
    } else {
      if (searchCount < 30) {
        setState(() {
          searching = true;
          imagesAvailable = false;
        });
        submitGetImagesForm(
          context: context,
          prompt: _chatController.text.toString(),
          n: _value.round(),
        ).then((value) async {
          // searching = false;
          imagesList = value;
          final dataToStore =
              jsonEncode(imagesList.map((e) => e.toJson()).toList());
          print(dataToStore);
          final date = DateTime.now().toString().split(" ")[0];
          // await prefs.setString(
          //     "${searchController.text}_$date", dataToStore);
          // coins = coins - 3;
          // await prefs.setInt("coins", coins);
          // List<String> list = prefs.getStringList("oldImages") ?? [];
          // if (!list.contains("${searchController.text}_$date")) {
          //   list.add("${searchController.text}_$date");
          //   await prefs.setStringList("oldImages", list);
          // }
          setState(() {
            imagesAvailable = imagesList.isNotEmpty ? true : false;
          });
        });
        searchCount += 1;
        prefs.setInt(DateTime.now().toString().split(" ")[0], searchCount);
      } else {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text("Buy Coins"),
                content: const Text(
                    "You don't have enough balance in your account. You can buy the coins to Proceed"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 11, 54, 92),
                    ),
                    child: const Text("Not now"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Get.to(() => const BuyPremiumScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 11, 54, 92),
                    ),
                    child: const Text("Ok"),
                  ),
                ],
              );
            });
      }
    }
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.imageData});

  final String imageData;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: CachedNetworkImage(
        imageUrl: imageData,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
            height: 150,
            width: 150,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade100,
              highlightColor: Colors.white,
              child: Container(
                height: 220,
                width: 130,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
              ),
            )),
      ),
    );
  }
}

class CustomPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  CustomPageRoute({builder}) : super(builder: builder);
}
