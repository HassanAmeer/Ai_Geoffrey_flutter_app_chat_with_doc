import 'dart:convert';
import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ask_geoffrey/models/chat.dart';
import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:ask_geoffrey/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class PdfSummarizeScreen extends StatefulWidget {
  String text;
  bool isImage;
  PdfSummarizeScreen({super.key, required this.text, this.isImage = false});

  @override
  State<PdfSummarizeScreen> createState() => _PdfSummarizeScreenState();
}

class _PdfSummarizeScreenState extends State<PdfSummarizeScreen> {
  bool isLoading = false;
  List<Chat> chatList = [];
  var flutterTts = FlutterTts();
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatGPTAPI(widget.text,
        widget.isImage ? 'Summarize this text' : 'Summarize This Pdf');
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

  Future chatGPTAPI(String text, String text1) async {
    setState(() {
      isLoading = true;
    });
    try {
      // log(widget.path!.path);
      // if (image == false) {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $OPEN_API_KEY',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              'role': 'user',
              'content': '$text$text1',
            }
          ],
        }),
      );
// chatcmpl-7DudcYTN3mDIcG8DxitLPra9zazU5
      log(res.body.toString());
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        chatList.add(Chat(msg: content, chat: 1));
        // _speak(content);

        setState(() {
          isLoading = false;
        });
        return content;
      } else {
        chatList.add(Chat(msg: 'An internal error occurred', chat: 1));
        setState(() {
          isLoading = false;
        });
      }

      return 'An internal error occurred';
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textFieldColor,
        foregroundColor: Colors.white,
        title: Text(widget.isImage ? "Image Summarize" : "PDF Summarize"),
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

  Widget messagesArea() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: chatList.length,
      itemBuilder: (context, index) => _itemChat(
        chat: chatList[index].chat,
        message: chatList[index].msg,
      ),
    );
  }

  Widget _bodyColumn() {
    return Column(
      children: [
        Expanded(
          child: messagesArea(),
        ),
        Visibility(
          visible: isLoading,
          child: Container(
            //color: const Color.fromARGB(255, 11, 54, 92),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
        ),
      ],
    );
  }

  Future _stop() async {
    var result = await flutterTts.stop();
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
                color: chat == 0 ? Colors.white : Colors.black,
              ),
            ),
          ],
          repeatForever: false,
          totalRepeatCount: 1,
        ),
      ),
    );
  }
}
