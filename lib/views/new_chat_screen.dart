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
import 'package:ask_geoffrey/views/textToPdfPage.dart';
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

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({Key? key, this.prompt}) : super(key: key);
  final String? prompt;

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _chatController = TextEditingController();
  String messagePrompt = '';
  int whichModel = 0; // default 3.5
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
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: Colors.grey,
        backgroundColor: AppColors.textFieldColor,
        title: Text("Chat Bot", style: AppTextStyle.textStyle4,),
        actions: [
          InkWell(
            onTap: () {
              int modeSelect = whichModel;
              showModalBottomSheet(context: context, backgroundColor: Colors.transparent, barrierColor: Colors.black12 ,constraints: const BoxConstraints(maxHeight: 300), builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: StatefulBuilder(
                    builder: (context, setState1) {
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: const BoxDecoration(
                              color: AppColors.textFieldColor,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Column(
                              children: [
                                const SizedBox(height: 10,),
                                Text("Select Model", style: TextStyle(fontSize: 14, color: Colors.grey[200]),),
                                const SizedBox(height: 15,),
                                Container(width: double.infinity, height: 1, color: AppColors.backgroundColor,),
                                const SizedBox(height: 15,),
                                InkWell(
                                  onTap: () {
                                    setState1((){
                                      modeSelect = 0;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset("assets/images/gpt3.png", height: 50, width: 50,),
                                          const SizedBox(width: 10,),
                                          Text("GPT-3.5-Turbo", style: TextStyle(fontSize: 14, color: Colors.grey[200]),),
                                        ],
                                      ),
                                      if(modeSelect == 0)
                                      const Icon(Icons.check, color: AppColors.primaryColor, size: 35,)
                                    ],
                                  ),
                                ),
                                const Divider(),
                                InkWell(
                                  onTap: () {
                                    bool isPaid = PurchaseApi.isPaid;
                                    if(!isPaid){
                                      limitReachedDialog();
                                    } else{
                                      setState1((){
                                        modeSelect = 1;
                                      });
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset("assets/images/gpt4.png", height: 50, width: 50,),
                                          const SizedBox(width: 10,),
                                          Text("GPT-4", style: TextStyle(fontSize: 14, color: Colors.grey[200]),),
                                          const SizedBox(width: 10,),
                                          if(!PurchaseApi.isPaid)
                                          Container(decoration:  BoxDecoration
                                            (
                                            color: const Color(0xffe3bb3f),
                                            borderRadius: BorderRadius.circular(4),

                                          ),child:  const Text("PRO", style: TextStyle(fontSize: 15),),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                          )
                                        ],
                                      ),
                                      if(modeSelect == 1)
                                      const Icon(Icons.check, color: AppColors.primaryColor, size: 35,)
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
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                              ),
                              child: Center(
                                child: Text("Select", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[200]),),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                );
              },);
            },
            child: Row(
              children: [
                Text(whichModel == 0 ? "GPT-3.5-Turbo"  : "GPT-4", style: const TextStyle(
                  fontSize: 12
                ),),
                const SizedBox(width: 10,),
                Image.asset("assets/images/menu.png", height: 20,),
                const SizedBox(width: 10,)
              ],
            ),
          ),
          const SizedBox(width: 10,),
        ],
      ),
      body: Container(
        //height: double.infinity,
        //width: double.infinity,
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
              _chatController.text = "Write 500 Words About Ai";
              sendMessage();
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.textFieldColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  'Write 500 Words About AI',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[200],
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
          InkWell(
            onTap: () {
              _chatController.text = "Write a blog on About Ai 500 Words";
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
                  'Write a blog on About Ai 500 Words',
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
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.textFieldColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                'Many Ask Many More',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[200],
                ),
              ),
            ),
          ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      size: 25.h,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  //isDense: true,
                  hintText: 'Write Your Message',
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
    if (PurchaseApi.isPaid) {
      messagePrompt = _chatController.text.toString();
      setState(() {
        chatList.add(Chat(msg: messagePrompt, chat: 0));
        _chatController.clear();
      });
      if (!mounted) return;

      if(whichModel == 0){
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
      } else{
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
                        backgroundColor: Colors.black,
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
                      InkWell(
                        onTap: () {
                          Get.to(TextToPdfPage(content: message,));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 2),
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.picture_as_pdf_outlined,
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
