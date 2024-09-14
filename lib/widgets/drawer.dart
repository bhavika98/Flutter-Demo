import 'package:flutter/material.dart';
import 'package:flutter_demo/activity/common.dart';
import 'package:flutter_demo/utils/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';

// ignore: must_be_immutable
class CustomDrawer extends StatefulWidget {
  var count = 0;
  bool vibration;

  final Function drawerCallback;

  CustomDrawer({required this.drawerCallback, required this.vibration})
      : super();

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 220,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/drawable/header.jpg"),
                          fit: BoxFit.cover)),
                  child: null,
                ),
              ),
              ListTile(
                title: Text(
                  'Add Fake Contact',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/icon/drawer_add_user.png',
                      color: Colors.black,
                      width: 18,
                      height: 18,
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.count = 1;
                  redirectMethod(context);
                },
              ),
              Divider(
                color: Colors.black12,
              ),
              ListTile(
                title: Text(
                  'Theme',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/icon/drawer_theme.png',
                      color: Colors.black,
                      width: 18,
                      height: 18,
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.count = 2;
                  redirectMethod(context);
                },
              ),
              Divider(
                color: Colors.black12,
              ),
              ListTile(
                title: Text(
                  'Ringtone',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/icon/drawer_ringtone.png',
                      color: Colors.black,
                      width: 18,
                      height: 18,
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.count = 3;
                  redirectMethod(context);
                },
              ),
              Divider(
                color: Colors.black12,
              ),
              SwitchListTile(
                  activeColor: Colors.purple,
                  inactiveTrackColor: Colors.grey.shade200,
                  title: Text(
                    'Vibration',
                    style: TextStyle(color: Colors.black),
                  ),
                  secondary: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/icon/drawer_vibration.png',
                        color: Colors.black,
                        width: 18,
                        height: 18,
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                  value: widget.vibration,
                  onChanged: (bool value) {
                    setState(() {
                      widget.vibration = value;
                      SharedPref.setSwitchState(value);
                    });
                  }),
              Divider(
                color: Colors.black12,
              ),
              ListTile(
                title: Text(
                  'Share App',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/icon/drawer_share.png',
                      color: Colors.black,
                      width: 17,
                      height: 17,
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.count = 5;
                  redirectMethod(context);
                },
              ),
              Divider(
                color: Colors.black12,
              ),
              ListTile(
                title: Text(
                  'Rate Us',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/icon/drawer_rate.png',
                      color: Colors.black,
                      width: 17,
                      height: 17,
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.count = 6;
                  redirectMethod(context);
                },
              ),
              Divider(
                color: Colors.black12,
              ),
              ListTile(
                title: Text(
                  'More Apps',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/icon/drawer_more.png',
                      color: Colors.black,
                      width: 17,
                      height: 17,
                      alignment: Alignment.centerLeft,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.count = 7;
                  redirectMethod(context);
                },
              ),
              Divider(
                color: Colors.black12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void redirectMethod(context) {
    switch (widget.count) {
      case 1: //add contact
      case 2: //theme
      case 3: //ringtone
        widget.drawerCallback(widget.count, context);
        break;

      case 5: //share app
        Common.share();
        break;

      case 6: //rate us
        StoreRedirect.redirect();
        break;

      case 7: //more apps
        Common.more();
        break;
    }
  }
}
