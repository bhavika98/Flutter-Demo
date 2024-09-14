import 'package:fluttertoast/fluttertoast.dart';

class Show {
  static shortToast(var msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
}
