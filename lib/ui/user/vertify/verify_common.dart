import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

messageInfo({@required String title, @required String content,double left,double right,double width}) {
  if(left==null){
    left = 30.w;
  }
  if(right == null){
    right = 30.w;
  }
  if(width == null){
    width = 250.w;
  }

  return Container(
    height: 71.w,
    margin: EdgeInsets.only(left: left, right: right),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 1.w,
          color: Color(0xff999999),
        ),
      ),
    ),
    child: Row(
      children: [
        Container(
          child: Text(
            "$title",
            style: TextStyle(
              fontSize: 24.sp,
              color: Color(0xff999999),
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ),
        Expanded(
          child: Text(
            "$content",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 24.sp,
              height: 1,
              fontWeight: FontWeight.bold,
              color: Color(0xff333333),
            ),
          ),
        ),
      ],
    ),
  );
}