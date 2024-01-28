import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarApi{
  static String url ="http://47.114.42.167:18307";
}

class CarWidget{
  Widget loadingData() {
    Widget body;
    if (Platform.isIOS) {
      body = CupertinoActivityIndicator();
    } else if (Platform.isAndroid) {
      body = CircularProgressIndicator();
    } else {
      body = CupertinoActivityIndicator();
    }
    return Center(child: body);
  }
}