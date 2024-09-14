import 'package:facebook_audience_network/facebook_audience_network.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/ad_preferences.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:flutter_demo/utils/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class BasePage extends StatefulWidget {
  const BasePage() : super();
}

abstract class BaseState<Page extends BasePage> extends State<Page> {
  String screenName();

// ----------------------------------------------- Admob Banner ----------------------------------------------- //
  final bannerController = BannerAdController();
  bool isadMobLoaded = false;
  late String adMobBanner;

  Future<void> loadAdmobBanner() async {
    int isAd1 =
        await AdPreferences.getAdPrefInt(AdPreferences.isAdmobEnable, 1);
    adMobBanner =
        await AdPreferences.getAdPrefString(AdPreferences.adMobBanner, "");
    if (isAd1 == 1 && adMobBanner != "") {
      isadMobLoaded = true;
      bannerController.onEvent.listen((e) {
        final event = e.keys.first;
        switch (event) {
          case BannerAdEvent.loaded:
            break;
          default:
            break;
        }
      });
      bannerController.load();
      setState(() {});
    }
  }

  showAdmobBanner() {
    return isadMobLoaded
        ? Padding(
            padding: const EdgeInsets.only(top: 5),
            child: BannerAd(
              controller: bannerController,
              unitId: adMobBanner,
            ),
          )
        : Container();
  }

// ----------------------------------------------- Fb Banner ----------------------------------------------- //
  bool isFbLoaded = false;
  late String fbBanner;

  Future<void> loadFbBanner() async {
    int isAd = await AdPreferences.getAdPrefInt(AdPreferences.isfbEnable, 1);
    fbBanner = await AdPreferences.getAdPrefString(AdPreferences.fbBanner, "");
    if (isAd == 1 && fbBanner != "") {
      setState(() {
        isFbLoaded = true;
      });
    }
  }

  showFbBanner() {
    return isFbLoaded
        ? Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: fb.FacebookBannerAd(
              bannerSize: fb.BannerSize.STANDARD,
              keepAlive: true,
              placementId: fbBanner,
              listener: (result, value) {
                print("Banner Ad: $result -->  $value");
              },
            ),
          )
        : Container();
  }

// ----------------------------------------------- Admob Native ----------------------------------------------- //
  bool isAdmobNativeLoaded = false;
  late String adMobNative;

  Future<void> loadAdmobNative() async {
    int isAd1 =
        await AdPreferences.getAdPrefInt(AdPreferences.isAdmobEnable, 1);
    adMobNative =
        await AdPreferences.getAdPrefString(AdPreferences.adMobNative, "");
    if (isAd1 == 1 && adMobNative != "") {
      setState(() {
        isAdmobNativeLoaded = true;
      });
    }
  }

  showAdmobNative() {
    return isAdmobNativeLoaded
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NativeAd(
                height: 300,
                unitId: adMobNative,
                builder: (context, child) {
                  // return Material(
                  //   child: child,
                  // );
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: child,
                    ),
                  );
                },
                buildLayout: fullBuilder,
                icon: AdImageView(size: 40),
                headline: AdTextView(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Varela Round',
                    color: Colors.black,
                  ),
                  maxLines: 1,
                ),
                media: AdMediaView(
                  height: 180,
                  width: MATCH_PARENT,
                ),
                attribution: AdTextView(
                  width: WRAP_CONTENT,
                  height: WRAP_CONTENT,
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  margin: EdgeInsets.only(right: 4),
                  maxLines: 1,
                  text: 'AD',
                  decoration: AdDecoration(
                    backgroundColor: Color(0xffFFCC66),
                    borderRadius: AdBorderRadius.all(10),
                  ),
                  style: TextStyle(
                    fontFamily: 'Varela Round',
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                button: AdButtonView(
                  decoration: AdDecoration(backgroundColor: Colors.purple),
                  height: MATCH_PARENT,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Varela Round',
                  ),
                ),
              ),
            ],
          )
        : Container();
  }

  AdLayoutBuilder get fullBuilder => (ratingBar, media, icon, headline,
          advertiser, body, price, store, attribuition, button) {
        return AdLinearLayout(
          padding: EdgeInsets.all(10),
          // The first linear layout width needs to be extended to the
          // parents height, otherwise the children won't fit good
          width: MATCH_PARENT,
          decoration: AdDecoration(
            backgroundColor: Color(0xffFAFBFB),
          ),
          children: [
            media,
            AdLinearLayout(
              children: [
                icon,
                AdLinearLayout(children: [
                  headline,
                  AdLinearLayout(
                    children: [attribuition, advertiser, ratingBar],
                    orientation: HORIZONTAL,
                    width: MATCH_PARENT,
                  ),
                ], margin: EdgeInsets.only(left: 4)),
              ],
              gravity: LayoutGravity.center_horizontal,
              width: WRAP_CONTENT,
              orientation: HORIZONTAL,
              margin: EdgeInsets.only(top: 6),
            ),
            AdLinearLayout(
              children: [button],
              orientation: HORIZONTAL,
            ),
          ],
        );
      };

