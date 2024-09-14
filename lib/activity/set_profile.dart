import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/activity/basic_page.dart';
import 'package:flutter_demo/activity/home.dart';
import 'package:flutter_demo/activity/more_image.dart';
import 'package:flutter_demo/model/user_data.dart';
import 'package:flutter_demo/utils/constants.dart';
import 'package:flutter_demo/utils/database_helper.dart';
import 'package:flutter_demo/utils/folder_util.dart';
import 'package:flutter_demo/utils/multi_dialog.dart';
import 'package:flutter_demo/utils/messages.dart';
import 'package:flutter_demo/utils/network_check.dart';
import 'package:flutter_demo/widgets/my_icon_icons.dart';

// ignore: must_be_immutable
class Profile extends BasePage {
  UserData mUserData;

  Profile({required this.mUserData});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends BaseState<Profile> with BasicPage {
  late Future futureAlbum;
  late int userId;
  bool firstTime = true;
  String name = "", contact = "", _image = "";

  late TextEditingController nameController;
  late TextEditingController contactController;

  List<String> lisData = [];

  @override
  void initState() {
    super.initState();
    loadAds();
    loadFbBanner();
    loadAdmobBanner();
    setDefaultValue();
    futureAlbum = fetchData();
  }

  Future fetchData() async {
    lisData = [];
    lisData.add('${widget.mUserData.id}');
    for (int i = 1; i < 4; i++) {
      lisData.add('${widget.mUserData.id}_$i');
    }
    fetchMedia();
  }

  void fetchMedia() async {
    String directory =
        await AppUtil.createFolderInAppDocDir(AppUtil.profileImg);
    final myDir = new Directory(directory);
    List<FileSystemEntity> _images =
        myDir.listSync(recursive: true, followLinks: false);
    for (int i = 0; i < _images.length; i++) {
      if ('${_images[i].path}'.contains('bts_$userId')) {
        lisData.add('${_images[i].path}');
      }
    }
    lisData.add("More");
    setState(() {});
  }

  _saveData() async {
    name = nameController.text;
    contact = contactController.text;
    if (name.isEmpty)
      Show.shortToast("Please Enter Name.");
    else if (contact.isEmpty)
      Show.shortToast("Please Enter Contact No.");
    else {
      UserData userData = new UserData(
          id: widget.mUserData.id,
          type: 0,
          name: this.name,
          contact: this.contact,
          image: this._image,
          video: widget.mUserData.video);
      await DatabaseHelper.instance.update(userData);
      Show.shortToast("Profile Updated Successfully.");
      callAds();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()),
          (Route<dynamic> route) => false);
    }
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    callAds();
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MoreImage(
                userId: this.userId,
              )),
    ).then((value) {
      if (Constants.isDownload) {
        futureAlbum = fetchData();
        Constants.isDownload = false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    super.dispose();
  }

  void setDefaultValue() {
    if (firstTime) {
      userId = widget.mUserData.id!;
      name = widget.mUserData.name;
      contact = widget.mUserData.contact;
      _image = widget.mUserData.image;
      nameController = TextEditingController(text: name);
      contactController = TextEditingController(text: contact);
      firstTime = false;
    }
  }

  @override
  Widget body() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Name :',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 15, right: 20),
                  child: TextField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.purple,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      suffixIcon: Icon(
                        MyIcon.user_1,
                        size: 18,
                        color: Colors.black54,
                      ),
                      fillColor: Colors.grey.shade200,
                      hintText: 'Enter Name',
                      hintStyle: TextStyle(
                        color: Colors.black54,
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 18.0, bottom: 20.0, top: 20.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 30, right: 20),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Contact No. :',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 15, right: 20),
                  child: TextField(
                    controller: contactController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    cursorColor: Colors.purple,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      suffixIcon: Icon(
                        MyIcon.phone,
                        size: 18,
                        color: Colors.black54,
                      ),
                      fillColor: Colors.grey.shade200,
                      hintText: 'Enter Contact No.',
                      hintStyle: TextStyle(
                        color: Colors.black54,
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 18.0, bottom: 20.0, top: 20.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 15),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select Image :',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: FutureBuilder(
                        future: futureAlbum,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                            default:
                              return GridView.builder(
                                itemCount: lisData.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                itemBuilder: (BuildContext context, int index) {
                                  return Stack(
                                    children: <Widget>[
                                      if (lisData[index] == "More")
                                        GestureDetector(
                                          onTap: () {
                                            netCheck();
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    color: Colors.grey.shade200,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Center(
                                                    child: Image.asset(
                                                      'assets/icon/ic_image.png',
                                                      width: 22,
                                                      height: 22,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    'More Image',
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      else if (lisData[index] != "More")
                                        if (lisData[index].contains(
                                            "${AppUtil.profileImg}/bts_"))
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _image = lisData[index];
                                              });
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.file(
                                                  new File('${lisData[index]}'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          )
                                        else
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _image = lisData[index];
                                              });
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.asset(
                                                  'assets/image/${lisData[index]}.jpg',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          )
                                      else
                                        Container(),
                                      if (_image == lisData[index])
                                        Stack(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Image.asset(
                                                'assets/icon/btn_check.png',
                                                width: 24,
                                                height: 24,
                                              ),
                                            ),
                                          ],
                                        )
                                    ],
                                  );
                                },
                              );
                          }
                        }),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        left: 20, top: 30, right: 20, bottom: 30),
                    child: Container(
                        height: 55,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _saveData();
                          },
                          child: Text(
                            'Update Profile',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.purple),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.purple)))),
                        ))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  String screenName() {
    return 'Edit Profile';
  }

  void netCheck() async {
    NetworkCheck networkCheck = new NetworkCheck();
    await networkCheck.check().then((value) {
      if (value) {
        Constants.isDownload = false;
        _navigateAndDisplaySelection(context);
      } else {
        MultiDialog().showPopup(context);
      }
    });
  }
}
