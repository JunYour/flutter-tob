import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import "package:http_parser/src/media_type.dart" show MediaType;
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tob/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImgUpload extends Dialog {
  final Function func;

  ImgUpload({@required this.func});

  static upload({@required Function func}) {
    BuildContext _thisContext = navigatorKey.currentState.overlay.context;
    showDialog(
      context: _thisContext,
      builder: (context) {
        return ImgUpload(func: func);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //自定义弹框内容
    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 750.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.w),
                  topRight: Radius.circular(16.w),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      _openGallery(context, this.func);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 10),
                      child: Center(child: Text("相册")),
                      height: 50,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _takePhoto(context, this.func);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 10),
                      child: Center(child: Text("拍照")),
                      height: 50,
                    ),
                  ),
                  Container(
                    height: 5,
                    color: Colors.grey,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text("取消"),
                      ),
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

// 图片压缩
Future<File> imageHandleWithImage(
    PickedFile image, int quality, int percentage) async {
  return await FlutterNativeImage.compressImage(image.path,quality: quality,
       percentage: percentage);
}

// 相册
_openGallery(BuildContext context, Function func) async {
  Navigator.pop(context);

  final _picker = ImagePicker();
  var image = await _picker.getImage(source: ImageSource.gallery);
  if (image != null) {
    int index = image.path.lastIndexOf(".");
    if (index == -1) {
      return Future.error("Known file type!");
    }
    String suffix = image.path.substring(index + 1)?.toLowerCase();
    MediaType mediaType;
    if (suffix == "jpg" ||
        suffix == "png" ||
        suffix == "gif" ||
        suffix == "bmp") {
      mediaType = MediaType("image", suffix);
    }
    var file = await MultipartFile.fromFile(image.path,
        filename: image.path, contentType: mediaType);
    var fileSize = file.length / 1024;
    int size = int.parse(fileSize.toStringAsFixed(0));
    print(size);
    if(size > 10000){
      File resultImage = await imageHandleWithImage(image, 70, 50);
      func(resultImage);
    } else if (size > 4000) {
      File resultImage = await imageHandleWithImage(image, 80, 50);
      func(resultImage);
    } else if (size > 2000) {
      File resultImage = await imageHandleWithImage(image, 90, 50);
      func(resultImage);
    } else {
      // File resultImage = await imageHandleWithImage(image, 100, 100);
      func(File(image.path));
    }
  }
}

// 拍照
_takePhoto(BuildContext context, Function func) async {
  Navigator.pop(context);
  final _picker = ImagePicker();

  PickedFile image = await _picker.getImage(source: ImageSource.camera);
  if (image != null) {
    int index = image.path.lastIndexOf(".");
    if (index == -1) {
      return Future.error("Known file type!");
    }
    String suffix = image.path.substring(index + 1)?.toLowerCase();
    MediaType mediaType;
    if (suffix == "jpg" ||
        suffix == "png" ||
        suffix == "gif" ||
        suffix == "bmp") {
      mediaType = MediaType("image", suffix);
    }
    var file = await MultipartFile.fromFile(image.path,
        filename: image.path, contentType: mediaType);
    var fileSize = file.length / 1024;
    int size = int.parse(fileSize.toStringAsFixed(0));
    if(size > 10000){
      File resultImage = await imageHandleWithImage(image, 70, 50);
      func(resultImage);
    } else if (size > 4000) {
      File resultImage = await imageHandleWithImage(image, 80, 50);
      func(resultImage);
    } else if (size > 2000) {
      File resultImage = await imageHandleWithImage(image, 90, 50);
      func(resultImage);
    } else {
      // File resultImage = await imageHandleWithImage(image, 100, 100);
      func(File(image.path));
    }
  }
}
