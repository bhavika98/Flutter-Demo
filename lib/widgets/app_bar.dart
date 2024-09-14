import 'package:flutter/material.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/activity/basic_page.dart';

class CustomAppBar extends BasePage {
  final Function openDrawerCallback;

  CustomAppBar({required this.openDrawerCallback});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends BaseState<CustomAppBar> with BasicPage {
  String qurekaGIF = "";

  @override
  void initState() {
    super.initState();
    getqurekaGIF();
  }

  getqurekaGIF() async {
    qurekaGIF = await qurekaSettingGIF();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Image.asset(
              'assets/icon/ic_menu.png',
              color: Colors.white,
              width: 18,
              height: 18,
              alignment: Alignment.center,
            ),
            onPressed: () => widget.openDrawerCallback(),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 0),
              child: Text(
                'B.T.S Fake Video Call',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => qureka(),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Container(
                    margin: new EdgeInsets.symmetric(horizontal: 5),
                    width: 45,
                    height: 45,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: qurekaGIF != ""
                          ? Image.asset(
                              'assets/qureka/$qurekaGIF.gif',
                              width: 40,
                              height: 40,
                            )
                          : Container(),
                    ),
                  ),
                ),
                Container(
                  width: 22,
                  height: 16,
                  alignment: Alignment.center,
                  child: Text(
                    'AD',
                    style: TextStyle(
                        fontFamily: 'Varela Round',
                        fontSize: 8,
                        fontWeight: FontWeight.bold),
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xff959699),
                      borderRadius: BorderRadius.circular(10)),
                )
              ],
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
    );
  }

  @override
  Widget body() {
    throw UnimplementedError();
  }

  @override
  String screenName() {
    throw UnimplementedError();
  }
}