// ----------------------------------------------- Admob Native Medium ----------------------------------------------- //
  bool isAdmobNativeMediumLoaded = false;

  Future<void> loadAdmobNativeMedium() async {
    int isAd1 =
        await AdPreferences.getAdPrefInt(AdPreferences.isAdmobEnable, 1);
    adMobNative =
        await AdPreferences.getAdPrefString(AdPreferences.adMobNative, "");
    if (isAd1 == 1 && adMobNative != "") {
      setState(() {
        isAdmobNativeMediumLoaded = true;
      });
    }
  }

  showAdmobNativeMedium() {
    return isAdmobNativeMediumLoaded
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NativeAd(
                height: 315,
                unitId: adMobNative,
                builder: (context, child) {
                  // return Material(
                  //   child: child,
                  // );
                  return Padding(
                    padding: const EdgeInsets.only(left: 1, right: 1),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: child,
                    ),
                  );
                },
                buildLayout: mediumBuilder,
                icon: AdImageView(size: 40),
                headline: AdTextView(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Varela Round',
                    color: Colors.black,
                  ),
                  maxLines: 1,
                ),
                media: AdMediaView(
                  height: 180,
                  width: MATCH_PARENT,
                ),
                attribution: AdTextView(
                  width: WRAP_CONTENT,
                  height: WRAP_CONTENT,
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  margin: EdgeInsets.only(right: 4),
                  maxLines: 1,
                  text: 'AD',
                  decoration: AdDecoration(
                    backgroundColor: Color(0xffFFCC66),
                    borderRadius: AdBorderRadius.all(10),
                  ),
                  style: TextStyle(
                    fontFamily: 'Varela Round',
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                button: AdButtonView(
                  decoration: AdDecoration(backgroundColor: Colors.purple),
                  height: MATCH_PARENT,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Varela Round',
                  ),
                ),
              ),
            ],
          )
        : Container();
  }

  AdLayoutBuilder get mediumBuilder => (ratingBar, media, icon, headline,
          advertiser, body, price, store, attribuition, button) {
        return AdLinearLayout(
          padding: EdgeInsets.all(5),
          // The first linear layout width needs to be extended to the
          // parents height, otherwise the children won't fit good
          width: MATCH_PARENT,
          decoration: AdDecoration(
            backgroundColor: Color(0xffFAFBFB),
          ),
          children: [
            AdLinearLayout(
              children: [attribuition],
              orientation: HORIZONTAL,
              margin: EdgeInsets.only(bottom: 5),
              width: MATCH_PARENT,
            ),
            AdLinearLayout(
              children: [
                icon,
                AdLinearLayout(
                  children: [
                    price,
                    ratingBar,
                  ],
                  margin: EdgeInsets.only(left: 5),
                ),
              ],
              gravity: LayoutGravity.center,
              width: MATCH_PARENT,
              orientation: HORIZONTAL,
              margin: EdgeInsets.only(top: 5, bottom: 5),
            ),
            store,
            headline,
            AdExpanded(
              child: media,
              flex: 1,
            ),
            AdLinearLayout(
              children: [button],
              orientation: HORIZONTAL,
            ),
          ],
        );
      };

