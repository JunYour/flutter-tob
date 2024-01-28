import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/widget/wx_share.dart';

class StaffInvite extends Dialog {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          width: 497.w,
          height: 350.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.w),
          ),
          child: Column(children: [
            Container(
              height: 150.w,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "邀请加入",
                      style: TextStyle(
                          fontSize: 36.sp,
                          color: ColorConfig.themeColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    top: 19.w,
                    right: 19.w,
                    child: InkWell(
                      onTap: () {
                        MyRoute.router.pop(context);
                      },
                      child: Icon(
                        Icons.cancel,
                        color: ColorConfig.themeColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                Http.getInstance().getBusInviteLink().then((value){
                  wxShare(url: value.data,title: "邀请加入企业",description: "直接邀请员工加入企业");
                });
              },
              child: Column(
                children: [
                  Image.asset(
                    "assets/icon_weixin_share.png",
                    width: 114.w,
                    height: 114.w,
                  ),
                  Text("微信邀请")
                ],
              ),
            ),
          ]),
        ),
      ),
      type: MaterialType.transparency,
    );
  }
}
