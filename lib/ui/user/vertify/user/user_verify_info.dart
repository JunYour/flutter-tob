import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/entity/user_info_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/widget/common_widget.dart';

import '../verify_common.dart';


class UserVerifyInfoPage extends StatefulWidget {
  const UserVerifyInfoPage({Key key}) : super(key: key);

  @override
  _UserVerifyInfoPageState createState() => _UserVerifyInfoPageState();
}

class _UserVerifyInfoPageState extends State<UserVerifyInfoPage> {

  UserInfoEntity _userInfoEntity;

  @override
  void initState() {
    super.initState();
    _userInfoEntity = UserInfo.getUserInfo();


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: blueAppbarTitle(title: "实名认证",elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //  实名认证中心
            word(),
            //  信息
            info(),
          ],
        ),
      ),
    );
  }

  word() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 30.w, top: 45.w, bottom: 20.w),
      child: Text(
        "实名认证中心",
        style: TextStyle(
          fontSize: 36.sp,
          fontWeight: FontWeight.bold,
          color: ColorConfig.themeColor,
          height: 1,
        ),
      ),
    );
  }

  info() {
    return Column(
      children: [
        //证件信息文字
        cardInfo(),
        //信息列表
        messageInfo(title: "姓名", content: "${_userInfoEntity?.username??''}",right: 30.w),
        messageInfo(title: "性别", content: sex(),right: 30.w),
        messageInfo(title: "证件类型", content: carType(),right: 30.w),
        messageInfo(title: "证件号", content: "${_userInfoEntity?.idCard??''}",right: 30.w),
        messageInfo(title: "证件有效期", content: "${_userInfoEntity?.idCardDate??''}",right: 30.w),
        // messageInfo(title: "身份证照片", content: "${_userInfoEntity?.username??''}"),
      ],
    );
  }

  cardInfo() {
    return Container(
      height: 40.w,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 30.w, right: 30.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.w,
            color: Color(0xff999999),
          ),
        ),
      ),
      child: Text(
        "证件信息",
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          height: 1,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  String carType() {
    String typeName = "其他";
    if(_userInfoEntity.cardType==1){
      typeName = "身份证";
    }
    return typeName;
  }

  String sex() {
    String sex;
    if(_userInfoEntity.gender == "1"){
      sex = "保密";
    }
    if(_userInfoEntity.gender == "2"){
      sex = "男";
    }
    if(_userInfoEntity.gender == "3"){
      sex = "女";
    }
    return sex;
  }
}
