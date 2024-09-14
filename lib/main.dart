import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_demo/activity/splash.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initGoogleMobileAds();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

initGoogleMobileAds() {
  FacebookAudienceNetwork.init(
      // testingId: "f03e392f-fbe7-4f2f-b128-51a2e48eecfb",
      );
  MobileAds.initialize();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.purple);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.purple,
          primaryColor: Colors.purple,
          colorScheme: const ColorScheme.dark(
            primary: Colors.purple,
            secondary: Colors.purple,
          ),
          fontFamily: 'Varela Round',
          dialogBackgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white),
      home: Splash(),
    );
  }
}
