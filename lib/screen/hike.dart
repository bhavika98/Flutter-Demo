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
class Hike extends BasePage {
  UserData mUserData;

  Hike({required this.mUserData});

  @override
  _HikeState createState() => _HikeState();
}

class _HikeState extends BaseState<Hike> with BasicPage {
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
      _video = File(widget.mUserData.video);
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
                padding: const EdgeInsets.only(top: 45),
                child: CircleAvatar(
                  radius: 55,
                  child: Stack(
                    children: <Widget>[
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/icon/avatar.png'),
                        radius: 55,
                      ),
                      widget.mUserData.type == 0
                          ? CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: widget.mUserData.image
                                      .contains('${AppUtil.profileImg}/bts_')
                                  ? FileImage(
                                      File(widget.mUserData.image))
                                  : AssetImage(
                                      'assets/image/${widget.mUserData.image}.jpg'),
                              radius: 55,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 55,
                              child: ClipOval(
                                // fit: BoxFit.cover,
                                child: Image.file(
                                  File(widget.mUserData.image),
                                  fit: BoxFit.cover,
                                  height: 110,
                                  width: 110,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  widget.mUserData.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      fontFamily: 'Helvetica',
                      fontSize: 20),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Incoming Video Call',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/call/ic_hike_chat.png',
                  height: 55,
                  width: 55,
                ),
              ),
              const SizedBox(
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => endCall(),
                      child: Image.asset(
                        'assets/call/ic_hike_call_end.png',
                        color: const Color(0xffa81828),
                        height: 30,
                        width: 30,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => pickCall(),
                      child: Image.asset(
                        'assets/call/ic_hike_call.png',
                        color: const Color(0xff15c01e),
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 85, top: 45),
            child: Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/call/ic_hike_head.png',
                height: 40,
                width: 40,
              ),
            ),
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
            padding: const EdgeInsets.only(top: 20, right: 20),
            child: Container(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 110,
                height: 140,
                child: ClipRRect(
                  child: CameraPreview(controller),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(flex: 1, child: Container()),
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 55,
                        height: 55,
                        child: CircleAvatar(
                          backgroundColor: const Color(0xff57ffffff),
                          child: Image.asset(
                            'assets/call/ic_hike_mic.png',
                            width: 45,
                            height: 45,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: () => endCall(),
                        child: SizedBox(
                          width: 55,
                          height: 55,
                          child: CircleAvatar(
                            backgroundColor: const Color(0xfff44336),
                            child: Image.asset(
                              'assets/call/ic_hike_call_end.png',
                              width: 30,
                              height: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                        width: 55,
                        height: 55,
                        child: CircleAvatar(
                          backgroundColor: const Color(0xff57ffffff),
                          child: Image.asset(
                            'assets/call/ic_hike_video.png',
                            width: 45,
                            height: 45,
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
