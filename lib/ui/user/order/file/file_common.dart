import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/main.dart';
import 'package:tob/network/http.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/image_show.dart';
import 'package:tob/widget/image_upload.dart';
import 'package:tob/widget/loading.dart';



//公共方法封装,标题->组件(内容)
Container conFileContainer({String title, dynamic wid,bool widget}) {
  TextStyle style = TextStyle(
    color: ColorConfig.fontColorBlack,
    fontSize: 32.sp,
    fontWeight: FontWeight.w500,
  );
  return Container(
    width: double.infinity,
    height: 80.w,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 2.w,
          color: ColorConfig.themeColor[100],
        ),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text('$title',style: style,),
        ),
        Expanded(
          child:widget==true? Container(
            child: wid,
          ):Container(
            alignment: Alignment.centerRight,
            child: Text(
              wid,
              style: style,
            ),
          ),
        ),
      ],
    ),
  );
}

//封装公共输入框
TextField comTextField({@required TextEditingController controller,@required bool readOnly,TextInputType textInputType,TextInputAction textInputAction,int maxLength}){
  return TextField(
    controller: TextEditingController.fromValue(
      TextEditingValue(
        text:
        '${controller.text == null ? "" : controller.text}', //判断keyword是否为空
        // 保持光标在最后
        selection: TextSelection.fromPosition(
          TextPosition(
              affinity: TextAffinity.downstream,
              offset: '${controller.text}'.length),
        ),
      ),
    ),
    readOnly: readOnly ? true : false,
    onChanged: (value){
      controller.text = value;
    },
    textAlign: TextAlign.right,
    scrollPadding: EdgeInsets.zero,
    keyboardType: textInputType,
    textInputAction: textInputAction,
    maxLength: maxLength,
    decoration: InputDecoration(
      hintText: '请填写',
      border: InputBorder.none,
      counterText: '',
      contentPadding: EdgeInsets.only(bottom: 15.w),
      labelStyle: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w500,
        color: ColorConfig.fontColorBlack,
      ),
    ),
  );
}

//图片预览
void imgPreview(List list, int index,{String title}) {
  BuildContext _context = navigatorKey.currentState.overlay.context;
  Navigator.push(
    _context,
    GradualChangeRoute(
      PhotoPreview(
        title: title,
        galleryItems: list,
        defaultImage: index,
      ),
    ),
  );
}

//上传图片接口
void apiUploadImg({@required String type, Function func}) {
  BuildContext _context = navigatorKey.currentState.overlay.context;
  closeBoard(context: _context);
  ImgUpload.upload(
    func: (image) {
      Loading.show();
      Http.getInstance().imgUpload(image, type).then(
            (value) {
          if (func != null) {
            func(value.fileUrl);
          }
        },
      ).whenComplete(() {
        Loading.dismiss();
      });
    },
  );
}

//打回信息
Offstage comOffstage({@required bool offstage, String errorText}) {
  return Offstage(
    offstage: offstage,
    child: Container(
      width: 300.w,
      child: Text(
        '$errorText',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 28.sp,
          color: Colors.red[300],
        ),
      ),
    ),
  );
}

//未上传图片时的说明文字
imgUp(String s) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.add,
        color: Colors.white,
        size: 120.w,
      ),
      Text(
        '$s',
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    ],
  );
}

//公共模块
placeColumn({
  List<Widget> widgets,
  @required String text,
  Widget widget,
  bool showLine = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text + ":",
              style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorConfig.themeColor),
            ),
            SizedBox(
              height: 10.w,
            ),
            if (widgets != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: widgets,
              ),
            if (widget != null) widget,
          ],
        ),
      ),
      Divider(),
    ],
  );
}


