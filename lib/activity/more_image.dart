import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_demo/activity/base.dart';
import 'package:flutter_demo/activity/basic_page.dart';
import 'package:flutter_demo/model/profile_data.dart';
import 'package:flutter_demo/utils/constants.dart';
import 'package:flutter_demo/utils/folder_util.dart';
import 'package:flutter_demo/utils/messages.dart';
import 'package:flutter_demo/utils/shared_preferences.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

// ignore: must_be_immutable
class MoreImage extends BasePage {
  int userId;

  MoreImage({required this.userId}) : super();

  @override
  _MoreImageState createState() => _MoreImageState();
}

class _MoreImageState extends BaseState<MoreImage> with BasicPage {
  late Future futureAlbum;
  late ProgressDialog progressDialog;
  late String dir;
  late bool imgExisted;
  List<ProfileData> imgPath = [];

  bool downloading = false;
  late int progressString;

  static final _kAdIndex = 10;
  int totalAd = 0;
  int indexCounter = 0;

  @override
  void initState() {
    super.initState();
    loadFbBanner();
    loadAdmobBanner();
    loadAdmobNativeSmall();
    futureAlbum = fetchData();
    progressDialog = ProgressDialog(
      context: context,
    );
  }

  downloadFile(int index, String fileName) async {
    progressDialog.show(
        max: 100,
        msg: 'Preparing Download...',
        progressBgColor: Colors.grey.shade200,
        progressValueColor: Colors.purple);

    Dio dio = Dio();

    String imgUrl = '${Constants.imgUrl}$fileName';
    String dir = await AppUtil.createFolderInAppDocDir(AppUtil.profileImg);

    await dio.download(imgUrl, "$dir/$fileName",
        onReceiveProgress: (rec, total) {
      progressString = ((rec / total) * 100).toInt();
      progressDialog.update(value: progressString, msg: 'Downloading...');
      if (rec == total) {
        progressDialog.close();
        Show.shortToast('Download completed.');
        setState(() {
          Constants.isDownload = true;
          imgPath[index].exist = true;
        });
      }
    });
  }

  Future<List<ProfileData>> fetchData() async {
    imgPath = [];
    int id = widget.userId;
    int totalImg = await SharedPref.getIntFromLocalMemory(SharedPref.imgCount, 10);

    // Create folder and ensure the folder exists before processing files
    String dir = await AppUtil.createFolderInAppDocDir(AppUtil.profileImg);

    // Iterate through image indices
    for (int i = totalImg; i > 0; i--) {
      String path = 'bts_${id}_${i + 4}';
      bool imgValue = await File('$dir$path.jpg').exists();
      imgPath.add(ProfileData(image: '$path', exist: imgValue));
    }

    return imgPath;
  }

  @override
  Widget body() {
    indexCounter = 0;
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FutureBuilder(
              future: futureAlbum,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    return StaggeredGridView.countBuilder(
                      itemCount: imgPath.length +
                          (imgPath.length ~/ _kAdIndex).round(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      itemBuilder: (BuildContext context, int index) {
                        if ((index + 1) % _kAdIndex == 0) {
                          indexCounter++;
                          return showAdmobNativeSmall();
                        } else {
                          index = index - indexCounter;
                          return Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (!imgPath[index].exist)
                                    downloadFile(
                                        index, '${imgPath[index].image}.jpg');
                                  else
                                    Show.shortToast('Already Downloaded.');
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      child: Image.network(
                                          '${Constants.imgUrl}${imgPath[index].image}.jpg'),
                                    ),
                                  ),
                                ),
                              ),
                              imgPath[index].exist
                                  ? Container()
                                  : Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      alignment: Alignment.bottomRight,
                                      padding: EdgeInsets.all(8),
                                      child: Image.asset(
                                        'assets/icon/ic_download.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                    )
                            ],
                          );
                        }
                      },
                      staggeredTileBuilder: (int index) {
                        if ((index + 1) % _kAdIndex == 0) {
                          return StaggeredTile.count(3, 1);
                        } else {
                          return StaggeredTile.count(1, 1);
                        }
                      },
                    );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  String screenName() {
    return 'More Image';
  }
}
