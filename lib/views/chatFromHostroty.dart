import 'dart:io';

import 'package:ask_geoffrey/models/chat.dart';
import 'package:ask_geoffrey/models/model.dart';
import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatFromhistory extends StatefulWidget {
  const ChatFromhistory({super.key, required this.jsonList});
  final List<dynamic> jsonList;

  @override
  State<ChatFromhistory> createState() => _ChatFromhistoryState();
}

class _ChatFromhistoryState extends State<ChatFromhistory> {
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
    super.initState();
    initTts();
    loadData();
  }

  loadData() {
    print(widget.jsonList);
    chatList = widget.jsonList.map((json) => Chat.fromJson(json)).toList();
    print(chatList);
    setState(() {});
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
    await flutterTts.stop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.textFieldColor,
        title: const Text("History"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: _bodyColumn(),
      ),
    );
  }

  Widget _bodyColumn() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        print(DateTime.now());
      },
      child: Column(
        children: [
          Expanded(
            child: messagesArea(),
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
        child: Text(
          text.replaceFirst('\n\n', ''),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
