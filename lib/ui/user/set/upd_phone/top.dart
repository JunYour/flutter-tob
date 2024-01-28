import 'package:flutter/material.dart';
import 'package:tob/route/my_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

stackWidget({BuildContext context,Function func}) {
  return Stack(
    children: [
      //背景
      Align(
        alignment: Alignment.topLeft,
        child: Image.asset(
          'assets/login_top.png',
          width: 750.w,
          height: 494.w,
          fit: BoxFit.cover,
        ),
      ),
      //文字
      Positioned(
        left: 96.w,
        top: 216.w,
        child: Text(
          '手机号码修改',
          style: TextStyle(
              fontFamily: 'ingFangSC-Medium, PingFang SC',
              fontSize: 48.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      context != null
          ? Positioned(
              left: 30.w,
              top: 80.w,
              child: IconButton(
                onPressed: () {
                  func!=null?func():
                  MyRoute.router.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            )
          : Divider(),
    ],
  );
}
