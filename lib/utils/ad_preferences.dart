import 'package:flutter_demo/model/ad_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdPreferences {
  static final String adPref = "AdPref";
  static final String adValue = "AdValue";
  static final String adCounter = "adCounter";
  static final int division1 = 4;
  static final int division2 = 2;
  static final int adGap1 = 5;
  static final int adLoading = 200;

  static final String status = "status";

  static final String adMobAppID = "adMobAppID";
  static final String adMobNative = "adMobNative";
  static final String adMobBanner = "adMobBanner";
  static final String adMobInter = "adMobInter";
  static final String adMobReward = "adMobReward";
  static final String fbNative = "fbNative";
  static final String fbBanner = "fbBanner";
  static final String fbInter = "fbInter";

  static final String isAdmobEnable = "isAdmobEnable";
  static final String isfbEnable = "isfbEnable";
  static final String priority = "priority";
  static final String priority1 = "priority1";
  static final String priority2 = "priority2";

  static final String adGap = "adGap";
  static final String epGap = "epGap";

  static final String moreApps = "moreApps";
  static final String qurekaLink = "qurekaLink";
  static final String privacy = "privacy";

  static Future<int> getAdCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getInt(adCounter) ?? 0;
    return value;
  }

  static Future<void> incrementAdCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getInt(adCounter) ?? 0;
    if (value >= 1000)
      value = 0;
    else
      value = value + 1;
    prefs.setInt(adCounter, value);
  }

  static Future<void> setTestAdPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(status, true);

    prefs.setString(adMobAppID, ''); //ca-app-pub-3940256099942544~3347511713
    prefs.setString(adMobNative, ''); //ca-app-pub-3940256099942544/2247696110
    prefs.setString(adMobBanner, ''); //ca-app-pub-3940256099942544/6300978111
    prefs.setString(adMobInter, ''); //ca-app-pub-3940256099942544/1033173712
    prefs.setString(adMobReward, ''); //ca-app-pub-3940256099942544/5224354917
    prefs.setString(
        fbNative, ''); //IMG_16_9_APP_INSTALL#2312433698835503_2964953543583512
    prefs.setString(
        fbBanner, ''); //IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047
    prefs.setString(
        fbInter, ''); //IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617

    prefs.setInt(isAdmobEnable, 1);
    prefs.setInt(isfbEnable, 1);
    prefs.setInt(priority, 0);
    prefs.setInt(priority1, 2);
    prefs.setInt(priority2, 1);

    prefs.setInt(adGap, 5);
    prefs.setInt(epGap, 10);

    prefs.setString(moreApps, '');
    prefs.setString(qurekaLink, '');
    prefs.setString(privacy, '');
  }

  static Future<void> setAdPref(AdModel adModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(status, adModel.data.status);

    prefs.setString(adMobAppID, adModel.data.adMobAppID);
    prefs.setString(adMobNative, adModel.data.adMobNative);
    prefs.setString(adMobBanner, adModel.data.adMobBanner);
    prefs.setString(adMobInter, adModel.data.adMobInter);
    prefs.setString(adMobReward, adModel.data.adMobReward);
    prefs.setString(fbNative, adModel.data.fbNative);
    prefs.setString(fbBanner, adModel.data.fbBanner);
    prefs.setString(fbInter, adModel.data.fbInter);

    prefs.setInt(isAdmobEnable, adModel.data.isAdmobEnable);
    prefs.setInt(isfbEnable, adModel.data.isfbEnable);
    prefs.setInt(priority, adModel.data.priority);
    prefs.setInt(priority1, adModel.data.priority1);
    prefs.setInt(priority2, adModel.data.priority2);

    prefs.setInt(adGap, adModel.data.adGap);
    prefs.setInt(epGap, adModel.data.epGap);

    prefs.setString(moreApps, adModel.data.moreApps);
    prefs.setString(qurekaLink, adModel.data.qurekaLink);
    prefs.setString(privacy, adModel.data.privacy);
  }

  static Future<String> getAdPrefString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(key) ?? value;
    return data;
  }

  static Future<int> getAdPrefInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getInt(key) ?? value;
    return data;
  }

  static Future<void> clearAdPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(adValue);
  }
}
