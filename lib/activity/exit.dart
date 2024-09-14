import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/activity/basic_page.dart';
import 'package:store_redirect/store_redirect.dart';

import 'dart:io' show Platform;

class Exit extends BasePage {
  @override
  _ExitState createState() => _ExitState();
}

class _ExitState extends BaseState<Exit> with BasicPage {
  String qurekaBanner = "";

  @override
  void initState() {
    super.initState();
    loadAdmobNative();
    getQurekaBanner();
  }

  Future<void> getQurekaBanner() async {
    qurekaBanner = await qurekaSettingBanner();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 60),
          Text(
            'Rate Your Experience'.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              letterSpacing: 2,
              fontFamily: 'Varela Round',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Tell us how was your experience'.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1,
              fontFamily: 'Varela Round',
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              StoreRedirect.redirect(); // Ensure StoreRedirect is properly implemented
            },
            child: Container(
              alignment: Alignment.center,
              width: 100,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 2),
                color: Colors.grey.shade200,
              ),
              child: Text(
                'Rate Us'.toUpperCase(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Varela Round',
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: showAdmobNative(), // Ensure this function returns a widget compatible with Expanded
          ),
          Text(
            'Are you sure to exit?'.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 2,
              fontFamily: 'Varela Round',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop(); // For Android exit
                  } else {
                    Navigator.of(context).pop(); // For iOS exit
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2),
                    color: Colors.grey.shade200,
                  ),
                  child: Text(
                    'Yes'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Varela Round',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 40),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  alignment: Alignment.center,
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2),
                    color: Colors.grey.shade200,
                  ),
                  child: Text(
                    'No'.toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Varela Round',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 80),
          GestureDetector(
            onTap: () => qureka(), // Ensure qureka() is properly implemented
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: qurekaBanner.isNotEmpty
                  ? Image.asset(
                'assets/qureka/$qurekaBanner.jpg',
                fit: BoxFit.cover,
              )
                  : Container(),
            ),
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

