import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tob/entity/user_info_entity.dart';
import 'package:tob/global/app.dart';
import 'package:tob/global/userInfo.dart';

/// 拦截器 请求前添加头部 token 和语言
class MyInterceptor extends Interceptor {
  /*
   * 请求前
   */

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{

      Map<String, dynamic> header = {"token": ""};

      ///传入token
      UserInfoEntity userInfoEntity = UserInfo.getUserInfo();
      if (userInfoEntity != null) {
        header["token"] = userInfoEntity.token;
      }

      ///传入版本号
      String version = await App.getVersionName();
      header["version"] = version;

      ///区分iOS和Android
      String type = "ios";
      if(Platform.isAndroid==true){
        type="android";
      }
      header["type"] = type;

      options.headers.addAll(header);
    super.onRequest(options, handler);
  }
}
