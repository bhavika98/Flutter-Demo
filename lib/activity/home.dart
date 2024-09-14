import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_demo/activity/add_user.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/activity/basic_page.dart';
import 'package:flutter_demo/activity/call_theme.dart';
import 'package:flutter_demo/activity/ringtone.dart';
import 'package:flutter_demo/activity/set_call.dart';
import 'package:flutter_demo/utils/multi_dialog.dart';
import 'package:flutter_demo/utils/network_check.dart';
import 'package:flutter_demo/widgets/app_bar.dart';
import 'package:flutter_demo/model/user_data.dart';
import 'package:flutter_demo/widgets/drawer.dart';
import 'package:flutter_demo/widgets/main_list_view.dart';
import 'package:flutter_demo/utils/data_storage.dart';
import 'package:flutter_demo/utils/database_helper.dart';
import 'package:flutter_demo/utils/shared_preferences.dart';

class Home extends BasePage {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends BaseState<Home> with BasicPage {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<UserData> _userData = [];
  bool _vibration = false;

  @override
  void initState() {
    super.initState();
    checkNetwork();
    loadAds();
    loadFbBanner();
    loadAdmobBanner();
    fetchData();
    rateApp();
  }

  // Shows rate app dialog after a delay of 3 seconds
  void rateApp() {
    Future.delayed(Duration(seconds: 3), () {
      MultiDialog().rateOpen(context);
    });
  }

  // Fetch data from Shared Preferences or Database
  Future<void> fetchData() async {
    try {
      _userData = [];
      bool firstTime = await SharedPref.getBoolPref('firstTime');

      if (!firstTime) {
        // Fetch and insert default user data into the database if first time launch
        _userData.addAll(DataStorage.fetchDefault());
        for (var user in _userData) {
          await DatabaseHelper.instance.insert(user);
        }
        await SharedPref.setBoolPref('firstTime', true);
        await SharedPref.setSwitchState(true);
      }

      // Fetch user data from the database
      _userData = await DatabaseHelper.instance.queryAll();

      // Retrieve vibration preference
      _vibration = (await SharedPref.getSwitchState())!;
      setState(() {}); // Refresh UI
    } catch (error) {
      print('Error fetching data: $error');
      // Handle errors like displaying an error message to the user
    }
  }

  // Check for network connectivity
  void checkNetwork() {
    NetworkCheck networkCheck = NetworkCheck();
    networkCheck.checkInternet(fetchPrefrence);
  }

  // Callback for network presence
  fetchPrefrence(bool isNetworkPresent) {
    if (!isNetworkPresent) {
      MultiDialog().showPopup(context);
    }
  }

  // Dispose resources if necessary
  @override
  void dispose() {
    super.dispose();
  }

  // Callback function to get time
  void timeCallback(String callbackTime) {
    print(callbackTime);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: <Widget>[
            CustomAppBar(
              openDrawerCallback: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            showFbBanner(), // Facebook banner ad
            Expanded(
              child: MainListView(
                mUserData: _userData,
                listCallback: listCallback,
              ),
            ),
            showAdmobBanner(), // AdMob banner ad
          ],
        ),
        drawer: CustomDrawer(
          vibration: _vibration,
          drawerCallback: drawerCallback,
        ),
      ),
    );
  }

  // Callback for list item tap in MainListView
  void listCallback(UserData userData, BuildContext context) {
    callAds(); // Show ads before navigating
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetData(mUserData: userData),
      ),
    );
  }

  // Handle drawer item selections
  void drawerCallback(int index, BuildContext context) {
    callAds(); // Show ads before navigating

    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddUser()),
        );
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CallTheme()),
        );
        break;

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Ringtone()),
        );
        break;

      default:
        break;
    }
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
