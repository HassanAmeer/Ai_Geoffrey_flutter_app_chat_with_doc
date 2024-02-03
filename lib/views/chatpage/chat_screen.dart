import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ask_geoffrey/models/chat.dart';
import 'package:ask_geoffrey/network/api_services.dart';
import 'package:ask_geoffrey/purchase_api.dart';
import 'package:ask_geoffrey/utils/app_images.dart';
import 'package:ask_geoffrey/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../models/model.dart';
import '../../utils/app_colors.dart';
import '../buy_premium_screen.dart';
import '../textToPdfPage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int whichModel = 0; // default 3.5
  bool isLoading = false;
  int tokenValue = 500;
  final ScrollController _controller = ScrollController();
  List<Chat> chatToStore = [];
  List<Model> modelsList = [];
  stt.SpeechToText speech = stt.SpeechToText();
  bool speechAvailable = false;
  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isRecording = false;
  bool isCurrentLanguageInstalled = false;
  int count = 0;
  String messagePrompt = "";

  TextEditingController _chatController = TextEditingController();
  List<Chat> chatList = [];

  @override
  void initState() {
    // TODO: implement initState
    _controller.addListener(() {
      _scrollListener();
    });
    getModels();
    //initPrefs();
    initTts();
    loadCount();
    super.initState();
  }

  loadCount() async {
    final prefs = await SharedPreferences.getInstance();
    final chat = prefs.getStringList("oldChats") ?? [];
    count = chat.length + 1;
  }

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (Platform.isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    if (Platform.isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  void getModels() async {
    modelsList = await submitGetModelsForm(context: context);
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      //    message = "reach the bottom";
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      //  message = "reach the top";
    }
  }

  limitReachedDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            backgroundColor: AppColors.textFieldColor, //this right here
            child: SizedBox(
              height: 260.h,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Daily Free Limit Reached',
                      style: AppTextStyle.style16W600(Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Buy Premium to enjoy unlimited Searches',
                      style: AppTextStyle.style12W400(Colors.white),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_sharp,
                          color: Colors.green,
                        ),
                        const SizedBox(
                          width: 10,
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
                        const SizedBox(
                          width: 10,
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
                        const SizedBox(
                          width: 10,
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
                        const SizedBox(
                          width: 10,
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
                              color: AppColors.botTextBubble,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                                child: Text(
                              'No, Thanks',
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
                              color: AppColors.botTextBubble,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.grey[500],
        backgroundColor: AppColors.appBarColor,
        title: const Text("AI Assistant"),
        actions: [
          InkWell(
            onTap: () {
              int modeSelect = whichModel;
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.black12,
                constraints: const BoxConstraints(maxHeight: 300),
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: StatefulBuilder(builder: (context, setState1) {
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: const BoxDecoration(
                                color: AppColors.textFieldColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Select Model",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[200]),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: AppColors.backgroundColor,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState1(() {
                                      modeSelect = 0;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/gpt3.png",
                                            height: 50,
                                            width: 50,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "GPT-3.5-Turbo",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[200]),
                                          ),
                                        ],
                                      ),
                                      if (modeSelect == 0)
                                        const Icon(
                                          Icons.check,
                                          color: AppColors.primaryColor,
                                          size: 35,
                                        )
                                    ],
                                  ),
                                ),
                                const Divider(),
                                InkWell(
                                  onTap: () {
                                    bool isPaid = PurchaseApi.isPaid;
                                    if (!isPaid) {
                                      limitReachedDialog();
                                    } else {
                                      setState1(() {
                                        modeSelect = 1;
                                      });
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/gpt4.png",
                                            height: 50,
                                            width: 50,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "GPT-4",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[200]),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          if (!PurchaseApi.isPaid)
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xffe3bb3f),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 3),
                                              child: const Text(
                                                "PRO",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            )
                                        ],
                                      ),
                                      if (modeSelect == 1)
                                        const Icon(
                                          Icons.check,
                                          color: AppColors.primaryColor,
                                          size: 35,
                                        )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                whichModel = modeSelect;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 7),
                              height: 80,
                              decoration: const BoxDecoration(
                                  color: AppColors.textFieldColor,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: Center(
                                child: Text(
                                  "Select",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[200]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  );
                },
              );
            },
            child: Row(
              children: [
                Text(
                  whichModel == 0 ? "GPT-3.5-Turbo" : "GPT-4",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  width: 15,
                ),
                Image.asset(
                  "assets/images/menu.png",
                  height: 20,
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: chatList.isEmpty ? examplePrompts() : messageArea()),
            Visibility(
              visible: isLoading,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                      bottom: 40,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.textFieldColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: const SpinKitThreeBounce(
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            buildInput(),
          ]),
    );
  }

  // =========================== Build Input ===========================
  Widget buildInput() {
    return Container(
      width: double.infinity,
      height: 70.h,
      color: AppColors.appBarColor,
      padding: const EdgeInsets.only(left: 10, right: 5, bottom: 10, top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextField(
                // textAlignVertical: TextAlignVertical.center,
                minLines: null,
                maxLines: null,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white,
                ),
                cursorColor: AppColors.primaryColor,
                //textCapitalization: TextCapitalization.sentences,
                controller: _chatController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide:
                        const BorderSide(color: AppColors.textFieldColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide:
                        const BorderSide(color: AppColors.textFieldColor),
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
                      setState(() {
                        speechAvailable = !speechAvailable;
                      });
                      if (speechAvailable) {
                        setState(() {
                          isRecording = !isRecording;
                        });
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
                      size: 25.h,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  //isDense: true,
                  hintText: isRecording ? "Listening..." : "Type a message",
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

  // =========================== Message Area ===========================
  Widget messageArea() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      controller: _controller,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: chatList.length,
      itemBuilder: (context, index) => _itemChat(
        chat: chatList[index].chat,
        message: chatList[index].msg,
      ),
    );
  }

  // =========================== Item Chat ===========================
  _itemChat({required int chat, required String message}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Row(
        mainAxisAlignment:
            chat == 0 ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (chat == 1)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.botTextBubble,
                child: Image.asset(
                  "assets/images/splash_logo.png",
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          Flexible(
            child: Container(
              // margin: const EdgeInsets.only(
              //   left: 20,
              //   right: 20,
              //   top: 20,
              // ),
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: chat == 0 ? Colors.blue : AppColors.botTextBubble,
                borderRadius: chat == 0
                    ? BorderRadius.circular(20)
                    : BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      chatWidget(message, chat),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================== Chat Widget ===========================
  Widget chatWidget(String text, int chat) {
    return SizedBox(
      width: chat == 1
          ? MediaQuery.of(context).size.width * 0.6
          : MediaQuery.of(context).size.width * 0.7,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        child: AnimatedTextKit(
          onFinished: () {
            log("animation finished");
            // if (_controller.hasClients) {
            //   _controller.animateTo(
            //     _controller.position.maxScrollExtent,
            //     duration: const Duration(seconds: 2),
            //     curve: Curves.fastOutSlowIn,
            //   );
            // }
          },
          animatedTexts: [
            TyperAnimatedText(
              text.replaceFirst('\n\n', ''),
              textStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
          repeatForever: false,
          totalRepeatCount: 1,
        ),
      ),
    );
  }

  // =========================== Example Prompts ===========================
  Widget examplePrompts() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Image.asset(
              "assets/images/splash_logo.png",
              height: 60.h,
              width: 80.w,
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.batch_prediction,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Predictions',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            InkWell(
              onTap: () {
                _chatController.text =
                    "I want you to write about zombie apocalypse";
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'I want you to write about zombie apocalypse',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
              // child: Text(
              //   '"Write 500 Words About Ai"',
              //   style: AppTextStyle.style16W600(Colors.grey),
              // ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.format_line_spacing,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Explain',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            InkWell(
              onTap: () {
                _chatController.text = "Explain Gravity";
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Explain Gravity',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.food_bank,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Get Recipe',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            InkWell(
              onTap: () {
                _chatController.text = "How to make Baklava?";
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.textFieldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'How to make Baklava?',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================== Send Message ===========================
  sendMessage() async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    int searchCount =
        prefs.getInt(DateTime.now().toString().split(" ")[0]) ?? 0;
    bool isPaid = PurchaseApi.isPaid; //prefs.getBool("isPaid") ?? false;
    log("isPaid: $isPaid");
    if (PurchaseApi.isPaid) {
      messagePrompt = _chatController.text.toString();
      setState(() {
        chatList.add(Chat(msg: messagePrompt, chat: 0));
        _chatController.clear();
      });
      if (!mounted) return;

      if (whichModel == 0) {
        submitGetChatsForm(
          context: context,
          prompt: messagePrompt,
          tokenValue: tokenValue,
        ).then((value) async {
          log("here");
          isLoading = false;
          chatList.addAll(value);
          chatToStore.clear();
          chatToStore.addAll(chatList);
          final dataToStore =
              jsonEncode(chatToStore.map((e) => e.toJson()).toList());
          print(dataToStore);
          final date = DateTime.now().toString().split(" ")[0];
          await prefs.setString("$count-${chatList[0].msg}_$date", dataToStore);
          List<String> list = prefs.getStringList("oldChats") ?? [];
          if (!list.contains("$count-${chatList[0].msg}_$date")) {
            list.add("$count-${chatList[0].msg}_$date");
            await prefs.setStringList("oldChats", list);
          }
          setState(() {});
        });
        //coins--;
        //await prefs.setInt("coins", coins);
        setState(() {});
      } else {
        submitGetChatsFormToGpt4(
          context: context,
          prompt: messagePrompt,
          tokenValue: tokenValue,
        ).then((value) async {
          log("here");
          isLoading = false;
          chatList.addAll(value);
          chatToStore.clear();
          chatToStore.addAll(chatList);
          final dataToStore =
              jsonEncode(chatToStore.map((e) => e.toJson()).toList());
          print(dataToStore);
          final date = DateTime.now().toString().split(" ")[0];
          await prefs.setString("$count-${chatList[0].msg}_$date", dataToStore);
          List<String> list = prefs.getStringList("oldChats") ?? [];
          if (!list.contains("$count-${chatList[0].msg}_$date")) {
            list.add("$count-${chatList[0].msg}_$date");
            await prefs.setStringList("oldChats", list);
          }
          setState(() {});
        });
        //coins--;
        //await prefs.setInt("coins", coins);
        setState(() {});
      }
    } else {
      if (searchCount <= 5) {
        messagePrompt = _chatController.text.toString();
        setState(() {
          chatList.add(Chat(msg: messagePrompt, chat: 0));
          _chatController.clear();
        });
        if (!mounted) return;
        submitGetChatsForm(
          context: context,
          prompt: messagePrompt,
          tokenValue: tokenValue,
        ).then((value) async {
          log("here");
          isLoading = false;
          chatList.addAll(value);
          chatToStore.clear();
          chatToStore.addAll(chatList);
          final dataToStore =
              jsonEncode(chatToStore.map((e) => e.toJson()).toList());
          print(dataToStore);
          final date = DateTime.now().toString().split(" ")[0];
          await prefs.setString("$count-${chatList[0].msg}_$date", dataToStore);
          List<String> list = prefs.getStringList("oldChats") ?? [];
          if (!list.contains("$count-${chatList[0].msg}_$date")) {
            list.add("$count-${chatList[0].msg}_$date");
            await prefs.setStringList("oldChats", list);
          }
          setState(() {});
          searchCount += 1;
          prefs.setInt(DateTime.now().toString().split(" ")[0], searchCount);
        });
      } else {
        limitReachedDialog();
        // Get.to(const BuyPremiumScreen());
      }
    }
  }
}
