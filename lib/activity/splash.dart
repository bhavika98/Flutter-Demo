import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_demo/activity/start.dart';
import 'package:flutter_demo/model/ad_model.dart';
import 'package:flutter_demo/model/data_model.dart';
import 'package:flutter_demo/utils/ad_preferences.dart';
import 'package:flutter_demo/utils/constants.dart';
import 'package:flutter_demo/utils/multi_dialog.dart';
import 'package:flutter_demo/utils/network_check.dart';
import 'package:flutter_demo/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  int splashCounter = 0;
  var arr = ['s1', 's2', 's3', 's4', 's5', 's6', 's7'];
  var currentVersion;
  String msg = 'Loading... Please wait';

  String updatePackage = "", updateTitle = "", updateMsg = "";
  bool dataStatus = false, dataError = false;
  int versionCount = 0;

  void checkNetwork() {
    NetworkCheck networkCheck = new NetworkCheck();
    networkCheck.checkInternet(fetchPrefrence);
  }

  fetchPrefrence(bool isNetworkPresent) {
    if (!isNetworkPresent) {
      MultiDialog().showPopup(context);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Start()),
              (Route<dynamic> route) => false);
      // getJSON();
    }
  }

  @override
  void initState() {
    super.initState();
    checkNetwork();
    fetchImg();
  }

  void getJSON() async {
    await PackageInfo.fromPlatform().then((value) {
      currentVersion = value.buildNumber;
      fetchData();
    });
  }

  Future<void> fetchData() async {
    dataStatus = false;
    setState(() {});
    final response = await http.get(Uri.parse(Constants.updateUrl));
    if (response.statusCode == 200) {
      await AdPreferences.clearAdPref();
      AdModel mData = AdModel.fromJson(jsonDecode(response.body));
      if (int.parse(currentVersion) < mData.versionCode) {
        MultiDialog().showForceUpdateDialog(context, mData);
      } else {
        await AdPreferences.setAdPref(mData).then((value) => fetchOther());
        // await AdPreferences.setTestAdPref().then((value) => fetchOther());
      }
    } else {
      dataStatus = true;
      msg = 'Something went wrong, Please try again.';
      setState(() {});
    }
  }

  Future<void> fetchOther() async {
    dataError = false;
    setState(() {});
    final response = await http.get(Uri.parse(Constants.countUrl));
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      SharedPref.saveIntInLocalMemory(
          SharedPref.imgCount, int.parse(json['imgCount']));
      var tagJson = json['video'] as List;
      List<Video> mVideo =
          tagJson.map((tagJson) => Video.fromJson(tagJson)).toList();
      SharedPref.setVideoData(Video.encode(mVideo));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Start()),
          (Route<dynamic> route) => false);
    } else {
      dataError = true;
      msg = 'Something went wrong, Please try again.';
      setState(() {});
    }
  }

  void fetchImg() async {
    SharedPref.getSplashCounter().then((value) {
      splashCounter = value;
      SharedPref.incrementSplashCounter();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    return Container(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/drawable/${arr[splashCounter]}.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Color(0xff50000000),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              dataStatus || dataError
                  ? GestureDetector(
                      onTap: () {
                        msg = 'Loading... Please wait';
                        if (dataStatus)
                          fetchData();
                        else if (dataError) fetchOther();
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Container(
                          width: 120,
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: Text(
                            'Click here',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Varela Round',
                                decoration: TextDecoration.none),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    '$msg',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Varela Round',
                        decoration: TextDecoration.none),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
