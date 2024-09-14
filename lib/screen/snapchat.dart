import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/activity/basic_page.dart';
import 'package:flutter_demo/activity/home.dart';
import 'package:flutter_demo/model/data_model.dart';
import 'package:flutter_demo/model/user_data.dart';
import 'package:flutter_demo/utils/constants.dart';
import 'package:flutter_demo/utils/data_storage.dart';
import 'package:flutter_demo/utils/folder_util.dart';
import 'package:flutter_demo/utils/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class SnapChat extends BasePage {
  UserData mUserData;

  SnapChat({required this.mUserData});

  @override
  _SnapChatState createState() => _SnapChatState();
}

class _SnapChatState extends BaseState<SnapChat> with BasicPage {
  late File _video;
  late String videoPath;
  late VideoPlayerController _videoPlayerController;
  late CameraController controller;
  late List cameras;
  late int selectedCameraIdx;
  bool firstScreen = true;
  late AudioPlayer advancedPlayer;
  late AudioCache audioCache;

  @override
  void initState() {
    super.initState();
    loadAds();
    setDefaultValue();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.isNotEmpty) {
        setState(() {
          selectedCameraIdx = 1;
        });
        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    await controller.dispose();
    controller = CameraController(cameraDescription, ResolutionPreset.high);
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      e.toString();
    }
    if (mounted) {
      setState(() {});
    }
  }

  setDefaultValue() async {
    // await [
    //   Permission.camera,
    // ].request();

    await SharedPref.getSwitchState().then((value) {
  if (value == true) { // Explicitly check if value is true
    Vibration.vibrate(
      pattern: [1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000],
      repeat: 0,
    );
  }
});

    advancedPlayer = AudioPlayer();
    audioCache = AudioCache();
    SharedPref.getIntFromLocalMemory(SharedPref.ringtone, 1).then((value) {
      if (value == 1) {
        FlutterRingtonePlayer.play(
          android: AndroidSounds.ringtone,
          ios: IosSounds.glass,
          looping: false, // Android only - API >= 28
          volume: 0.1, // Android only - API >= 28
          asAlarm: false, // Android only - all APIs
        );
      } else {
        String path = DataStorage.fetchRing()[value].path;
        audioCache.play('ringtone/$path.mp3');
      }
    });

    if (widget.mUserData.type == 0) {
      await SharedPref.getVideoData().then((value) {
        int vidCount = 0;
        try {
          List<Video> mVideo = Video.decode(value);
          vidCount = mVideo[widget.mUserData.id ?? 0 - 1].count;
        } catch (e) {
          e.toString();
        }
        if (vidCount != 0) {
          Random random = new Random();
          int randomNumber =
              random.nextInt(vidCount); // from 0 upto 99 included
          videoPath =
              '${Constants.videoUrl}${widget.mUserData.id}/bts_${widget.mUserData.id}_${randomNumber + 1}.mp4';
          _videoPlayerController = VideoPlayerController.network(videoPath)
            ..initialize().then((_) {
              setState(() {});
            });
        } else {
          videoPath = 'assets/video/bts_${widget.mUserData.id}.mp4';
          _videoPlayerController = VideoPlayerController.asset(videoPath)
            ..initialize().then((_) {
              setState(() {});
            });
        }
      });
    } else {
      _video = new File(widget.mUserData.video);
      _videoPlayerController = VideoPlayerController.file(_video)
        ..initialize().then((_) {
          setState(() {});
        });
    }
    _videoPlayerController.setLooping(true);
  }

  endCall() {
    callAds();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false);
  }

  pickCall() {
    advancedPlayer.stop();
    FlutterRingtonePlayer.stop();
    Vibration.cancel();
    firstScreen = false;
    setState(() {
      _videoPlayerController.play();
    });
  }

  @override
  void dispose() {
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
    _videoPlayerController.pause();
    _videoPlayerController.dispose();
    controller.dispose();
    advancedPlayer.stop();
    FlutterRingtonePlayer.stop();
    Vibration.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    return firstScreen ? screenOne() : screenTwo();
  }

  Widget _cameraPreviewWidget() {
    if (!controller.value.isInitialized) {
      return Container(
        color: Colors.black,
      );
    }

    var camera = controller.value;
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(controller),
      ),
    );
  }

  screenOne() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _cameraPreviewWidget(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 55),
                child: Text(
                  widget.mUserData.name,
                  style: TextStyle(
                      color: Color(0xfffffcff),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontFamily: 'Helvetica',
                      fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Incoming Video Call',
                  style: TextStyle(
                    color: Color(0xfff5f5f5),
                    fontSize: 12,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xffA072787C),
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/icon/avatar.png'),
                        radius: 50,
                      ),
                      widget.mUserData.type == 0
                          ? CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: widget.mUserData.image
                                      .contains('${AppUtil.profileImg}/bts_')
                                  ? FileImage(
                                      new File('${widget.mUserData.image}'))
                                  : AssetImage(
                                      'assets/image/${widget.mUserData.image}.jpg'),
                              radius: 50,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                // fit: BoxFit.cover,
                                child: Image.file(
                                  File(widget.mUserData.image),
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                              radius: 50,
                            )
                    ],
                  ),
                ),
              ),
              Expanded(flex: 1, child: Container()),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 60, top: 10, right: 50, left: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => endCall(),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 35,
                            child: Image.asset(
                              'assets/call/ic_snapchat_decline.png',
                              height: 70,
                              width: 70,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Dismiss',
                          style: TextStyle(
                              color: Color(0xfff5f5f5),
                              fontSize: 15,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => pickCall(),
                          child: Image.asset(
                            'assets/call/ic_snapchat_accept.png',
                            height: 70,
                            width: 70,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Join',
                          style: TextStyle(
                              color: Color(0xfff5f5f5),
                              fontSize: 15,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  screenTwo() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoPlayerController.value.size.width,
                height: _videoPlayerController.value.size.height,
                child: new VideoPlayer(_videoPlayerController),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/call/ic_snapchat_arrow.png',
                  width: 20,
                  height: 20,
                ),
                GestureDetector(
                  onTap: () => endCall(),
                  child: Container(
                    width: 100,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/call/ic_hike_call_end.png',
                          color: Color(0xfff44336),
                          width: 22,
                          height: 22,
                        ),
                        Text(
                          '  End',
                          style: TextStyle(
                              color: Color(0xfff44336),
                              fontSize: 14,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Expanded(flex: 1, child: Container()),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundColor: Color(0xff57ffffff),
                          child: Image.asset(
                            'assets/call/ic_snapchat_chat.png',
                            width: 35,
                            height: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundColor: Color(0xff57ffffff),
                          child: Image.asset(
                            'assets/call/ic_wa_mute.png',
                            width: 26,
                            height: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: 90,
                          height: 90,
                          child: ClipOval(
                            child: CameraPreview(controller),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundColor: Color(0xff57ffffff),
                          child: Image.asset(
                            'assets/call/ic_wa_off.png',
                            width: 26,
                            height: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundColor: Color(0xff57ffffff),
                          child: Image.asset(
                            'assets/call/ic_snapchat_flip.png',
                            width: 26,
                            height: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget body() {
    throw UnimplementedError();
  }

  @override
  String screenName() {
    throw UnimplementedError();
  }
}
