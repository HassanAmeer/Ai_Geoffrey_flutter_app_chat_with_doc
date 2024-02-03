import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../errors/exceptions.dart';
import '../models/chat.dart';
import '../models/images.dart';
import '../models/model.dart';
import '../utils/constants.dart';
import 'error_message.dart';
import 'network_client.dart';

Future<List<Images>> submitGetImagesForm({
  required BuildContext context,
  required String prompt,
  required int n,
}) async {
  //
  NetworkClient networkClient = NetworkClient();
  List<Images> imagesList = [];
  try {
    final res = await networkClient.post(
      '${BASE_URL}images/generations',
      {"prompt": prompt, "n": 1, "size": "1024x1024", "model": "dall-e-3"},
      token: OPEN_API_KEY,
    );
    Map<String, dynamic> mp = jsonDecode(res.toString());
    debugPrint(mp.toString());
    if (mp['data'].length > 0) {
      imagesList = List.generate(mp['data'].length, (i) {
        return Images.fromJson(<String, dynamic>{
          'url': mp['data'][i]['url'],
        });
      });
      debugPrint(imagesList.toString());
    }
  } on RemoteException catch (e) {
    Logger().e(e.dioError);
    errorMessage(context);
  }
  return imagesList;
}


// get response from gpt 3.5 turbo
Future<List<Chat>> submitGetChatsForm({
  required BuildContext context,
  required String prompt,
  required int tokenValue,
  String? model,
}) async {
  log("======= GPT 3");
  NetworkClient networkClient = NetworkClient();
  List<Chat> chatList = [];
  try {
    final res = await networkClient.post(
      "${BASE_URL}/chat/completions",
      {
        "model": "gpt-3.5-turbo",

        "messages" : [
          {
            "role" : "user",
            "content" : prompt
          }
        ],
        "max_tokens": tokenValue
      },
      token: OPEN_API_KEY,
    );

    log(res.toString());
    Map<String, dynamic> mp = jsonDecode(res.toString());
    debugPrint(mp.toString());
    if (mp['choices'].length > 0) {
      chatList = List.generate(mp['choices'].length, (i) {
        return Chat.fromJson(<String, dynamic>{
          'msg': mp['choices'][i]['message']['content'],
          'chat': 1,
        });
      });
      debugPrint(chatList.toString());
    }
  } on RemoteException catch (e) {
    Logger().e(e.dioError);
    errorMessage(context);
  }
  return chatList;
}

// get response from gpt 4
Future<List<Chat>> submitGetChatsFormToGpt4({
  required BuildContext context,
  required String prompt,
  required int tokenValue,
  String? model,
}) async {
  //

  log("======= GPT 4");
  NetworkClient networkClient = NetworkClient();
  List<Chat> chatList = [];
  try {
    final res = await networkClient.post(
      "${BASE_URL}/chat/completions",
      {
        "model": "gpt-4",

        "messages" : [
          {
            "role" : "user",
            "content" : prompt
          }
        ],
        "max_tokens": tokenValue
      },
      token: OPEN_API_KEY,
    );

    log(res.toString());
    Map<String, dynamic> mp = jsonDecode(res.toString());
    debugPrint(mp.toString());
    if (mp['choices'].length > 0) {
      chatList = List.generate(mp['choices'].length, (i) {
        return Chat.fromJson(<String, dynamic>{
          'msg': mp['choices'][i]['message']['content'],
          'chat': 1,
        });
      });
      debugPrint(chatList.toString());
    }
  } on RemoteException catch (e) {
    Logger().e(e.dioError);
    errorMessage(context);
  }
  return chatList;
}


Future<List<Model>> submitGetModelsForm({
  required BuildContext context,
}) async {
  //
  NetworkClient networkClient = NetworkClient();
  List<Model> modelsList = [];
  try {
    final res = await networkClient.get(
      "${BASE_URL}models",
      token: OPEN_API_KEY,
    );
    Map<String, dynamic> mp = jsonDecode(res.toString());
    debugPrint(mp.toString());
    if (mp['data'].length > 0) {
      modelsList = List.generate(mp['data'].length, (i) {
        return Model.fromJson(<String, dynamic>{
          'id': mp['data'][i]['id'],
          'created': mp['data'][i]['created'],
          'root': mp['data'][i]['root'],
        });
      });
      debugPrint(modelsList.toString());
    }
  } on RemoteException catch (e) {
    Logger().e(e.dioError);
    errorMessage(context);
  }
  return modelsList;
}
