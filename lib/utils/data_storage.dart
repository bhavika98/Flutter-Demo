import 'package:flutter_demo/model/ring_data.dart';
import 'package:flutter_demo/model/theme_data.dart';
import 'package:flutter_demo/model/user_data.dart';

class DataStorage {
  static var array = [
    "0xFFF9EEAE",
    "0xFFFACCBB",
    "0xFFF7EDB9",
    "0xFFFEBCC3",
    "0xFFC6F5FF",
    "0xFFFFC5AC",
    "0xFFBBEEBD"
  ];

  static List<UserData> fetchDefault() {
    List<UserData> arrayList = [];

    arrayList.add(UserData(
        type: 0,
        name: 'Jimin (Park Jimin)',
        contact: '+82 38 2736 5462',
        image: '1',
        video: '1', id: null));

    arrayList.add(UserData(
        type: 0,
        name: 'Jungkook (Jeon Jungkook)',
        contact: '+82 54 5930 8730',
        image: '2',
        video: '2', id: null));

    arrayList.add(UserData(
        type: 0,
        name: 'V (Kim Taehyung)',
        contact: '+82 87 1736 2746',
        image: '3',
        video: '3', id: null));

    arrayList.add(UserData(
        type: 0,
        name: 'Jin (Kim Seokjin)',
        contact: '+82 19 3846 2847',
        image: '4',
        video: '4', id: null));

    arrayList.add(UserData(
        type: 0,
        name: 'Suga (Min Yoongi)',
        contact: '+82 27 5630 2947',
        image: '5',
        video: '5', id: null));

    arrayList.add(UserData(
        type: 0,
        name: 'J-Hope (Jung Hoseok)',
        contact: '+82 48 2974 9765',
        image: '6',
        video: '6', id: null));

    arrayList.add(UserData(
        type: 0,
        name: 'RM (Kim Namjoon)',
        contact: '+82 19 3846 2847',
        image: '7',
        video: '7', id: null));

    return arrayList;
  }

  static List<ThemeDatas> fetchTheme() {
    List<ThemeDatas> arrayList = [];

    arrayList.add(new ThemeDatas(id: 1, title: '#WhatsApp', image: 'thumb_1'));
    arrayList.add(new ThemeDatas(id: 2, title: '#Messenger', image: 'thumb_2'));
    arrayList.add(new ThemeDatas(id: 3, title: '#Skype', image: 'thumb_3'));
    arrayList.add(new ThemeDatas(id: 4, title: '#Hike', image: 'thumb_4'));
    arrayList.add(new ThemeDatas(id: 5, title: '#Duo', image: 'thumb_5'));
    arrayList.add(new ThemeDatas(id: 6, title: '#Snapchat', image: 'thumb_6'));
    arrayList.add(new ThemeDatas(id: 7, title: '#FaceTime', image: 'thumb_7'));

    return arrayList;
  }

  static List<RingData> fetchRing() {
    List<RingData> arrayList = [];

    arrayList.add(new RingData(
        id: 1,
        name: 'Default',
        path: 'default',
        duration: 'Mobile\'s default ringtone',
        interrupted: false));
    arrayList.add(new RingData(
        id: 2,
        name: 'Begin',
        path: 'begin',
        duration: '00:47',
        interrupted: false));
    arrayList.add(new RingData(
        id: 3,
        name: 'DNA',
        path: 'dna',
        duration: '00:46',
        interrupted: false));
    arrayList.add(new RingData(
        id: 4,
        name: 'Euphoria',
        path: 'euphoria',
        duration: '00:35',
        interrupted: false));
    arrayList.add(new RingData(
        id: 5,
        name: 'Fire',
        path: 'fire',
        duration: '00:41',
        interrupted: false));
    arrayList.add(new RingData(
        id: 6,
        name: 'Jump',
        path: 'jump',
        duration: '00:31',
        interrupted: false));
    arrayList.add(new RingData(
        id: 7,
        name: 'MIC Drop',
        path: 'mic_drop',
        duration: '00:38',
        interrupted: false));
    arrayList.add(new RingData(
        id: 8,
        name: 'Not Today',
        path: 'not_today',
        duration: '00:28',
        interrupted: false));
    arrayList.add(new RingData(
        id: 9, name: 'On', path: 'on', duration: '00:58', interrupted: false));
    arrayList.add(new RingData(
        id: 10,
        name: 'Young Forever',
        path: 'young_forever',
        duration: '00:44',
        interrupted: false));
    arrayList.add(new RingData(
        id: 11,
        name: 'Dynamite',
        path: 'dynamite',
        duration: '00:17',
        interrupted: false));
    arrayList.add(new RingData(
        id: 12,
        name: 'Mikrokosmos',
        path: 'mikrokosmos',
        duration: '00:30',
        interrupted: false));
    arrayList.add(new RingData(
        id: 13,
        name: 'Ddaeng',
        path: 'ddaeng',
        duration: '00:13',
        interrupted: false));
    arrayList.add(new RingData(
        id: 14,
        name: 'Serendipity',
        path: 'serendipity',
        duration: '00:39',
        interrupted: false));

    return arrayList;
  }
}
