import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/activity/basic_page.dart';
import 'package:flutter_demo/activity/home.dart';
import 'package:flutter_demo/model/data_model.dart';
import 'package:flutter_demo/model/user_data.dart';
import 'package:flutter_demo/utils/constants.dart';
import 'package:flutter_demo/utils/data_storage.dart';
import 'package:flutter_demo/utils/shared_preferences.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class Skype extends BasePage {
  UserData mUserData;

  Skype({required this.mUserData});

  @override
  _SkypeState createState() => _SkypeState();
}

class _SkypeState extends BaseState<Skype> with BasicPage {
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
      if (value == true) {
        // Explicitly check if value is true
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
          // Android only - API >= 28
          volume: 0.1,
          // Android only - API >= 28
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
          Random random = Random();
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
    startTimer();
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
    stopTimer();
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
    return Stack(
      children: [
        firstScreen ? screenOne() : screenTwo(),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            height: 60,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Image.asset(
                    'assets/call/ic_skype_arrow.png',
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        widget.mUserData.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                            fontFamily: 'Helvetica',
                            fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        firstScreen
                            ? 'Ringing...'
                            : '$hoursStr:$minutesStr:$secondsStr',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
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
          ),
        ),
      ],
    );
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
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [Color(0xff1988d8), Color(0xff81cac6)],
              ),
            ),
          ),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xfff1f1f3),
              child: Text(
                '${widget.mUserData.name[0]}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(flex: 1, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => endCall(),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: CircleAvatar(
                        backgroundColor: const Color(0xfff44336),
                        child: Image.asset(
                          'assets/call/ic_skype_end.png',
                          width: 52,
                          height: 52,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () => pickCall(),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: CircleAvatar(
                        backgroundColor: const Color(0xff4caf50),
                        child: Image.asset(
                          'assets/call/ic_skype_call.png',
                          width: 45,
                          height: 45,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () => pickCall(),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: CircleAvatar(
                        backgroundColor: const Color(0xff4caf50),
                        child: Image.asset(
                          'assets/call/ic_skype_video.png',
                          width: 45,
                          height: 45,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              )
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
            padding: const EdgeInsets.only(top: 15, right: 15),
            child: Container(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 110,
                height: 150,
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
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'assets/call/ic_skype_volume.png',
                            width: 38,
                            height: 38,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'assets/call/ic_skype_mic.png',
                            width: 38,
                            height: 38,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => endCall(),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircleAvatar(
                            backgroundColor: Color(0xfff44336),
                            child: Image.asset(
                              'assets/call/ic_skype_end.png',
                              width: 40,
                              height: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'assets/call/ic_skype_video.png',
                            width: 38,
                            height: 38,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundColor: const Color(0xff57000000),
                          child: Image.asset(
                            'assets/call/ic_skype_rotate.png',
                            width: 38,
                            height: 38,
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

  bool flag = true;
  Stream<int>? timerStream;
  StreamSubscription<int>? timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';

  startTimer() {
    timerStream = stopWatchStream();
    timerSubscription = timerStream!.listen((int newTick) {
      setState(() {
        hoursStr =
            ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
        minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
        secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
      });
    });
  }

  stopTimer() {
    timerSubscription?.cancel();
    timerSubscription = null;
    timerStream = null;
    setState(() {});
  }

  Stream<int> stopWatchStream() {
    late StreamController<int> streamController;
    Timer? timer;
    Duration timerInterval = const Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      timer?.cancel();
      timer = null;
      counter = 0;
      streamController.close();
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
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
