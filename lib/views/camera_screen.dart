// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';
import 'package:ask_geoffrey/views/pdf_summarize.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

List<CameraDescription>? camera;

class cameraScreen extends StatefulWidget {
  String chatId;
  cameraScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  State<cameraScreen> createState() => _cameraScreenState();
}

class _cameraScreenState extends State<cameraScreen> {
  CameraController? _cameraController;
  late Future<void> cameraValue;
  var _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  @override
  void initState() {
    if (camera.toString() != '[]') {
      _cameraController = CameraController(camera![0], ResolutionPreset.high);
      cameraValue = _cameraController!.initialize();
    }
    // TODO: implement initState
    super.initState();
  }

  bool flip = true;
  bool flash = false;
  XFile? photo;

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  bool isrecording = false;
  int zoom = 1;
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: camera.toString() == '[]'
          ? Center(
              child: Text(
                'Your Device didn\'t support any camera!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : SafeArea(
              child: Stack(
              children: [
                FutureBuilder(
                    future: cameraValue,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GestureDetector(
                          onTap: () async {
                            await _cameraController!
                                .setFocusMode(FocusMode.auto);
                          },
                          onLongPress: () async {
                            await _cameraController!
                                .setFocusMode(FocusMode.locked);
                          },
                          child: CameraPreview(_cameraController!));
                    }),
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {
                            if (!flip) {
                              // Showsnackbar(
                              //   context,
                              //   'Flash Not Supported in Front Camera!',
                              // );
                              flash = false;
                            } else {
                              if (flash) {
                                setState(() {
                                  flash = false;
                                });
                              } else {
                                setState(() {
                                  flash = true;
                                });
                              }
                            }
                            flash
                                ? _cameraController!
                                    .setFlashMode(FlashMode.torch)
                                : _cameraController!
                                    .setFlashMode(FlashMode.off);
                          },
                          icon: Icon(
                            flash ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              !flip
                                  ? Container(
                                      height: 27,
                                      width: 40,
                                      color: Colors.transparent,
                                    )
                                  : zoom == 10
                                      ? GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              zoom = 1;
                                              show = false;
                                            });
                                            await _cameraController!
                                                .setZoomLevel(zoom.toDouble());
                                          },
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.white30,
                                            child: Text(
                                              '10x',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      : zoom == 4
                                          ? GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  zoom = 10;
                                                });
                                                await _cameraController!
                                                    .setZoomLevel(
                                                        zoom.toDouble());
                                              },
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.white30,
                                                child: Text(
                                                  '4x',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          : zoom == 2
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    setState(() {
                                                      zoom = 4;
                                                    });
                                                    await _cameraController!
                                                        .setZoomLevel(
                                                            zoom.toDouble());
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor:
                                                        Colors.white30,
                                                    child: Text(
                                                      '2x',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () async {
                                                    setState(() {
                                                      zoom = 2;
                                                      show = true;
                                                    });
                                                    await _cameraController!
                                                        .setZoomLevel(
                                                            zoom.toDouble());
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor:
                                                        Colors.white30,
                                                    child: Text(
                                                      '${zoom}x',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                              !flip
                                  ? Container(
                                      height: 27,
                                      width: 40,
                                      color: Colors.transparent,
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        if (show) {
                                          setState(() {
                                            show = false;
                                          });
                                        } else {
                                          setState(() {
                                            show = true;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        show
                                            ? Icons.arrow_upward
                                            : Icons.arrow_downward,
                                        color: Colors.white,
                                      ))
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                if (!isrecording) {
                                  TakePhoto(context);
                                }
                              },
                              child: Icon(
                                Icons.panorama_fish_eye,
                                color: Colors.white,
                                size: 70,
                              )),
                          IconButton(
                              onPressed: () async {
                                setState(() {
                                  flip = !flip;
                                  flash = false;
                                });
                                int n = flip ? 0 : 1;
                                _cameraController = CameraController(
                                    camera![n], ResolutionPreset.high);
                                cameraValue = _cameraController!.initialize();
                              },
                              icon: Icon(
                                Icons.cameraswitch_sharp,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      show
                          ? Container(
                              width: 300,
                              child: Slider(
                                  max: 10,
                                  min: 1,
                                  value: zoom.toDouble(),
                                  onChanged: (v) async {
                                    await _cameraController!
                                        .setZoomLevel(zoom.toDouble());
                                    setState(() {
                                      zoom = v.toInt();
                                      log(v.roundToDouble().toString());
                                    });
                                  }))
                          : Text(
                              'Hold for Video,Tap for Photo',
                              style: TextStyle(color: Colors.grey),
                            )
                    ],
                  ),
                ),
              ],
            )),
    );
  }

  void TakePhoto(BuildContext context) async {
    photo = await _cameraController!.takePicture();
    final recognizedText = await _textRecognizer
        .processImage(InputImage.fromFilePath(photo!.path));
    // text = await ReadPdfText.getPDFtext(_file!.path!);

    log(recognizedText.text);
    Get.to(PdfSummarizeScreen(
      isImage: true,
      text: recognizedText.text,
    ));
    _cameraController!.setFlashMode(FlashMode.off);
  }
}
