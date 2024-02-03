import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:ask_geoffrey/utils/constants.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shazam_kit/flutter_shazam_kit.dart';
import 'package:url_launcher/url_launcher.dart';


class SongIdentification extends StatefulWidget {
  const SongIdentification({Key? key}) : super(key: key);

  @override
  State<SongIdentification> createState() => _SongIdentificationState();
}

class _SongIdentificationState extends State<SongIdentification> {
  final _flutterShazamKitPlugin = FlutterShazamKit();
  DetectState _state = DetectState.none;
  final List<MediaItem> _mediaItems = [];

  @override
  void initState() {
    super.initState();
    _flutterShazamKitPlugin
        .configureShazamKitSession(developerToken: developerToken)
        .then((value) {
      _flutterShazamKitPlugin.onMatchResultDiscovered((result) {
        if (result is Matched) {
          setState(() {
            _mediaItems.insertAll(0, result.mediaItems);
          });
        } else if (result is NoMatch) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No result found",style:
          TextStyle(
              color: Colors.black
          ),)));
        }
        _flutterShazamKitPlugin.endDetectionWithMicrophone();
      });
      _flutterShazamKitPlugin.onDetectStateChanged((state) {
        setState(() {
          _state = state;
        });
      });
      _flutterShazamKitPlugin.onError((error) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message,
        // ),backgroundColor: Colors.red,));
        print(error.message);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _flutterShazamKitPlugin.endSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back)),
            title: const Text('Sound Seeker'),
            foregroundColor: Colors.white,
            backgroundColor: AppColors.textFieldColor,
            automaticallyImplyLeading: true,
            elevation: 0,
          ),
          body: Container(
              decoration: const BoxDecoration(
               color: AppColors.backgroundColor,
              ),
              child: _body()));
  }

  Widget _body() {
    final theme = Theme.of(context);
    return Column(
      children: [_detectButton(theme), Expanded(child: _detectedItems(theme))],
    );
  }

  Widget _detectButton(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Text(_state==DetectState.none?"🎙️Tap to listen":"Listening...",style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),),
        AvatarGlow(
          endRadius: 200.0,
          animate: DetectState.detecting==_state,
          glowColor: Colors.green,
          child: GestureDetector(
            onTap: () async {
              if (_state == DetectState.detecting) {
                endDetect();
              } else {
                startDetect();
              }
            },
            child: const CircleAvatar(
              foregroundColor: AppColors.textFieldColor,
              backgroundColor: AppColors.textFieldColor,
              radius: 100,
              backgroundImage: AssetImage("assets/images/music.png",),
            ),
          )
        ),
      ],
    );
  }

  Widget _detectedItems(ThemeData theme) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
        itemCount: _mediaItems.length,
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          MediaItem item = _mediaItems[index];
          return GestureDetector(
            onTap: ()async{
              Uri url=Uri.parse(item.webUrl);
              if (!await launchUrl(url)) {
                throw Exception('Could not launch $url');
              }
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: const Color(0xFFF5f5f5),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Container(
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        item.artworkUrl,
                        height: 150.0,
                        width: 100.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(item.title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20
                              )),
                          Text("Artist: ${item.artist}",
                              style:  TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 16
                              )),
                          Text("Genres: ${item.genres.join(", ")}",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 16
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }));
  }

  startDetect() {
    _flutterShazamKitPlugin.startDetectionWithMicrophone();
  }

  endDetect() {
    _flutterShazamKitPlugin.endDetectionWithMicrophone();
  }
}