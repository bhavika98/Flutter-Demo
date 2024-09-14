import 'package:flutter_share/flutter_share.dart';
import 'package:package_info/package_info.dart';

class Common {
  static Future<void> share() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    await FlutterShare.share(
        title: 'Check out this application',
        text: 'Check out ${packageInfo.appName} application at',
        linkUrl:
            'https://itunes.apple.com/us/app/myapp/id${packageInfo.packageName}?ls=1&mt=8',
        chooserTitle: 'Share App');
  }

  static more() {}
}
