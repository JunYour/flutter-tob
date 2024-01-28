import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/entity/update/update_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateOverlayUtil {
  static OverlayEntry overlayEntry;

  static void show(
      {@required BuildContext context, @required UpdateEntity updateEntity}) {
    if (overlayEntry != null) {
      return;
    }
    //创建一个OverlayEntry对象
    overlayEntry = OverlayEntry(builder: (context) {
      //外层使用Positioned进行定位，控制在Overlay中的位置
      return Material(
        color: Colors.black26,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 300),
                      child: SingleChildScrollView(
                        child: Html(
                          data: updateEntity.content,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Offstage(
                            offstage: updateEntity.enforce==1,
                            child: Container(
                              margin: EdgeInsets.only(right: 30.w),
                              width: 200.w,
                              height: 54.w,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xffd4d4d4),
                                    width: 1,
                                  ),
                                  color: Colors.white,
                                  // 渐变色
                                  borderRadius: BorderRadius.circular(20)),
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                color: Colors.transparent,
//                    highlightColor: Colors.blue[700],
                                colorBrightness: Brightness.dark,
                                splashColor: Color(0x99999999),
                                child: Text(
                                  "取消",
                                  style: TextStyle(
                                    color: Color(0xff999999),
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                onPressed: () {
                                  //需要native插件
                                  dismiss();
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 200.w,
                            height: 54.w,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    ColorConfig.themeColor[100],
                                    ColorConfig.themeColor,
                                  ],
                                ),
                                // 渐变色
                                borderRadius: BorderRadius.circular(20)),
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              color: Colors.transparent,
//                    highlightColor: Colors.blue[700],
                              colorBrightness: Brightness.dark,
                              splashColor: Color(0x99999999),
                              child: Text(
                                "更新",
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              onPressed: () {
                                launch(updateEntity.downloadurl);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
    //往Overlay中插入插入OverlayEntry
    Overlay.of(context).insert(overlayEntry);
    //两秒后，移除Toast
//    new Future.delayed(Duration(seconds: 2)).then((value) {
//      overlayEntry.remove();
//    });
  }

  static void dismiss() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }
}
