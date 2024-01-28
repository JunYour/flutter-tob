import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/main.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/widget/image_show.dart';
import 'package:tob/widget/kl_alert.dart';

Widget commonAppbarTitle({@required String title, List<Widget> actions}) {
  return AppBar(
    title: Text(
      '$title',
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 34.sp,
          fontFamily: 'PingFangSC-Medium, PingFang SC'),
    ),
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black, //修改颜色
    ),
    centerTitle: true,
    actions: actions,
  );
}


Widget blueAppbarTitle({String title,List<Widget> actions,double elevation}){
  return AppBar(
    title: Text("$title"),
    actions: actions,
    brightness: Brightness.dark,
    elevation: elevation,
    centerTitle: true,
  );
}

//顶部蓝色部分
Widget topBlue({double height}) {
  return Align(
    alignment: Alignment.topLeft,
    child: Container(
      height: height,
      decoration: BoxDecoration(
        color: ColorConfig.themeColor,
      ),
    ),
  );
}

//用于页面进入时加载数据的等候过程
Widget loadingData() {
  Widget body;
  if (Platform.isIOS) {
    body = CupertinoActivityIndicator();
  } else if (Platform.isAndroid) {
    body = CircularProgressIndicator();
  } else {
    body = CupertinoActivityIndicator();
  }
  return Center(child: body);
}

BoxDecoration comBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(16.w),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        offset: Offset(0, 6.w),
        blurRadius: 20.w,
        color: Color.fromRGBO(0, 0, 0, 0.08),
      ),
    ],
  );
}

//按钮
Widget eleButton(
    {@required double width,
    @required double height,
    @required String con,
    @required double circular,
    @required Color color,
    @required Function func,
    double size}) {
  if (size == null) {
    size = 32.sp;
  }
  return ElevatedButton(
    onPressed: func != null
        ? () {
            func();
          }
        : null,
    style: ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.only(left: 20.w,right: 20.w)),
      minimumSize: MaterialStateProperty.all(Size(width, height)),
      backgroundColor: MaterialStateProperty.all(color),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(circular),
          ),
        ),
      ),
    ),
    child: Text(
      "$con",
      style: TextStyle(
          fontWeight: FontWeight.w400, fontSize: size, color: Colors.white),
    ),
  );
}

//图片
Stack stackImg(String img, String tips, bool showTips,
    {BoxFit fit = BoxFit.cover, double width, double height, double size}) {
  double w = 300.w;
  double h = 200.w;
  double s = 24.sp;
  double iw = 60.w;
  if (width != null) {
    w = width;
    iw = 120.w;
  }
  if (height != null) {
    h = height;
  }
  if (size != null) {
    s = size;
  }
  return Stack(
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: ExtendedImage.network(
          "$img",
          fit: fit,
          width: w,
          height: h,
          loadStateChanged: (ExtendedImageState state) {
            Image img;
            if (state.extendedImageLoadState == LoadState.failed) {
              img = Image.asset("assets/tabbar_user_no.png", width: iw);
            }
            return img;
          },
        ),
      ),
      showTips == true
          ? Align(
              alignment: Alignment.center,
              child: Container(
                  width: w,
                  height: h,
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$tips',
                        style: TextStyle(
                          fontSize: s,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
            )
          : Text(''),
    ],
  );
}

