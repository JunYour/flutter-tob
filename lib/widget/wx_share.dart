import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:fluwx/fluwx.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/main.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/widget/loading.dart';

//微信分享,type=0:网络链接,1:网络文件
wxShare(
    {@required String url, String title, String description, int type = 0}) async{
  BuildContext thisContext = navigatorKey.currentState.context;

  bool isInstall = await fluwx.isWeChatInstalled;
  if(isInstall ==false){
    Loading.toast(msg: "请先安装微信");
    return false;
  }
  showModalBottomSheet(
    enableDrag: false,
    context: thisContext,
    builder: (_) {
      return SafeArea(
        bottom: true,
        child: Container(
          height: 300.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.w),
                topRight: Radius.circular(20.w)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(32.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Image.asset(
                        "assets/icon_weixin_share.png",
                        width: 114.w,
                        height: 114.w,
                      ),
                      onTap: () {
                        if (type == 0) {
                          //分享链接
                          WeChatShareWebPageModel webPageModel =
                              WeChatShareWebPageModel(
                            "$url",
                            scene: WeChatScene.SESSION,
                            title: title,
                            thumbnail: WeChatImage.asset('assets/logo.png'),
                            description: description,
                          );
                          shareToWeChat(webPageModel)
                              .then((value) {})
                              .catchError((err) {
                            print(err);
                          });
                        } else if (type == 1) {
                          //分享网络文件
                          WeChatShareFileModel fileModel = WeChatShareFileModel(
                            WeChatFile.network(url),
                            title: title,
                            description: description,
                            thumbnail: WeChatImage.asset('assets/logo.png'),
                            scene: WeChatScene.SESSION,
                          );
                          shareToWeChat(fileModel);
                        }
                      },
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 30.0.w),
                    //   child: InkWell(
                    //     child: Image.asset(
                    //       "assets/icon_pengyouquan.png",
                    //       width: 114.w,
                    //       height: 114.w,
                    //     ),
                    //     onTap: () {
                    //       WeChatShareWebPageModel webPageModel = WeChatShareWebPageModel("https://www.baidu.com", scene: WeChatScene.TIMELINE);
                    //       shareToWeChat(webPageModel);
                    //       if (1 == 1) {
                    //         // navTo(context, "${Routes.login}?pop=true")
                    //         //     .then((value) {
                    //         //   if (value != null) {
                    //         //     Loading.showLoading(context);
                    //         //     Http.getInstance()
                    //         //         .getSharePic(value.id, id)
                    //         //         .then((value) {
                    //         //       UmengSdk.onEvent('share', {'朋友圈': 1});
                    //         //       Loading.hideLoading(context);
                    //         //       shareToWeChat(WeChatShareImageModel(
                    //         //           WeChatImage.network(value),
                    //         //           scene: WeChatScene.TIMELINE));
                    //         //     });
                    //         //   }
                    //         // });
                    //       } else {
                    //         // Http.getInstance()
                    //         //     .getSharePic(App.getUserInfo().id, id)
                    //         //     .then((value) {
                    //         //   UmengSdk.onEvent('share', {'朋友圈': 1});
                    //         //   Loading.hideLoading(context);
                    //         //   shareToWeChat(WeChatShareImageModel(
                    //         //       WeChatImage.network(value),
                    //         //       scene: WeChatScene.TIMELINE));
                    //         // });
                    //       }
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                height: 8.h,
                color: ColorConfig.cancelColor,
              ),
              InkWell(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(28.0.w),
                    child: Text(
                      "取消",
                      style: TextStyle(
                        color: ColorConfig.cancelColor,
                        fontSize: 28.sp,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  MyRoute.router.pop(thisContext);
                },
              )
            ],
          ),
        ),
      );
    },
  );
}
