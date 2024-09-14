import 'package:flutter/material.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/utils/multi_dialog.dart';
import 'package:flutter_demo/utils/network_check.dart';
import 'package:flutter_demo/widgets/common_app_bar.dart';

mixin BasicPage<Page extends BasePage> on BaseState<Page> {
  @override
  Widget build(BuildContext context) {
    checkNetwork();

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            CommonAppBar(
              title: screenName(),
            ),
            showFbBanner(),
            Expanded(
              child: body(),
            ),
            showAdmobBanner(),
          ],
        ),
      ),
    );
  }

  Widget body();

  void checkNetwork() {
    NetworkCheck networkCheck = new NetworkCheck();
    networkCheck.checkInternet(fetchPrefrence);
  }

  fetchPrefrence(bool isNetworkPresent) {
    if (!isNetworkPresent) {
      MultiDialog().showPopup(context);
    }
  }
}
