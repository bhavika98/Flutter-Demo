import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/activity/basic_page.dart';
import 'package:flutter_demo/activity/edit_user.dart';
import 'package:flutter_demo/activity/home.dart';
import 'package:flutter_demo/activity/set_profile.dart';
import 'package:flutter_demo/model/user_data.dart';
import 'package:flutter_demo/screen/duo.dart';
import 'package:flutter_demo/screen/facetime.dart';
import 'package:flutter_demo/screen/hike.dart';
import 'package:flutter_demo/screen/messenger.dart';
import 'package:flutter_demo/screen/skype.dart';
import 'package:flutter_demo/screen/snapchat.dart';
import 'package:flutter_demo/screen/whatsapp.dart';
import 'package:flutter_demo/utils/database_helper.dart';
import 'package:flutter_demo/utils/folder_util.dart';
import 'package:flutter_demo/utils/multi_dialog.dart';
import 'package:flutter_demo/utils/messages.dart';
import 'package:flutter_demo/utils/network_check.dart';
import 'package:flutter_demo/utils/shared_preferences.dart';

// ignore: must_be_immutable
class SetData extends BasePage {
  UserData mUserData;

  SetData({required this.mUserData});

  @override
  _SetDataState createState() => _SetDataState();
}

class _SetDataState extends BaseState<SetData> with BasicPage {
  int valueHolder = 2;
  int _counter = 0;
  late StreamController<int> _events;

  @override
  initState() {
    super.initState();
    loadAds();
    loadFbBanner();
    loadAdmobBanner();
    _events = new StreamController<int>();
  }

  late Timer _timer;
  void _startTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0)
        _counter--;
      else {
        _timer.cancel();
        _events.close();
        _events = new StreamController<int>();
        callStart();
      }
      _events.add(_counter);
    });
  }

  void alertD(BuildContext ctx) {
    _counter = valueHolder;
    _events.add(_counter);
    var alert = AlertDialog(
      title: const Text(
        'BTS will call you after...',
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              _counter = 0;
              _timer.cancel();
              _events.close();
              _events = new StreamController<int>();
            });
            Navigator.pop(context, 'Cancel');
          },
          child: const Text('Cancel'),
        ),
      ],
      content: StreamBuilder<int>(
          stream: _events.stream,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Container(
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${snapshot.data.toString()} Seconds',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'please don\'t close the app.',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            );
          }),
    );
    showDialog(
        context: ctx,
        // barrierColor: Color(0x01000000),
        barrierDismissible: false,
        builder: (BuildContext c) {
          return WillPopScope(child: alert, onWillPop: () async => false);
        });
  }

  callStart() {
    var classValue;

    SharedPref.getIntFromLocalMemory(SharedPref.theme, 1).then((value) {
      switch (value) {
        case 1:
          classValue = WhatsApp(
            mUserData: widget.mUserData,
          );
          break;

        case 2:
          classValue = Messenger(
            mUserData: widget.mUserData,
          );
          break;

        case 3:
          classValue = Skype(
            mUserData: widget.mUserData,
          );
          break;

        case 4:
          classValue = Hike(
            mUserData: widget.mUserData,
          );
          break;

        case 5:
          classValue = Duo(
            mUserData: widget.mUserData,
          );
          break;

        case 6:
          classValue = SnapChat(
            mUserData: widget.mUserData,
          );
          break;

        case 7:
          classValue = FaceTime(
            mUserData: widget.mUserData,
          );
          break;
      }
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => classValue),
          (Route<dynamic> route) => false);
    });
  }

  deleteUser() async {
    await DatabaseHelper.instance.delete(widget.mUserData.id ?? 0);
    Show.shortToast("Contact Removed Successfully.");
    callAds();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget body() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: CircleAvatar(
                        radius: 56,
                        backgroundColor: Color(widget.mUserData.color ?? 0xFFFFFFFF),
                        child: Stack(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/icon/avatar.png'),
                              radius: 53,
                            ),
                            widget.mUserData.type == 0
                                ? CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: widget.mUserData.image
                                            .contains(
                                                '${AppUtil.profileImg}/bts_')
                                        ? FileImage(new File(
                                            '${widget.mUserData.image}'))
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
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        widget.mUserData.name,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        widget.mUserData.contact,
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 65, bottom: 10),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Delay Time :',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                          trackHeight: 3,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 8)),
                      child: Slider(
                          activeColor: Colors.purple,
                          inactiveColor: Colors.black12,
                          value: valueHolder.toDouble(),
                          min: 1,
                          max: 60,
                          onChanged: (double newValue) {
                            setState(() {
                              valueHolder = newValue.round();
                            });
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 20, top: 10, bottom: 100),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'call after ',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14),
                            ),
                            Text(
                              '${valueHolder.round()}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text(
                              ' seconds...',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  callAds();
                                  widget.mUserData.type == 0
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Profile(
                                                  mUserData: widget.mUserData)),
                                        )
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditUser(
                                                  mUserData: widget.mUserData)),
                                        );
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  child: Image.asset(
                                    'assets/icon/ic_edit.png',
                                    color: Colors.black54,
                                    height: 18,
                                    width: 18,
                                  ),
                                  backgroundColor: Colors.grey.shade200,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Edit',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  netCheck();
                                },
                                child: CircleAvatar(
                                  radius: 50,
                                  child: Image.asset(
                                    'assets/icon/ic_call.png',
                                    color: Colors.white,
                                    height: 35,
                                    width: 35,
                                  ),
                                  backgroundColor: Colors.purple,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Start Video Call',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (widget.mUserData.type != 0) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text(
                                                'Deleting Contact',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              content: const Text(
                                                'Are you sure you want to remove this contact?',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'No'),
                                                  child: const Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    deleteUser();
                                                    Navigator.pop(
                                                        context, 'Yes');
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            ));
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  child: Image.asset(
                                    widget.mUserData.type == 0
                                        ? 'assets/icon/ic_not_delete.png'
                                        : 'assets/icon/ic_delete.png',
                                    color: Colors.black54,
                                    height: 18,
                                    width: 18,
                                  ),
                                  backgroundColor: Colors.grey.shade200,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  String screenName() {
    return 'Set Video Call';
  }

  void netCheck() async {
    NetworkCheck networkCheck = new NetworkCheck();
    await networkCheck.check().then((value) {
      if (value) {
        _startTimer();
        alertD(context);
      } else {
        MultiDialog().showPopup(context);
      }
    });
  }
}
