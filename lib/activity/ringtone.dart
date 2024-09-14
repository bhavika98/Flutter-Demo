import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/activity/basic_page.dart';
import 'package:flutter_demo/model/ring_data.dart';
import 'package:flutter_demo/utils/data_storage.dart';
import 'package:flutter_demo/utils/shared_preferences.dart';

class Ringtone extends BasePage {
  @override
  _RingtoneState createState() => _RingtoneState();
}

class _RingtoneState extends BaseState<Ringtone> with BasicPage {
  List<RingData> mRingdata = [];
  late int defaultRingtone;
  late AudioPlayer advancedPlayer;
  late AudioCache audioCache;
  bool isDefault = false;

  int _kAdIndex = 7;
  int totalAd = 0;
  int indexCounter = 0;

  @override
  void initState() {
    super.initState();
    loadFbBanner();
    loadAdmobBanner();
    loadFbNativeSmall();
    advancedPlayer = AudioPlayer();
    audioCache = AudioCache(prefix: 'assets/ringtone/');

    SharedPref.getIntFromLocalMemory(SharedPref.ringtone, 1).then((value) {
      defaultRingtone = value;
      mRingdata = DataStorage.fetchRing();
      setState(() {});
    });
  }

  @override
  String screenName() {
    return 'Set Ringtone';
  }

  @override
  void dispose() {
    advancedPlayer.stop();
    FlutterRingtonePlayer.stop();
    advancedPlayer.dispose(); // Dispose the player to free up resources
    super.dispose();
  }

  @override
  Widget body() {
    indexCounter = 0;
    return Column(
      children: <Widget>[
        Expanded(
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemCount: mRingdata.length + (mRingdata.length ~/ _kAdIndex).round(),
            itemBuilder: (BuildContext context, int index) {
              if ((index + 1) % _kAdIndex == 0) {
                indexCounter++;
                return Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: showFbNativeSmall(),
                );
              } else {
                index = index - indexCounter;
                return Column(
                  children: [
                    Container(
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            defaultRingtone = mRingdata[index].id;
                          });
                          SharedPref.saveIntInLocalMemory(
                              SharedPref.ringtone, defaultRingtone);
                        },
                        child: ListTile(
                          title: Text(
                            mRingdata[index].name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14),
                          ),
                          subtitle: Text(
                            mRingdata[index].duration,
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                          ),
                          trailing: defaultRingtone == mRingdata[index].id
                              ? Image.asset(
                            'assets/icon/btn_check.png',
                            height: 20,
                            width: 20,
                          )
                              : null,
                          leading: GestureDetector(
                            onTap: () async {
                              if (mRingdata[index].id == 1) {
                                advancedPlayer.stop();
                                if (isDefault) {
                                  FlutterRingtonePlayer.stop();
                                  isDefault = false;
                                } else {
                                  FlutterRingtonePlayer.playRingtone(
                                    looping: false, // Android only - API >= 28
                                    volume: 0.1, // Android only - API >= 28
                                  );
                                  isDefault = true;
                                }
                              } else {
                                advancedPlayer.stop();
                                if (isDefault) {
                                  FlutterRingtonePlayer.stop();
                                  isDefault = false;
                                }
                                if (mRingdata[index].interrupted) {
                                  advancedPlayer.pause();
                                } else {
                                  await audioCache.play('${mRingdata[index].path}.mp3');
                                }
                              }

                              for (var i = 0; i < mRingdata.length; i++) {
                                mRingdata[i].interrupted = false;
                              }
                              mRingdata[index].interrupted = true;
                              setState(() {});
                            },
                            child: Container(
                              height: double.infinity,
                              alignment: Alignment.center,
                              width: 50,
                              child: mRingdata[index].interrupted
                                  ? Image.asset(
                                'assets/icon/music_player_pause.png',
                                width: 20,
                                alignment: Alignment.center,
                                height: 20,
                              )
                                  : Image.asset(
                                'assets/icon/music_player_play.png',
                                width: 20,
                                alignment: Alignment.center,
                                height: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(color: Colors.black12),
                  ],
                );
              }
            },
            staggeredTileBuilder: (int index) {
              return StaggeredTile.fit(1);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Click on \'▶\' button to play audio.',
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.normal,
                fontSize: 14),
          ),
        ),
      ],
    );
  }
}