import 'dart:convert';

import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:ask_geoffrey/views/chatFromHostroty.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  List<String> oldChats = [];
  late SharedPreferences prefs;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    oldChats = prefs.getStringList("oldChats") ?? [];
    print("oldchats: $oldChats ");
    setState(() {});
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
        padding: const EdgeInsets.only(top: 8.0),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: oldChats.isEmpty
            ? const Center(
                child: Text(
                  "No Data",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: oldChats.length,
                itemBuilder: (context, index) {
                  print("this is: ${oldChats[index]}");
                  String oldChat = prefs.getString(oldChats[index]) ?? '';
                  final List<dynamic> jsonList = json.decode(oldChat);
                  print(jsonList[0]['msg']);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => ChatFromhistory(
                              jsonList: jsonList,
                            ));
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (ctx) =>
                        //         ShowHistoryFromChat(jsonList: jsonList),
                        //   ),
                        // );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.textFieldColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${jsonList[0]['msg']}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[200],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              oldChats[index].split("_")[1],
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[200],
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