///上传图片，目前用于地址身份证，支付凭证，收车单，资料
Container containerUploadImg({
  ///图片地址
  @required String img,

  ///上传提示信息
  @required String uploadInfo,

  ///是否显示重新上传
  @required showReload,

  ///点击事件
  @required Function function,

  ///删除图片事件
  Function deleteFunc,

  ///宽度
  double width,

  ///高度
  double height,

  ///外边距
  EdgeInsets margin,

  ///文字大小
  double fontSize,
}) {
  width = width == null ? 502.w : width;
  height = height == null ? 308.w : height;
  margin = margin == null ? EdgeInsets.all(0) : margin;
  fontSize = fontSize == null ? 28.sp : fontSize;
  return Container(
    width: width,
    height: height,
    margin: margin,
    decoration: BoxDecoration(
      color: img == null ? Color(0xffD2E5F9) : Colors.transparent,
      borderRadius: BorderRadius.circular(20.w),
    ),
    child: InkWell(
      onTap: () {
        function();
      },
      child: img == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 120.w,
                ),
                Text(
                  '请$uploadInfo',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                ///图片展示
                Align(
                  alignment: Alignment.topLeft,
                  child: ExtendedImage.network(
                    "$img",
                    fit: BoxFit.fill,
                    width: width,
                    height: height,
                    loadStateChanged: (ExtendedImageState state) {
                      Widget wig;
                      if (state.extendedImageLoadState == LoadState.failed) {
                        wig = Image.asset("assets/tabbar_user_no.png",
                            width: 120.w);
                      }
                      return wig;
                    },
                  ),
                ),

                ///提示重新上传
                showReload == true
                    ? Align(
                        alignment: Alignment.center,
                        child: Container(
                            width: width,
                            height: height,
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '重新$uploadInfo',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )),
                      )
                    : Text(''),

                ///删除图片
                showReload == true && deleteFunc != null
                    ? Positioned(
                        right: 10.w,
                        top: 10.w,
                        child: GestureDetector(
                          onTap: () {
                            deleteFunc();
                          },
                          child: Icon(
                            Icons.cancel_outlined,
                            size: fontSize * 2,
                            color: ColorConfig.cancelColor,
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
    ),
  );
}

///上传图片-第二版
Container uploadImgTouch2({
  ///图片地址
  @required String img,

  ///上传提示信息
  @required String uploadInfo,

  ///是否显示重新上传
  @required showReload,

  ///点击事件
  @required Function function,

  ///删除图片事件
  Function deleteFunc,

  ///宽度
  double width,

  ///高度
  double height,

  ///外边距
  EdgeInsets margin,

  ///文字大小
  double fontSize,
}) {
  width = width == null ? 502.w : width;
  height = height == null ? 308.w : height;
  margin = margin == null ? EdgeInsets.all(0) : margin;
  fontSize = fontSize == null ? 28.sp : fontSize;
  return Container(
    width: width,
    height: height,
    margin: margin,
    decoration: BoxDecoration(
      color: img == null ? Color(0xffD2E5F9) : Colors.transparent,
      borderRadius: BorderRadius.circular(20.w),
    ),
    child: InkWell(
      onTap: () {
        function();
      },
      child: img == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 120.w,
                ),
                Text(
                  '请$uploadInfo',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                ///图片展示
                Align(
                  alignment: Alignment.topLeft,
                  child: ExtendedImage.network(
                    "$img",
                    fit: BoxFit.fill,
                    width: width,
                    height: height,
                    loadStateChanged: (ExtendedImageState state) {
                      Widget wig;
                      if (state.extendedImageLoadState == LoadState.failed) {
                        wig = Container(
                          color: Colors.grey[100],
                          padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                          child: ExtendedImage.asset(
                            "assets/img_logo.png",
                          ),
                        );
                      }
                      return wig;
                    },
                  ),
                ),

                ///图片名称
                if (showReload)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: width,
                      height: height,
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$uploadInfo',
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ///删除图片
                deleteFunc != null
                    ? Positioned(
                        right: 10.w,
                        top: 10.w,
                        child: GestureDetector(
                          onTap: () {
                            KlAlert.showAlert(
                                content: '确认移除该图片?',
                                sureFunc: () {
                                  BuildContext thisContext =
                                      navigatorKey.currentState.context;
                                  MyRoute.router.pop(thisContext);
                                  deleteFunc(); //这个方法最好不要有请求
                                },
                                cancelFunc: () {
                                  BuildContext thisContext =
                                      navigatorKey.currentState.context;
                                  MyRoute.router.pop(thisContext);
                                });
                          },
                          child: Icon(
                            Icons.cancel_outlined,
                            size: fontSize * 2,
                            color: ColorConfig.cancelColor,
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
    ),
  );
}

///关闭键盘
closeBoard({@required BuildContext context}) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus.unfocus();
  }
}


///显示网络图片-封装
showImageNetwork({@required String img,double w,double h}) {
  return ExtendedImage.network(
    img,
    fit: BoxFit.fill,
    cache: true,
    loadStateChanged: (ExtendedImageState state) {
      Widget widget;
      if (state.extendedImageLoadState == LoadState.failed) {
        widget = Container(
          color: Colors.grey[100],
          padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
          child: ExtendedImage.asset(
            "assets/img_logo.png",
            width: w,
            height: h,
          ),
        );
      }
      return widget;
    },
  );
}


///预览图片
previewImages(List imgList,i){
  BuildContext buildContext = navigatorKey.currentState.overlay.context;
  Navigator.push(
    buildContext,
    GradualChangeRoute(
      PhotoPreview(
        galleryItems: imgList,
        defaultImage: i,
      ),
    ),
  );
}