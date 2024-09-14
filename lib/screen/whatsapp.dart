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
import 'package:vector_math/vector_math_64.dart' as vect;
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class WhatsApp extends BasePage {
  UserData mUserData;

  WhatsApp({required this.mUserData});

  @override
  _WhatsAppState createState() => _WhatsAppState();
}

class _WhatsAppState extends BaseState<WhatsApp>
    with BasicPage, SingleTickerProviderStateMixin {
  late File _video;
  late String videoPath;
  late VideoPlayerController _videoPlayerController;
  late CameraController controller;
  late List cameras;
  late int selectedCameraIdx;
  bool firstScreen = true;
  late AudioPlayer advancedPlayer;
  late AudioCache audioCache;

  late AnimationController animationController;
  late Animation<double> animation;

  void setAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addListener(() => setState(() {}));

    animation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(animationController);

    animationController.forward();
  }

  vect.Vector3 _shake() {
    double progress = animationController.value;
    double offset = sin(progress * pi * 10.0);
    return vect.Vector3(offset * 4, 0.0, 0.0);
  }

  @override
  void initState() {
    super.initState();
    loadAds();
    setDefaultValue();
    setAnimation();
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
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/call/ic_wa_locked.png',
                      width: 18,
                      height: 18,
                      color: Color(0xffd8d6d9),
                    ),
                    Text(
                      ' End-to-end encrypted',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xffd8d6d9),
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xffA072787C),
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/icon/avatar.png'),
                        radius: 53,
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
                              radius: 53,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                // fit: BoxFit.cover,
                                child: Image.file(
                                  File(widget.mUserData.image),
                                  fit: BoxFit.cover,
                                  height: 106,
                                  width: 106,
                                ),
                              ),
                              radius: 53,
                            )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  widget.mUserData.name,
                  style: TextStyle(
                      color: Color(0xfffffcff),
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      fontFamily: 'Helvetica',
                      fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'WhatsApp video call',
                  style: TextStyle(
                    color: Color(0xffacb7b1),
                    fontSize: 13,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Expanded(flex: 1, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => endCall(),
                    child: Image.asset(
                      'assets/call/ic_wa_decline.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      int sensitivity = 8;
                      if (details.delta.dy > sensitivity) {
                        endCall();
                      } else if (details.delta.dy < -sensitivity) {
                        pickCall();
                      }
                    },
                    onTap: () => pickCall(),
                    child: Transform(
                      transform: Matrix4.translation(_shake()),
                      child: Image.asset(
                        'assets/call/ic_wa_accept.png',
                        height: 60,
                        width: 60,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/call/ic_wa_msg.png',
                    height: 60,
                    width: 60,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 15),
                child: Text(
                  'Swipe up to accept',
                  style: TextStyle(
                    color: Color(0xffacb7b1),
                    fontSize: 13,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
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
                  'assets/call/ic_wa_minimize.png',
                  width: 40,
                  height: 40,
                ),
                Image.asset(
                  'assets/call/ic_wa_participant.png',
                  width: 40,
                  height: 40,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 80, right: 20),
            child: Container(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 90,
                height: 120,
                child: ClipRRect(
                  child: CameraPreview(controller),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/call/ic_wa_locked.png',
                      width: 18,
                      height: 18,
                      color: Color(0xffd8d6d9),
                    ),
                    Text(
                      ' End-to-end encrypted',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xffd8d6d9),
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none),
                    )
                  ],
                ),
              ),
              Expanded(flex: 1, child: Container()),
              GestureDetector(
                onTap: () => endCall(),
                child: Container(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundColor: Color(0xffE91C43),
                    child: Image.asset(
                      'assets/call/ic_wa_call_decline.png',
                      height: 35,
                      width: 35,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 45, bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      'assets/call/ic_wa_camera.png',
                      height: 32,
                      width: 32,
                    ),
                    Image.asset(
                      'assets/call/ic_wa_off.png',
                      height: 32,
                      width: 32,
                    ),
                    Image.asset(
                      'assets/call/ic_wa_mute.png',
                      height: 32,
                      width: 32,
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

  @override
  Widget body() {
    throw UnimplementedError();
  }

  @override
  String screenName() {
    throw UnimplementedError();
  }
}
