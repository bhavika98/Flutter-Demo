//
// Generated file. Do not edit.
//

// ignore_for_file: lines_longer_than_80_chars

// import 'package:audioplayers/audioplayers_web.dart';
import 'package:connectivity_for_web/connectivity_for_web.dart';
// import 'package:firebase_auth_web/firebase_auth_web.dart';
// import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
// import 'package:vibration_web/vibration_web.dart';
import 'package:video_player_web/video_player_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  // AudioplayersPlugin.registerWith(registrar);
  ConnectivityPlugin.registerWith(registrar);
  // FirebaseAuthWeb.registerWith(registrar);
  // FirebaseCoreWeb.registerWith(registrar);
  FluttertoastWebPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  // VibrationWebPlugin.registerWith(registrar);
  VideoPlayerPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
