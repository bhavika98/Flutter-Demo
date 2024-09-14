import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/activity/basic_page.dart';
import 'package:flutter_demo/model/data_model.dart';
import 'package:vector_math/vector_math_64.dart' as vect;
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_demo/activity/home.dart';

import 'package:flutter_demo/model/user_data.dart';
import 'package:flutter_demo/utils/constants.dart';
import 'package:flutter_demo/utils/data_storage.dart';
import 'package:flutter_demo/utils/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

class Duo extends BasePage {
  final UserData mUserData;

  Duo({required this.mUserData});

  @override
  _DuoState createState() => _DuoState();
}

class _DuoState extends BaseState<Duo> with BasicPage, SingleTickerProviderStateMixin {
  late File _video;
  late String videoPath;
  late VideoPlayerController _videoPlayerController;
  late CameraController controller;
  late List<CameraDescription> cameras;
  late int selectedCameraIdx;
  bool firstScreen = true;
  late AudioPlayer advancedPlayer;
  late AudioCache audioCache;
  late AnimationController animationController;
  late Animation<double> animation;

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
        _initCameraController(cameras[selectedCameraIdx]);
      }
    }).catchError((err) {
      print('Error: $err');
    });
  }

  Future<void> _initCameraController(CameraDescription cameraDescription) async {
    // Dispose previous controller if it exists
    if (controller != null) {
      await controller.dispose();
    }
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
      if (mounted) {
        setState(() {});
      }
    } on CameraException catch (e) {
      print('Camera exception: ${e.toString()}');
    }
  }

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

  Future<void> setDefaultValue() async {
    await SharedPref.getSwitchState().then((value) {
      if (value == true) {
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
          looping: false,
          volume: 0.1,
          asAlarm: false,
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
          print('Error decoding video data: ${e.toString()}');
        }
        if (vidCount != 0) {
          Random random = Random();
          int randomNumber = random.nextInt(vidCount);
          videoPath = '${Constants.videoUrl}${widget.mUserData.id}/bts_${widget.mUserData.id}_${randomNumber + 1}.mp4';
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
      _video = File(widget.mUserData.video);
      _videoPlayerController = VideoPlayerController.file(_video)
        ..initialize().then((_) {
          setState(() {});
        });
    }
    _videoPlayerController.setLooping(true);
  }

  void endCall() {
    callAds();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false);
  }

  void pickCall() {
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
    return firstScreen ? screenOne() : screenTwo();
  }

  Widget _cameraPreviewWidget() {
    if (!controller.value.isInitialized) {
      return Container(
        color: Colors.black,
      );
    }

    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * controller.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(controller),
      ),
    );
  }

  Widget screenOne() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _cameraPreviewWidget(),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  'Incoming video call',
                  style: TextStyle(
                    color: Color(0xffd3d4cf),
                    fontSize: 15,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  widget.mUserData.name,
                  style: const TextStyle(
                      color: Color(0xfffffcff),
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      fontFamily: 'Helvetica',
                      fontSize: 20),
                ),
              ),
              Expanded(flex: 1, child: Container()),
              const Padding(
                padding: EdgeInsets.only(top: 25, bottom: 20),
                child: Text(
                  'Swipe up to answer',
                  style: TextStyle(
                    color: Color(0xfff5f5f5),
                    fontSize: 13,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      int sensitivity = 8;
                      if (details.delta.dy > sensitivity) {
                        endCall();
                      } else if (details.delta.dy < -sensitivity) {
                        pickCall();
                      }
                    },
                    child: Transform(
                      transform: Matrix4.translation(_shake()),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'assets/call/ic_duo_video.png',
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 45, bottom: 20),
                child: Text(
                  'Swipe down to decline',
                  style: TextStyle(
                    color: Color(0xfff5f5f5),
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

  Widget screenTwo() {
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
                child: VideoPlayer(_videoPlayerController),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50, left: 15),
            child: Container(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 100,
                height: 130,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CameraPreview(controller),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 200, left: 40),
            child: Container(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 50,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Color(0xff57ffffff),
                    child: Image.asset(
                      'assets/call/ic_duo_mic.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 270, left: 40),
            child: Container(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 50,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Color(0xff57ffffff),
                    child: Image.asset(
                      'assets/call/ic_duo_rotate.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(flex: 1, child: Container()),
              GestureDetector(
                onTap: () => endCall(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
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

