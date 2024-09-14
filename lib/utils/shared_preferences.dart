import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static final String ringtone = 'ringtone';
  static final String theme = 'theme';
  static final String splashCounter = "splashCounter";
  static final String imgCount = "imgCount";
  static final String videoData = "videoData";
  static final String qBannerCount = "qBannerCount";
  static final String qGifCount = "qGifCount";

  static Future<bool> getBoolPref(var key) async {
    bool result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    result = prefs.containsKey(key);
    if (result == null) {
      return false;
    } else {
      return result;
    }
  }

  static Future setBoolPref(var key, var data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, data);
  }

  static Future<bool> setSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("switchState", value);
    return prefs.setBool("switchState", value);
  }

  static Future<bool?> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSwitchedFT = prefs.getBool("switchState");
    return isSwitchedFT;
  }

  static Future<String> getVideoData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(videoData) ?? "";
    return data;
  }

  static Future<void> setVideoData(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(videoData, value);
  }

  static Future<int> getIntFromLocalMemory(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getInt(key) ?? value;
    return data;
  }

  static Future<void> saveIntInLocalMemory(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static Future<int> getSplashCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getInt(splashCounter) ?? 0;
    return data;
  }

  static Future<void> incrementSplashCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getInt(splashCounter) ?? 0;
    if (data == 6)
      data = 0;
    else
      data = data + 1;
    prefs.setInt(splashCounter, data);
  }
}
