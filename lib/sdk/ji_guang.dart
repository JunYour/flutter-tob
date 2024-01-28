import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jmlink_flutter_plugin/jmlink_flutter_plugin.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tob/bloc/notice/notice_bloc.dart';
import 'package:tob/main.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/routes.dart';

class JiGuang {



  static void initJml() {
    // jmlConfig.appKey = "8b84ddf08b698c7065180a32";
    // jmlConfig.channel = "theChannel";
    // jmlConfig.debug = false;
    // JmlinkFlutterPlugin.instance.setup(config: jmlConfig);
  }

// Platform messages are asynchronous, so we initialize in an async method.
 static Future<void> initPlatformState() async {
    jpush.setup(
      appKey: "8b84ddf08b698c7065180a32", //你自己应用的 AppKey
      channel: "theChannel",
      production: true,
      debug: false,
    );
    jpush.applyPushAuthority(
      new NotificationSettingsIOS(sound: true, alert: true, badge: false),
    );
    if (await Permission.notification.isGranted != true) {
      return false;
    }
    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
            BlocProvider.of<NoticeBloc>(
                    navigatorKey.currentState.overlay.context)
                .add(NoticeLoadEvent(reload: true));
          },
          onOpenNotification: (Map<String, dynamic> message) async {
            ///点击通知回调
            BuildContext context = navigatorKey.currentState.overlay.context;
            MyRoute.router.navigateTo(context, Routes.message + "?type=2");
          },
          onReceiveMessage: (Map<String, dynamic> message) async {
            // 接收通知回调方法
          },
          onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {});
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }

    jpush.getRegistrationID().then((rid) {
      //冷启动app
      Future.delayed(Duration(seconds: 1), () {
        jpush.getLaunchAppNotification();
      });
    });
  }
}
