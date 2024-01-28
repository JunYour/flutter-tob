
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tob/global/app.dart';
import 'package:tob/global/config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/main.dart';
import 'package:tob/widget/inappwebview.dart';
import 'package:tob/widget/loading.dart';

/*
 * 智齿客服
 */
class ZcChannel{
  static const platform = const MethodChannel("channel_zc");


  /*
   * 启动客服已转为OA客服
   */
    static Future<Null>  startKf() async{
      try {
        // platform.invokeMethod("start");//后面可以传过去参数
        String name;
        name = UserInfo.getUserInfo().nickname;
        BuildContext context = navigatorKey.currentState.overlay.context;
        String url =
            Config.OACS +
                name;
        // navTo(context, Routes.webViewPage+"?title=客服&url="+url);
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => DiyInAppWebView(
              title: "在线客服",
              url: url,
            ),
          ),
        );




      } on PlatformException catch (e) {
        Loading.show(status: e.message.toString());
        print(e.message);
      }
  }
}

