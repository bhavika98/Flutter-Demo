import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/activity/basic_page.dart';
import 'package:flutter_demo/model/theme_data.dart';
import 'package:flutter_demo/utils/data_storage.dart';
import 'package:flutter_demo/utils/shared_preferences.dart';

class CallTheme extends BasePage {

  @override
  _CallThemeState createState() => _CallThemeState();
}

class _CallThemeState extends BaseState<CallTheme> with BasicPage {
  List<ThemeDatas> mThemedata = [];
  late int defaultTheme;

  static final _kAdIndex = 5;
  int totalAd = 0;
  int indexCounter = 0;

  @override
  void initState() {
    super.initState();
    loadFbBanner();
    loadAdmobBanner();
    loadAdmobNativeMedium();
    SharedPref.getIntFromLocalMemory(SharedPref.theme, 1).then((value) {
      defaultTheme = value;
      mThemedata = DataStorage.fetchTheme();
      setState(() {});
    });
  }

  @override
  Widget body() {
    indexCounter = 0;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: StaggeredGridView.countBuilder(
        itemCount: mThemedata.length + (mThemedata.length ~/ _kAdIndex).round(),
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        itemBuilder: (BuildContext context, int index) {
          if ((index + 1) % _kAdIndex == 0) {
            indexCounter++;
            return showAdmobNativeMedium();
          } else {
            index = index - indexCounter;
            return GestureDetector(
              onTap: () async {
                defaultTheme = mThemedata[index].id;
                SharedPref.saveIntInLocalMemory(SharedPref.theme, defaultTheme);
                setState(() {});
              },
              child: Stack(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        child: Image.asset(
                          'assets/drawable/${mThemedata[index].image}.jpg',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 170),
                        child: Container(
                          width: double.infinity,
                          height: 30,
                          color: Color(0xff80000000),
                          alignment: Alignment.center,
                          child: Text(
                            '${mThemedata[index].title}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  defaultTheme == mThemedata[index].id
                      ? Container(
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            'assets/icon/btn_done.png',
                            width: 50,
                            height: 50,
                          ),
                        )
                      : Container()
                ],
              ),
            );
          }
        },
        staggeredTileBuilder: (int index) {
          return StaggeredTile.fit(1);
        },
      ),
    );
  }

  @override
  String screenName() {
    return 'Select Theme';
  }
}
