import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ask_geoffrey/models/chat.dart';
import 'package:ask_geoffrey/models/model.dart';
import 'package:ask_geoffrey/network/api_services.dart';
import 'package:ask_geoffrey/purchase_api.dart';
import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:ask_geoffrey/utils/app_images.dart';
import 'package:ask_geoffrey/utils/app_textstyle.dart';
import 'package:ask_geoffrey/views/buy_premium_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class WebScreen extends StatefulWidget {
  const WebScreen({Key? key, this.prompt}) : super(key: key);
  final String? prompt;

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _chatController = TextEditingController();
  String messagePrompt = '';
  int tokenValue = 500;
  List<Chat> chatList = [];
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
  bool isCurrentLanguageInstalled = false;
  int count = 0;
  bool isLoading = false;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _scrollController.addListener(_scrollListener);
    _chatController.text = widget.prompt ?? '';
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

  Future _speak(String newVoiceText) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (newVoiceText != '') {
      if (newVoiceText.isNotEmpty) {
        await flutterTts.speak(newVoiceText);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
  }

  void getModels() async {
    modelsList = await submitGetModelsForm(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.textFieldColor,
        title: const Text("Summarize Web"),
      ),
      body: Container(
        //height: double.infinity,
        //width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: _bodyColumn(),
      ),
    );
  }

  Widget _bodyColumn() {
    return Column(
      children: [
        Expanded(
          child: chatList.isEmpty ? examplePrompts() : messagesArea(),
        ),
        Visibility(
          visible: isLoading,
          child: Container(
            //color: const Color.fromARGB(255, 11, 54, 92),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
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
        ),
        buildInput(),
      ],
    );
  }

  Widget examplePrompts() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          SizedBox(
            height: 30.h,
          ),
          Image.asset(
            AppImages.hintIcon,
            color: AppColors.primaryColor,
            height: 80.h,
            width: 80.w,
          ),
          InkWell(
            onTap: () {
              _chatController.text = "http://google.com";
              sendMessage();
            },
            child:  Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.textFieldColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  'Summarize Web Page',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[200],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          // InkWell(
          //   onTap: () {
          //     _chatController.text = "Write a blog on About Ai 500 Words";
          //     sendMessage();
          //   },
          //   child: Text(
          //     '"Write a blog on About Ai 500 Words"',
          //     style: AppTextStyle.style16W600(AppColors.primaryColor),
          //   ),
          // ),
          // SizedBox(
          //   height: 10.h,
          // ),
          // Text(
          //   '"Many More Ask Now"',
          //   style: AppTextStyle.style16W600(AppColors.primaryColor),
          // ),
        ],
      ),
    );
  }

  Widget messagesArea() {
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

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      //    message = "reach the bottom";
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      //  message = "reach the top";
    }
  }

  Widget buildInput() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 5, bottom: 10, top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                // textAlignVertical: TextAlignVertical.center,
                cursorColor: AppColors.primaryColor,
                minLines: null,
                maxLines: null,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white,
                ),

                //textCapitalization: TextCapitalization.sentences,
                controller: _chatController,
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                      onTap: () async {
                        ClipboardData? cdata =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        String copiedtext = cdata!.text!;
                        // log(copiedtext);
                        _chatController.text = copiedtext;
                        setState(() {});
                      },
                      child: Icon(
                        Icons.paste_outlined,
                        color: AppColors.primaryColor,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                  //isDense: true,
                  hintText: 'Paste or type link',
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
      setState(() {
        chatList.add(Chat(msg: messagePrompt, chat: 0));
        _chatController.clear();
      });
      if (!mounted) return;
      submitGetChatsForm(
        context: context,
        prompt: '$messagePrompt Summarize this Web',
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
      if (searchCount < 3) {
        messagePrompt = _chatController.text.toString();
        setState(() {
          chatList.add(Chat(msg: messagePrompt, chat: 0));
          _chatController.clear();
        });
        if (!mounted) return;
        submitGetChatsForm(
          context: context,
          prompt: '$messagePrompt Summarize this Web',
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

  _itemChat({required int chat, required String message}) {
    return Row(
      mainAxisAlignment:
          chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: chat == 0
                  ? Colors.blue
                  : AppColors.botTextBubble,
              borderRadius: chat == 0
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
            ),
            child: Column(
              children: [
                if (chat != 0)
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.backgroundColor,
                        child: Image.asset(
                          "assets/images/splash_logo.png",
                          height: 30,
                          width: 30,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Ask-Geoffery",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          await Share.share(message);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 2),
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await _stop();
                          await _speak(message);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 2),
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.volume_up_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: message))
                              .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Response Copied"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 2),
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.copy,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (chat != 0)
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                    ),
                    child: Divider(height: 2, color: Colors.black),
                  ),
                chatWidget(message, chat),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget chatWidget(String text, int chat) {
    return SizedBox(
      width: 250.0,
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
              textStyle: TextStyle(
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
}
