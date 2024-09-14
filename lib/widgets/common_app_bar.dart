import 'package:flutter/material.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/activity/basic_page.dart';

class CommonAppBar extends BasePage {
  final String title;

  CommonAppBar({required this.title});

  @override
  _CommonAppBarState createState() => _CommonAppBarState();
}

class _CommonAppBarState extends BaseState<CommonAppBar> with BasicPage {
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
              'assets/icon/ic_back.png',
              color: Colors.white,
              width: 18,
              height: 18,
              alignment: Alignment.center,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 0),
              child: Text(
                widget.title,
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
