class AdModel {
  int versionCount;
  int versionCode;
  String package;
  String title;
  String msg;
  Data data;

  AdModel(
      {required this.versionCount,
      required this.versionCode,
      required this.package,
      required this.title,
      required this.msg,
      required this.data});

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      versionCount: json['versionCount'],
      versionCode: json['versionCode'],
      package: json['package'],
      title: json['title'],
      msg: json['msg'],
      data: Data.fromJson(json["data"]),
    );
  }
}

class Data {
  bool status;
  String adMobAppID;
  String adMobNative;
  String adMobBanner;
  String adMobInter;
  String adMobReward;
  String fbNative;
  String fbBanner;
  String fbInter;
  int isAdmobEnable;
  int isfbEnable;
  int priority;
  int priority1;
  int priority2;
  int adGap;
  int epGap;
  String moreApps;
  String qurekaLink;
  String privacy;

  Data(
      {required this.status,
      required this.adMobAppID,
      required this.adMobNative,
      required this.adMobBanner,
      required this.adMobInter,
      required this.adMobReward,
      required this.fbNative,
      required this.fbBanner,
      required this.fbInter,
      required this.isAdmobEnable,
      required this.isfbEnable,
      required this.priority,
      required this.priority1,
      required this.priority2,
      required this.adGap,
      required this.epGap,
      required this.moreApps,
      required this.qurekaLink,
      required this.privacy});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        status: json['status'],
        adMobAppID: json['adMobAppID'],
        adMobNative: json['adMobNative'],
        adMobBanner: json['adMobBanner'],
        adMobInter: json['adMobInter'],
        adMobReward: json['adMobReward'],
        fbNative: json['fbNative'],
        fbBanner: json['fbBanner'],
        fbInter: json['fbInter'],
        isAdmobEnable: json['isAdmobEnable'],
        isfbEnable: json['isfbEnable'],
        priority: json['priority'],
        priority1: json['priority1'],
        priority2: json['priority2'],
        adGap: json['adGap'],
        epGap: json['epGap'],
        moreApps: json['moreApps'],
        qurekaLink: json['qurekaLink'],
        privacy: json['privacy']);
  }
}
