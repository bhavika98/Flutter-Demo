import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/activity/basic_page.dart';
import 'package:flutter_demo/model/user_data.dart';
import 'package:flutter_demo/utils/database_helper.dart';
import 'package:flutter_demo/utils/messages.dart';
import 'package:flutter_demo/widgets/my_icon_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'home.dart';

class AddUser extends BasePage {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends BaseState<AddUser> with BasicPage {
  String name = "", contact = "";
  File? _image, _video;
  VideoPlayerController? _videoPlayerController;

  final nameController = TextEditingController();
  final contactController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  _pickVideoFromGallery() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      _video = File(pickedFile.path);
      _videoPlayerController = VideoPlayerController.file(_video!)
        ..initialize().then((_) {
          setState(() {}); // Refresh the UI once the video is initialized
          _videoPlayerController?.setVolume(0.0);
          _videoPlayerController?.play();
        });
    }
  }

  _saveData() async {
    name = nameController.text;
    contact = contactController.text;

    if (name.isEmpty) {
      Show.shortToast("Please Enter Name.");
    } else if (contact.isEmpty) {
      Show.shortToast("Please Enter Contact No.");
    } else if (_image == null) {
      Show.shortToast("Please Pick Image.");
    } else if (_video == null) {
      Show.shortToast("Please Pick Video.");
    } else {
      UserData userData = UserData(
        type: 1,
        name: this.name,
        contact: this.contact,
        image: _image!.path,
        video: _video!.path,
      );
      await DatabaseHelper.instance.insert(userData);
      Show.shortToast("Contact Added Successfully.");
      callAds();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadAds();
    loadFbBanner();
    loadAdmobBanner();
  }

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    _videoPlayerController?.dispose(); // Dispose the video player controller
    super.dispose();
  }

  @override
  Widget body() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 30, right: 20),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
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
                    padding: EdgeInsets.only(left: 20, top: 30, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Pick Image :',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Pick Video :',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 15, right: 20),
                    child: Container(
                      height: 150,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: GestureDetector(
                                onTap: () {
                                  _pickImageFromGallery();
                                },
                                child: Stack(
                                  children: <Widget>[
                                    _image != null
                                        ? Container(
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 10, right: 10),
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                              child: Image.file(
                                                _image!,
                                                height: 140,
                                                width: 140,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _image = null;
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 120, bottom: 100),
                                              child: Image.asset(
                                                'assets/icon/ic_cancel.png',
                                                width: 30,
                                                height: 30,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                        : Container(
                                      alignment: Alignment.center,
                                      width: 140,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/icon/ic_image.png',
                                            width: 22,
                                            height: 22,
                                            color: Colors.black54,
                                          ),
                                          Padding(
                                              padding:
                                              EdgeInsets.only(top: 5),
                                              child: Text(
                                                'Add Image',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ))
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: GestureDetector(
                                onTap: () {
                                  _pickVideoFromGallery();
                                },
                                child: Stack(
                                  children: <Widget>[
                                    _video != null
                                        ? Container(
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 10, right: 10),
                                            child: Container(
                                              width: 140,
                                              height: 140,
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10),
                                                child:
                                                _videoPlayerController !=
                                                    null &&
                                                    _videoPlayerController!
                                                        .value
                                                        .isInitialized
                                                    ? AspectRatio(
                                                  aspectRatio:
                                                  _videoPlayerController!
                                                      .value
                                                      .aspectRatio,
                                                  child: VideoPlayer(
                                                      _videoPlayerController!),
                                                )
                                                    : Container(),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _video = null;
                                                _videoPlayerController = null;
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 120, bottom: 100),
                                              child: Image.asset(
                                                'assets/icon/ic_cancel.png',
                                                width: 30,
                                                height: 30,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                        : Container(
                                      alignment: Alignment.center,
                                      width: 140,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/icon/ic_video.png',
                                            width: 22,
                                            height: 22,
                                            color: Colors.black54,
                                          ),
                                          Padding(
                                              padding:
                                              EdgeInsets.only(top: 5),
                                              child: Text(
                                                'Add Video',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ))
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                              'Save Contact',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            style: ButtonStyle(
                                foregroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.white),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.purple),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side:
                                        BorderSide(color: Colors.purple)))),
                          ))),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  String screenName() {
    return 'Add New Contact';
  }
}

