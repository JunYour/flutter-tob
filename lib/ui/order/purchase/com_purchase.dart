import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/global/color_config.dart';

List purchaseState = [
  {'title': '全部采购', 'chose': true},
  {'title': '待付款', 'chose': false},
  {'title': '待发车', 'chose': false},
  {'title': '已发车', 'chose': false},
  {'title': '已收车', 'chose': false},
  {'title': '回传资料', 'chose': false},
  {'title': '已完成', 'chose': false},
  {'title': '已取消', 'chose': false}
];

Container conContainer(String title, String wid) {
  TextStyle style = TextStyle(
    color: ColorConfig.fontColorBlack,
    fontSize: 32.sp,
    fontWeight: FontWeight.w500,
  );
  return Container(
    width: double.infinity,
    height: 110.w,
    padding: EdgeInsets.all(20.w),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 2.w,
          color: ColorConfig.themeColor[100],
        ),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 90.w,
          width: 150.w,
          alignment: Alignment.centerLeft,
          child: Text(
            '$title',
            style: style,
          ),
        ),
        Container(
          width: 400.w,
          height: 90.w,
          alignment: Alignment.centerRight,
          child: Text(
            wid,
            style: style,
          ),
        ),
      ],
    ),
  );
}