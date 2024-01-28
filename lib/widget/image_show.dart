import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/widget/common_widget.dart';

typedef PageChanged = void Function(int index);

class PhotoPreview extends StatefulWidget {
  final List galleryItems; //图片列表
  final int defaultImage; //默认第几张
  final PageChanged pageChanged; //切换图片回调
  final Axis direction; //图片查看方向
  final Decoration decoration; //背景设计
  final String title;//页面标题

  PhotoPreview(
      {this.galleryItems,
        this.defaultImage = 1,
        this.pageChanged,
        this.direction = Axis.horizontal,
        this.decoration,
      this.title})
      : assert(galleryItems != null);

  @override
  _PhotoPreviewState createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview> {
  int tempSelect;

  @override
  void initState() {
    super.initState();
    tempSelect = widget.defaultImage + 1;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.title !=null){
      return
        Scaffold(
          appBar: commonAppbarTitle(title: widget.title),
          body: buildStack(),

      );
    }
    return SafeArea(
      child: Scaffold(
        body: buildStack(),
      ),
    );
  }

  Stack buildStack() {
    return Stack(
        children: [
          Container(
            color: Colors.black,
            width: 750.w,
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(widget.galleryItems[index]),
                    onTapDown: (context, details, controllerValue) {
                      Navigator.pop(context, {"index": index});
                    },
                    maxScale: PhotoViewComputedScale.contained * 2,
                    minScale: PhotoViewComputedScale.contained * 0.1,);
              },
              scrollDirection: widget.direction,
              itemCount: widget.galleryItems.length,
              backgroundDecoration:
              widget.decoration ?? BoxDecoration(color: Colors.black),
              pageController: PageController(initialPage: widget.defaultImage),
              loadingBuilder: (context, event) {
                Widget body;
                if (Platform.isIOS) {
                  body = CupertinoActivityIndicator();
                } else if (Platform.isAndroid) {
                  body = CircularProgressIndicator();
                } else {
                  body = CupertinoActivityIndicator();
                }
                return Center(
                  child: body,
                );
              },
              onPageChanged: (index) => setState(
                    () {
                  tempSelect = index + 1;
                  if (widget.pageChanged != null) {
                    widget.pageChanged(index);
                  }
                },
              ),
            ),
          ),
          Offstage(
            offstage: widget.galleryItems.length>1?false:true,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(right: 30.w,top: 30.w),
                child: Text('$tempSelect/${widget.galleryItems.length}',style: TextStyle(
                    fontSize: 28.sp,
                    color: Colors.white
                ),),
              ),
            ),
          ),
        ],
      );
  }
}

class GradualChangeRoute extends PageRouteBuilder {
  final Widget widget;

  GradualChangeRoute(this.widget)
      : super(
    transitionDuration: Duration(milliseconds: 100),
    pageBuilder: (
        BuildContext context,
        Animation<double> animation1,
        Animation<double> animation2,
        ) {
      return widget;
    },
    transitionsBuilder: (BuildContext context,
        Animation<double> animation1,
        Animation<double> animation2,
        Widget child) {
      //渐隐渐变效果
      return FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animation1, curve: Curves.fastOutSlowIn)),
        child: child,
      );
    },
  );
}
