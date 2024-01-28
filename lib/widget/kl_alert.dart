import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/global/color_config.dart';
import '../main.dart';

// ignore: must_be_immutable
class KlAlert extends Dialog {
  String content;
  Function sureFunc;
  Function cancelFunc;

  KlAlert({@required this.content, this.sureFunc, this.cancelFunc});

  static showAlert(
      {@required String content,@required Function sureFunc, Function cancelFunc}) {
    BuildContext _thisContext = navigatorKey.currentState.overlay.context;
    showDialog(
      context: _thisContext,
      barrierDismissible: false,
      builder: (context) {
        return KlAlert(
          content: content,
          sureFunc: sureFunc,
          cancelFunc: cancelFunc,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //自定义弹框内容
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 690.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16.w)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 34.w, left: 30.w, right: 30.w),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Icon(Icons.warning_rounded),
                        SizedBox(width: 36.w),
                        Text(
                          this.content,
                          style: TextStyle(
                            color: ColorConfig.themeColor,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 34.w, top: 54.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            return this.sureFunc();
                          },
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all(Size(180.w, 78.w)),
                            backgroundColor:
                                MaterialStateProperty.all(ColorConfig.themeColor),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(48.w),
                                ),
                              ),
                            ),
                          ),
                          child: Text(
                            "确认",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 28.sp,
                                color: Colors.white),
                          ),
                        ),
                        this.cancelFunc != null
                            ? SizedBox(
                                width: 160.w,
                              )
                            : SizedBox(),
                        this.cancelFunc != null
                            ? ElevatedButton(
                                onPressed: () {
                                  return this.cancelFunc();
                                },
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                      Size(180.w, 78.w)),
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorConfig.themeColor[100]),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(48.w),
                                      ),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "取消",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 28.sp,
                                      color: Colors.white),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
