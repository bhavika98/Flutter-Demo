import 'package:flutter/material.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/activity/basic_page.dart';
import 'package:flutter_demo/activity/common.dart';
import 'package:flutter_demo/activity/exit.dart';
import 'package:flutter_demo/activity/home.dart';
import 'package:flutter_demo/utils/multi_dialog.dart';
import 'package:flutter_demo/utils/network_check.dart';
import 'package:store_redirect/store_redirect.dart';

class Start extends BasePage {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends BaseState<Start> with BasicPage {
  void checkNetwork() {
    NetworkCheck networkCheck = new NetworkCheck();
    networkCheck.checkInternet(fetchPrefrence);
  }

  fetchPrefrence(bool isNetworkPresent) {
    if (!isNetworkPresent) {
      MultiDialog().showPopup(context);
    }
  }

  @override
  void initState() {
    super.initState();
    checkNetwork();
    loadAds();
    loadAdmobBanner();
    loadFbNative();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);

    return new WillPopScope(
        child: Container(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  'assets/drawable/bg.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: Color(0xff50000000),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50, left: 10, right: 10),
                    child: showFbNative(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  callAds();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            new BorderRadius.circular(100),
                                        border: Border.all(
                                            color: Colors.white, width: 3),
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xffA0000000),
                                        child: Image.asset(
                                          'assets/icon/btn_start.png',
                                          color: Colors.white,
                                          height: 22,
                                          width: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Start',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Varela Round',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  StoreRedirect.redirect();
                                },
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            new BorderRadius.circular(100),
                                        border: Border.all(
                                            color: Colors.white, width: 3),
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xffA0000000),
                                        child: Image.asset(
                                          'assets/icon/btn_rate.png',
                                          color: Colors.white,
                                          height: 22,
                                          width: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Rate Us',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Varela Round',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Common.share();
                                },
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            new BorderRadius.circular(100),
                                        border: Border.all(
                                            color: Colors.white, width: 3),
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xffA0000000),
                                        child: Image.asset(
                                          'assets/icon/btn_share.png',
                                          color: Colors.white,
                                          height: 22,
                                          width: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Share App',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Varela Round',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  showAdmobBanner(),
                ],
              )
            ],
          ),
        ),
        onWillPop: _onBackPressed);
  }

  Future<bool> _onBackPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Exit()),
    );
    return true;
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
