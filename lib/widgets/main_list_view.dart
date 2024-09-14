import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/activity/basic_page.dart';
import 'package:flutter_demo/utils/data_storage.dart';
import 'package:flutter_demo/utils/database_helper.dart';
import 'package:flutter_demo/utils/folder_util.dart';
import 'package:flutter_demo/utils/messages.dart';
import '../model/user_data.dart';

// ignore: must_be_immutable
class MainListView extends BasePage {
  List<UserData> mUserData = [];

  final Function listCallback;

  MainListView({required this.listCallback, required this.mUserData}) : super();

  @override
  _MainListViewState createState() => _MainListViewState();
}

class _MainListViewState extends BaseState<MainListView> with BasicPage {
  int counter = 0;

  deleteUser(int index) async {
    UserData data = widget.mUserData[index];
    await DatabaseHelper.instance.delete(data.id ?? 0);
    widget.mUserData.removeAt(index);
    Show.shortToast("Contact Removed Successfully.");
    setState(() {});
  }

  int _kAdIndex = 5;
  int totalAd = 0;
  int indexCounter = 0;

  @override
  void initState() {
    super.initState();
    loadFbNativeSmall();
  }

  @override
  Widget build(BuildContext context) {
    indexCounter = 0;
    return StaggeredGridView.countBuilder(
      crossAxisCount: 1,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      itemCount: widget.mUserData.length +
          (widget.mUserData.length ~/ _kAdIndex).round(),
      itemBuilder: (BuildContext context, int index) {
        if ((index + 1) % _kAdIndex == 0) {
          indexCounter++;
          return Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: showFbNativeSmall(),
          );
        } else {
          index = index - indexCounter;
          return Column(
            children: [
              ListTile(
                onTap: () {
                  widget.listCallback(widget.mUserData[index], context);
                },
                title: Text(
                  widget.mUserData[index].name,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
                ),
                trailing: widget.mUserData[index].type == 1
                    ? GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text(
                                      'Deleting Contact',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    content: const Text(
                                      'Are you sure you want to remove this contact?',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'No'),
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteUser(index);
                                          Navigator.pop(context, 'Yes');
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  ));
                        },
                        child: Image.asset(
                          'assets/icon/ic_clear.png',
                          color: Colors.black,
                          height: 25,
                          width: 25,
                        ),
                      )
                    : null,
                subtitle: Text(
                  widget.mUserData[index].contact,
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(getRandomClr(widget.mUserData[index])),
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/icon/avatar.png'),
                        radius: 23,
                      ),
                      widget.mUserData[index].type == 0
                          ? CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: widget.mUserData[index].image
                                      .contains('${AppUtil.profileImg}/bts_')
                                  ? FileImage(new File(
                                      '${widget.mUserData[index].image}'))
                                  : AssetImage(
                                      'assets/image/${widget.mUserData[index].image}.jpg'),
                              radius: 23,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                // fit: BoxFit.cover,
                                child: Image.file(
                                  File(widget.mUserData[index].image),
                                  fit: BoxFit.cover,
                                  height: 46,
                                  width: 46,
                                ),
                              ),
                              radius: 23,
                            )
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.black12),
            ],
          );
        }
      },
      staggeredTileBuilder: (int index) {
        return StaggeredTile.fit(1);
      },
    );
  }

  int getRandomClr(UserData userData) {
    if (counter < DataStorage.array.length - 1) {
      counter++;
    } else {
      counter = 0;
    }
    userData.color = int.parse(DataStorage.array[counter]);
    return userData.color ?? 0xFFFFFFFF;
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