// ----------------------------------------------- Admob Native Small ----------------------------------------------- //
  bool isAdmobNativeSmallLoaded = false;

  Future<void> loadAdmobNativeSmall() async {
    int isAd1 =
        await AdPreferences.getAdPrefInt(AdPreferences.isAdmobEnable, 1);
    adMobNative =
        await AdPreferences.getAdPrefString(AdPreferences.adMobNative, "");
    if (isAd1 == 1 && adMobNative != "") {
      setState(() {
        isAdmobNativeSmallLoaded = true;
      });
    }
  }

  showAdmobNativeSmall() {
    return isAdmobNativeSmallLoaded
        ? NativeAd(
            height: 100,
            builder: (context, child) {
              // return Material(
              //   elevation: 8,
              //   child: child,
              // );
              return Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: child,
              );
            },
            buildLayout: secondBuilder,
            icon: AdImageView(size: 92),
            headline: AdTextView(
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              maxLines: 1,
            ),
            media: AdMediaView(height: 80, width: 120),
            attribution: AdTextView(
              width: WRAP_CONTENT,
              height: WRAP_CONTENT,
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              margin: EdgeInsets.only(right: 4),
              maxLines: 1,
              text: 'AD',
              decoration: AdDecoration(
                backgroundColor: Color(0xffFFCC66),
                borderRadius: AdBorderRadius.all(10),
              ),
              style: TextStyle(
                fontFamily: 'Varela Round',
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            button: AdButtonView(
              decoration: AdDecoration(backgroundColor: Colors.purple),
              height: 40,
              textStyle: TextStyle(
                color: Colors.white,
                fontFamily: 'Varela Round',
              ),
            ),
          )
        : Container();
  }

  AdLayoutBuilder get secondBuilder => (ratingBar, media, icon, headline,
          advertiser, body, price, store, attribution, button) {
        return AdLinearLayout(
          padding: EdgeInsets.all(10),
          // The first linear layout width needs to be extended to the
          // parents height, otherwise the children won't fit good
          width: MATCH_PARENT,
          orientation: HORIZONTAL,
          decoration: AdDecoration(backgroundColor: Colors.white),
          children: [
            icon,
            AdLinearLayout(
              padding: EdgeInsets.only(left: 5),
              children: [
                headline,
                AdLinearLayout(
                  children: [attribution, advertiser, ratingBar],
                  orientation: HORIZONTAL,
                  width: WRAP_CONTENT,
                  height: 25,
                ),
                button,
              ],
              margin: EdgeInsets.symmetric(horizontal: 4),
            ),
          ],
        );
      };

// ----------------------------------------------- Fb Native ----------------------------------------------- //
  bool isFbNativeLoaded = false;
  late String fbNative;

  Future<void> loadFbNative() async {
    int isAd = await AdPreferences.getAdPrefInt(AdPreferences.isfbEnable, 1);
    fbNative = await AdPreferences.getAdPrefString(AdPreferences.fbNative, "");
    if (isAd == 1 && fbNative != "") {
      setState(() {
        isFbNativeLoaded = true;
      });
    }
  }

  showFbNative() {
    return isFbNativeLoaded
        ? Container(
            decoration: BoxDecoration(
              color: Color(0xffFAFBFB),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: fb.FacebookNativeAd(
              placementId: fbNative,
              adType: fb.NativeAdType.NATIVE_AD_VERTICAL,
              width: double.infinity,
              height: 300,
              backgroundColor: Color(0xffFAFBFB),
              titleColor: Colors.black,
              descriptionColor: Colors.black,
              buttonColor: Colors.purple,
              buttonTitleColor: Colors.white,
              buttonBorderColor: Colors.purple,
              listener: (result, value) {
                print("Native Ad: $result --> $value");
              },
              keepExpandedWhileLoading: true,
              expandAnimationDuraion: 1000,
            ),
          )
        : Container();
  }

  // ----------------------------------------------- Fb Native Small ----------------------------------------------- //
  bool isFbNativeSmallLoaded = false;

  Future<void> loadFbNativeSmall() async {
    int isAd = await AdPreferences.getAdPrefInt(AdPreferences.isfbEnable, 1);
    fbNative = await AdPreferences.getAdPrefString(AdPreferences.fbNative, "");
    if (isAd == 1 && fbNative != "") {
      setState(() {
        isFbNativeSmallLoaded = true;
      });
    }
  }

  showFbNativeSmall() {
    return isFbNativeSmallLoaded
        ? Container(
            decoration: BoxDecoration(
              color: Color(0xffFAFBFB),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: fb.FacebookNativeAd(
              placementId: fbNative,
              adType: fb.NativeAdType.NATIVE_AD_VERTICAL,
              width: double.infinity,
              height: 250,
              backgroundColor: Color(0xffFAFBFB),
              titleColor: Colors.black,
              descriptionColor: Colors.black,
              buttonColor: Colors.purple,
              buttonTitleColor: Colors.white,
              buttonBorderColor: Colors.purple,
              listener: (result, value) {
                print("Native Ad: $result --> $value");
              },
              keepExpandedWhileLoading: true,
              expandAnimationDuraion: 1000,
            ),
          )
        : Container();
  }

  // ----------------------------------------------- Admob Interstitial ----------------------------------------------- //
  final interstitialAdMob = InterstitialAd();

  initAdmobInterstitial() async {
    String placementId =
        await AdPreferences.getAdPrefString(AdPreferences.adMobInter, "");
    if (placementId != "") {
      if (!interstitialAdMob.isLoaded)
        interstitialAdMob.load(unitId: placementId);
      interstitialAdMob.onEvent.listen((e) {
        final event = e.keys.first;
        switch (event) {
          case FullScreenAdEvent.closed:
            interstitialAdMob.load();
            break;
          default:
            break;
        }
      });
    }
  }

  loadAdmobInterstitial() async {
    int isAd1 =
        await AdPreferences.getAdPrefInt(AdPreferences.isAdmobEnable, 1);
    if (isAd1 == 1) {
      initAdmobInterstitial();
    }
  }

  showAdmobInterstitial() {
    if (interstitialAdMob != null && interstitialAdMob.isAvailable) {
      interstitialAdMob.show();
    }
  }

  // ----------------------------------------------- Fb Interstitial ----------------------------------------------- //
  bool isFbInterstitialReady = false;

  initFbInterstitial() async {
    String placementId =
        await AdPreferences.getAdPrefString(AdPreferences.fbInter, "");
    if (placementId != "") {
      fb.FacebookInterstitialAd.loadInterstitialAd(
        placementId: placementId,
        listener: (result, value) {
          print(">> FAN > Interstitial Ad: $result --> $value");
          if (result == fb.InterstitialAdResult.LOADED)
            isFbInterstitialReady = true;
          if (result == fb.InterstitialAdResult.DISMISSED &&
              value["invalidated"] == true) {
            isFbInterstitialReady = false;
            initFbInterstitial();
          }
        },
      );
    }
  }

  loadFbInterstitial() async {
    int isAd = await AdPreferences.getAdPrefInt(AdPreferences.isfbEnable, 1);
    if (isAd == 1) {
      initFbInterstitial();
    }
  }

  showFBInterstitial() {
    if (isFbInterstitialReady == true)
      fb.FacebookInterstitialAd.showInterstitialAd();
    else
      print("Interstitial Ad not yet loaded!");
  }

  // ----------------------------------------------- Interstitial Ads ----------------------------------------------- //
  callAds() async {
    int getValue = 2;
    int adCounter = await AdPreferences.getAdCounter();
    if (adCounter == 0) adCounter = 2;
    int pValue = await AdPreferences.getAdPrefInt(AdPreferences.priority, 0);
    int prior_1 = await AdPreferences.getAdPrefInt(
        AdPreferences.priority1, AdPreferences.division1);
    int prior_2 = await AdPreferences.getAdPrefInt(
        AdPreferences.priority2, AdPreferences.division2);
    switch (pValue) {
      case 0: // admob first + fb second
        if (adCounter % prior_1 == 0)
          getValue = 0;
        else if (adCounter % prior_2 == 0) getValue = 1;
        break;

      case 1: // fb first + admob second
        if (adCounter % prior_1 == 0)
          getValue = 1;
        else if (adCounter % prior_2 == 0) getValue = 0;
        break;

      case 2: // only admob
        if (adCounter % prior_1 == 0) getValue = 0;
        break;

      case 3: // only fb
        if (adCounter % prior_1 == 0) getValue = 1;
        break;
    }
    AdPreferences.incrementAdCounter();
    // print("Dataaa $getValue");
    if (getValue == 0)
      showAdmobInterstitial();
    else if (getValue == 1) showFBInterstitial();
  }

  loadAds() {
    loadAdmobInterstitial();
    loadFbInterstitial();
  }

  Future<String> qurekaSettingBanner() async {
    var data = ['b1', 'b2', 'b3', 'b4', 'b5', 'b6'];
    int dataCount = data.length - 1;
    int mCounter =
        await SharedPref.getIntFromLocalMemory(SharedPref.qBannerCount, 0);
    if (mCounter < dataCount)
      mCounter++;
    else
      mCounter = 0;
    SharedPref.saveIntInLocalMemory(SharedPref.qBannerCount, mCounter);
    return data[mCounter];
  }
}

Future<String> qurekaSettingGIF() async {
  var data = ['g1', 'g2', 'g3', 'g4', 'g5', 'g6'];
  int dataCount = data.length - 1;
  int mCounter =
      await SharedPref.getIntFromLocalMemory(SharedPref.qGifCount, 0);
  if (mCounter < dataCount)
    mCounter++;
  else
    mCounter = 0;
  SharedPref.saveIntInLocalMemory(SharedPref.qGifCount, mCounter);
  return data[mCounter];
}

Future<void> qureka() async {
  String qurekaLink =
      await AdPreferences.getAdPrefString(AdPreferences.qurekaLink, "");
  if (qurekaLink != null && qurekaLink != "") {
    if (await canLaunch(qurekaLink)) {
      await launch(
        qurekaLink,
      );
    } else {
      throw 'Could not launch $qurekaLink';
    }
  }
}
