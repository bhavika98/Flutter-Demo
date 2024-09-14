import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/model/ad_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';

class MultiDialog {
  showPopup(BuildContext context) {
    showDialog(
      context: context,
      // barrierColor: Color(0x01000000),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: const Text(
                'Network Error',
                style: TextStyle(color: Colors.black),
              ),
              content: const Text(
                'Internet is not available, reconnect network and try again.',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Ok');
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  showForceUpdateDialog(BuildContext context, AdModel mData) {
    showDialog(
      context: context,
      // barrierColor: Color(0x01000000),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text(
                '${mData.title}',
                style: TextStyle(color: Colors.black),
              ),
              content: Text(
                '${mData.msg}',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Exit');
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else if (Platform.isIOS) {
                      exit(0);
                    }
                  },
                  child: const Text('Exit'),
                ),
                TextButton(
                  onPressed: () {
                    StoreRedirect.redirect(iOSAppId: '${mData.package}');
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  late String _todaysDate;
  // String _yesterdayDate;
  final now = DateTime.now();

  rateOpen(BuildContext context) async {
    await getRateState().then((value) {
      switch (value) {
        case 0:
          setRateState(1);
          break;

        case 1:
          _setupDateDisplay().then((_todaysDate) {
            _checkDate(_todaysDate, context);
          });
          break;

        case 2:
          break;
      }
    });
  }

  Future<String> _setupDateDisplay() async {
    _todaysDate = DateFormat.yMMMMd("en_US").format(now);
    return _todaysDate;
  }

  _checkDate(String todaysDate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String yesterdayDate = prefs.getString('lastDate') ?? '';
    if (todaysDate != yesterdayDate) {
      showRateDialog(context);
      prefs.setString('lastDate', todaysDate);
    }
  }

  Future<void> setRateState(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("setRateUs", value);
  }

  Future<int> getRateState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("setRateUs") ?? 0;
  }

  showRateDialog(BuildContext context) {
    showDialog(
      context: context,
      // barrierColor: Color(0x01000000),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: const Text(
                'Enjoying this app?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1,
                  fontFamily: 'Varela Round',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/gif/rate.gif',
                    height: 125.0,
                    width: 125.0,
                  ),
                  const Text(
                    'If you like this app, We would greatly appreciate it if you could rate the App on the Play Store.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Varela Round',
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Thank You!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Varela Round',
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Varela Round',
                        fontWeight: FontWeight.normal),
                  ),
                  onPressed: () {
                    Navigator.pop(context, 'Later');
                  },
                  child: const Text('Later'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Varela Round',
                        fontWeight: FontWeight.normal),
                  ),
                  onPressed: () async {
                    StoreRedirect.redirect();
                    setRateState(2);
                    Navigator.pop(context, 'Rate Now');
                  },
                  child: const Text('Rate Now'),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
