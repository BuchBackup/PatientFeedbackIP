import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

myToast(backgroundColor, messsage, textColor) {
  return Fluttertoast.showToast(
    msg: '$messsage',
    backgroundColor: backgroundColor,
    gravity: ToastGravity.CENTER,
    textColor: textColor,
    // textColor: const Color(0x00000003),
    fontSize: 10,
  );
}
