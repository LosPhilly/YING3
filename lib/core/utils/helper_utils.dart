import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore: library_prefixes
import 'dart:io' as Io;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../constants/string_const.dart';

const _kSupportedVideoMimes = {
  'video/mp4',
  'video/mov',
  'video/mpeg',
  'video/quicktime'
};

class HelperUtils {
  // static hideKeyboard(BuildContext context) {
  //   FocusScope.of(context).unfocus();
  // }

  static hideKeyboard(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static isValidEmail(String email) {
    return RegExp(
        r"[_a-z0-9-]+(\.[_a-z0-9-]+)*(\+[a-z0-9-]+)?@[a-z0-9-]+(\.[a-z0-9-]+)*$")
        .hasMatch(email);
  }

  static loaderWidget({double size = 40, Color color = Colors.white}) {
    return Center(
        child: SizedBox(
          height: size,
          width: size,
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color)),
        ));
  }

  static toast({required String msg, int timeInSec = 2}) {
    Fluttertoast.showToast(msg: msg, timeInSecForIosWeb: timeInSec);
  }

  static openAndroidAlertDialog(String message, BuildContext context,
      {bool isPopToBack = false}) async {
    Widget okButton = TextButton(
      child: const Text(
        "Ok",
        style: TextStyle(fontFamily: REGULAR_FONT, color: Colors.blue),
      ),
      onPressed: () {
        Navigator.pop(context, 'ok');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(APP_NAME, style: TextStyle(fontFamily: REGULAR_FONT)),
      content: Text(message, style: const TextStyle(fontFamily: REGULAR_FONT)),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((val) {
      if (isPopToBack) {
        Navigator.pop(context);
      }
    });
  }

  static Future<String> openAndroidAlertDialogTwoOpt(
      String message, BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("Yes",
          style: TextStyle(fontFamily: REGULAR_FONT, color: Colors.blue)),
      onPressed: () {
        Navigator.pop(context, 'yes');
      },
    );

    Widget cancelBtn = TextButton(
      child: const Text("Cancel",
          style: TextStyle(fontFamily: REGULAR_FONT, color: Colors.blue)),
      onPressed: () {
        Navigator.pop(context, 'cancel');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(APP_NAME, style: TextStyle(fontFamily: REGULAR_FONT)),
      content: Text(message, style: const TextStyle(fontFamily: REGULAR_FONT)),
      actions: [cancelBtn, okButton],
    );

    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) {
      return result;
    });
  }

  static showAndroidLoader(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: SizedBox(
        height: 80,
        width: 250,
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: loaderWidget(size: 40, color: Colors.blue),
            ),
            const Text("Please wait...",
                style: TextStyle(fontFamily: REGULAR_FONT)),
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static hideAndroidLoader(BuildContext context) {
    Navigator.pop(context, 'ok');
  }

  static openAlertDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text(
          APP_NAME,
          style: TextStyle(fontFamily: REGULAR_FONT),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: REGULAR_FONT),
        ),
        actions: [
          CupertinoDialogAction(
              isDefaultAction: false,
              child: const Text(
                "Ok",
                style: TextStyle(fontFamily: REGULAR_FONT, color: Colors.blue),
              ),
              onPressed: () {
                Navigator.pop(context, 'ok');
              }),
        ],
      ),
    );
  }

  static bool isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  static openAlertDialogPopToHome(String message, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text(
          APP_NAME,
          style: TextStyle(fontFamily: REGULAR_FONT),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: REGULAR_FONT),
        ),
        actions: [
          CupertinoDialogAction(
              isDefaultAction: false,
              child: const Text(
                "Ok",
                style: TextStyle(fontFamily: REGULAR_FONT, color: Colors.blue),
              ),
              onPressed: () {
//                Navigator.push(
//                    context,
//                    PageRouteBuilder(
//                        pageBuilder: (context, animation1, animation2) =>
//                            HomePage()));
              }),
        ],
      ),
    );
  }

  static Future<String> openAlertDialogWithPop(
      String message, BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text(
          APP_NAME,
          style: TextStyle(fontFamily: REGULAR_FONT),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: REGULAR_FONT),
        ),
        actions: [
          CupertinoDialogAction(
              isDefaultAction: false,
              child: const Text(
                "Ok",
                style: TextStyle(fontFamily: REGULAR_FONT, color: Colors.blue),
              ),
              onPressed: () {
                Navigator.pop(context, 'ok');
              }),
        ],
      ),
    ).then((value) {
      return value;
    });
  }

  static String add0beforeInt(String number) {
    if (int.parse(number.trim()) <= 9) {
      if (number.trim().startsWith('0')) {
        return number;
      } else {
        return "0${number.trim()}";
      }
    } else {
      return number;
    }
  }

  static Future<String> openAlertDialogTwoOpt(
      String message, BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text(
          APP_NAME,
          style: TextStyle(fontFamily: REGULAR_FONT),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: REGULAR_FONT),
        ),
        actions: [
          CupertinoDialogAction(
              isDefaultAction: false,
              child: const Text(
                "Yes",
                style: TextStyle(fontFamily: REGULAR_FONT, color: Colors.blue),
              ),
              onPressed: () {
                Navigator.pop(context, 'yes');
              }),
          CupertinoDialogAction(
              isDefaultAction: false,
              child: const Text(
                "No",
                style: TextStyle(fontFamily: REGULAR_FONT, color: Colors.blue),
              ),
              onPressed: () {
                Navigator.pop(context, 'no');
              }),
        ],
      ),
    ).then((result) {
      return result;
    });
  }

  static Size textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  static Future<String?> askForProfilePic(BuildContext context) {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Theme(
        data: ThemeData.light(),
        child: CupertinoActionSheet(
          title: const Text("Choose Photo Option",
              style: TextStyle(fontSize: 12, fontFamily: REGULAR_FONT)),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text("From Camera",
                  style: TextStyle(fontSize: 17, fontFamily: REGULAR_FONT)),
              onPressed: () {
                Navigator.pop(context, 'camera');
              },
            ),
            CupertinoActionSheetAction(
              child: const Text("From Gallery",
                  style: TextStyle(fontSize: 17, fontFamily: REGULAR_FONT)),
              onPressed: () {
                Navigator.pop(context, 'gallery');
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text("Cancel",
                style: TextStyle(fontSize: 17, fontFamily: REGULAR_FONT)),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    ).then((value) {
      return Future.value(value);
    });
  }

  static Future<String?> askForPicFile(BuildContext context) {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Theme(
        data: ThemeData.light(),
        child: CupertinoActionSheet(
          title: const Text("Choose Option",
              style: TextStyle(fontSize: 12, fontFamily: REGULAR_FONT)),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text("Image",
                  style: TextStyle(fontSize: 17, fontFamily: REGULAR_FONT)),
              onPressed: () {
                Navigator.pop(context, 'image');
              },
            ),
            CupertinoActionSheetAction(
              child: const Text("Video",
                  style: TextStyle(fontSize: 17, fontFamily: REGULAR_FONT)),
              onPressed: () {
                Navigator.pop(context, 'video');
              },
            ),
            CupertinoActionSheetAction(
              child: const Text("File",
                  style: TextStyle(fontSize: 17, fontFamily: REGULAR_FONT)),
              onPressed: () {
                Navigator.pop(context, 'file');
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text("Cancel",
                style: TextStyle(fontSize: 17, fontFamily: REGULAR_FONT)),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    ).then((value) {
      return Future.value(value);
    });
  }

  static SizedBox verticalSpace(double size) {
    return SizedBox(height: size);
  }

  static SizedBox horizontalSpace(double size) {
    return SizedBox(width: size);
  }

  static Future<Io.File?> getImageFromNetwork(String url) async {
    var cacheManager = DefaultCacheManager();
    Io.File? file = await cacheManager.getSingleFile(url);
    debugPrint("getImageFromNetwork -> ${file.path}");
    return file;
  }

  // static String getChatID(
  //     {@required String peerID, @required String myUserID}) {
  //   if (myUserID == peerID) {
  //     return null;
  //   }
  //
  //   print("peerID $peerID");
  //   print("_myUserID $myUserID");
  //
  //   String _groupChatId;
  //   if (myUserID.hashCode <= peerID.hashCode) {
  //     _groupChatId = '$myUserID-$peerID';
  //   } else {
  //     _groupChatId = '$peerID-$myUserID';
  //   }
  //   print("groupChatId $_groupChatId");
  //
  //   return _groupChatId;
  // }

  static Color? getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    } else {
      return null;
    }
  }

  static Widget somethingWentWrongMSG({double padding = 20}) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: const Text("Something went wrong, Please try gain!",
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white70),
            textAlign: TextAlign.center),
      ),
    );
  }

  static Widget noDataMsgFor(
      {String msg = "No Data Found",
        double padding = 20,
        double fontSize = 25}) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Text(msg,
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                fontFamily: REGULAR_FONT,
                color: Colors.grey.shade300),
            textAlign: TextAlign.center),
      ),
    );
  }

//   static Future<File> urlToFile(String imageUrl) async {
// // generate random number.
//     var rng = new Random();
// // get temporary directory of device.
//     Directory tempDir = await getTemporaryDirectory();
// // get temporary path from temporary directory.
//     String tempPath = tempDir.path;
// // create a new file in temporary path with random file name.
//     File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// // call http.get method and pass imageUrl into it to get response.
//     http.Response response = await http.get(imageUrl);
// // write bodyBytes received in response to file.
//     await file.writeAsBytes(response.bodyBytes);
// // now return the file which is created with random name in
// // temporary directory and image bytes from response is written to // that file.
//     return file;
//   }
//
//   DateTime formatFirebaseTimestamp(dynamic timestamp) {
//     if (timestamp == null) return null;
//
//     return DateTime.fromMicrosecondsSinceEpoch(
//       timestamp.microsecondsSinceEpoch,
//     );
//   }
}