import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:tob/main.dart';
klDialog({@required Widget widget,double width,double height,Color color,double radius }) async {

  if(width == null){
    width = 497.w;
  }
  if(height == null){
    height = 291.w;
  }
  if(color == null){
    color = Colors.white;
  }
  if(radius == null){
    radius = 30.w;
  }

  BuildContext context = navigatorKey.currentState.context;
  var alertDialogs = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.w),
              color: Colors.white,
            ),
            child: widget
          ),
        );
      });
  return alertDialogs;
}