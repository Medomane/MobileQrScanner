import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
class func{
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }
  static Future<File> writeContent(String content) async {
    final file = await _localFile;
    return file.writeAsString(content);
  }
  static Future<String> readContent() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    }
    catch (e) {
      return "";
    }
  }
  static bool isNumeric(String s) {
    if(s == null) return false;
    return double.parse(s, (e) => null) != null;
  }
  static void errorToast(String content) => Fluttertoast.showToast(msg: content,backgroundColor: Colors.red,textColor: Colors.white);
}