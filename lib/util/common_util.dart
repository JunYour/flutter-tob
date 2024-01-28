import 'package:flutter/cupertino.dart';

class CommonUtil {
  ///验证手机号
  static bool isChinaPhoneLegal(String str) {
    return new RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[0-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }

  ///验证身份证号
  static bool isIdCard(String str){
    return new RegExp('^[1-9][0-9]{5}([1][9][0-9]{2}|[2][0][0|1][0-9])([0][1-9]|[1][0|1|2])([0][1-9]|[1|2][0-9]|[3][0|1])[0-9]{3}([0-9]|[X])\$').hasMatch(str);
  }

  ///图片上传处理
  static String imgDeal({@required String imgStr, @required String type}) {
    List imgArr = imgStr.split(',');
    imgArr.asMap().forEach((key, value) {
      int index = value.indexOf('images/$type');
      if(index>=0){
        value = value.substring(index);
        imgArr[key] = value;
      }
    });
    // int index = imgStr.indexOf('images/$type');
    // String newImgStr = imgStr;
    // if(index>=0){
    //   newImgStr = imgStr.substring(index);
    // }
    return imgArr.join(',');
  }

/// 防重复提交
  static var lastPopTime = DateTime.now();

/// 防重复提交
  static bool checkClick({int needTime = 1}) {
    if (lastPopTime == null ||
        DateTime.now().difference(lastPopTime) > Duration(seconds: needTime)) {
      lastPopTime = DateTime.now();
      return true;
    }
    return false;
  }

  //字符串截取
  static String strSubStr({String str,int start,int end}){
    return str.substring(start,end);
  }
}

