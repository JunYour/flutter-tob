import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/bloc/userInfo/user_info_bloc.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/util/common_util.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/loading.dart';

class UpdPhonePage extends StatefulWidget {
  const UpdPhonePage({Key key}) : super(key: key);

  @override
  _UpdPhonePageState createState() => _UpdPhonePageState();
}

class _UpdPhonePageState extends State<UpdPhonePage> {
  bool btnSure = false;
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();

  //短信的标识
  String bizId;
  Timer _timer;
  int _codeCountdown = 60;

  startTime() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      _codeCountdown--;
      if (_codeCountdown == 0) {
        _codeCountdown = 60;
        _timer.cancel();
      } else {
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _phoneController.dispose();
    _codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("更换手机号"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 99.w, right: 96.w),
          child: Column(
            children: [
              //文字
              word(),
              //手机号
              phone(),
              //验证码
              code(),
              //  提交按钮
              sub(),
            ],
          ),
        ),
      ),
    );
  }

  //文字
  word() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 184.w, bottom: 98.w),
      child: Text(
        "修改手机号",
        style: TextStyle(
          fontSize: 48.sp,
          fontWeight: FontWeight.bold,
          height: 1,
          color: ColorConfig.themeColor,
        ),
      ),
    );
  }

  //手机号输入
  phone() {
    return Container(
      padding: EdgeInsets.only(left: 36.w, right: 36.w),
      width: 556.w,
      height: 75.w,
      decoration: BoxDecoration(
        border: Border.all(color: ColorConfig.themeColor, width: 2.w),
        borderRadius: BorderRadius.all(
          Radius.circular(36.w),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.phone_android_sharp,
              color: ColorConfig.themeColor, size: 34.w),
          SizedBox(width: 10.w),
          Container(
            width: 400.w,
            child: TextField(
              maxLength: 11,
              controller: _phoneController,
              onChanged: (value) {
                checkBtn();
              },
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                counterText: "",
                //输入框内边距
                contentPadding: EdgeInsets.only(bottom: 20.h),
                //输入框内容提示
                hintText: '请输入手机号',
                hintStyle: TextStyle(
                  fontSize: 24.w,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF999999),
                ),
                //输入框边距线
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //验证码
  code() {
    return Container(
      margin: EdgeInsets.only(top: 30.w),
      padding: EdgeInsets.only(left: 36.w, right: 36.w),
      width: 556.w,
      height: 75.w,
      decoration: BoxDecoration(
        border: Border.all(color: ColorConfig.themeColor, width: 2.w),
        borderRadius: BorderRadius.all(
          Radius.circular(36.w),
        ),
      ),
      child: Row(
        children: [
          Image.asset('assets/password.png', width: 34.w),
          SizedBox(width: 10.w),
          Container(
            width: 270.w,
            child: TextField(
              maxLength: 6,
              controller: _codeController,
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                checkBtn();
              },
              decoration: InputDecoration(
                counterText: "",
                //输入框内边距
                contentPadding: EdgeInsets.only(bottom: 20.h),
                //输入框内容提示
                hintText: '请输入验证码',
                hintStyle: TextStyle(
                  fontSize: 24.w,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF999999),
                ),
                //输入框边距线
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Container(
            height: 41.w,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  width: 1.w,
                  color: Color(0xff333333),
                ),
              ),
            ),
          ),
          SizedBox(width: 15.w),
          GestureDetector(
            onTap: () {
              if (_codeCountdown != 60) {
                return false;
              }
              if (_phoneController.text.length <= 0) {
                Loading.toast(msg: "请输入手机号");
                return false;
              }
              if (!CommonUtil.isChinaPhoneLegal(_phoneController.text)) {
                Loading.toast(msg: "请输入正确的手机号");
                return false;
              }
              Loading.show();
              Http.getInstance()
                  .smsSend(_phoneController.text, 'modifyPhone')
                  .then((value) {
                    bizId = value.bizId;
                startTime();
              }).whenComplete(() => Loading.dismiss());
            },
            child: Container(
              width: 130.w,
              alignment: Alignment.center,
              child: Text(
                _codeCountdown == 60 ? "获取验证码" : "${_codeCountdown.toString()}",
                style: TextStyle(
                    fontSize: 24.sp,
                    color: ColorConfig.themeColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkBtn() {
    if (CommonUtil.isChinaPhoneLegal(_phoneController.text) &&
        _codeController.text.trim().length >= 6) {
      btnSure = true;
    } else {
      btnSure = false;
    }
    setState(() {});
  }

  sub() {
    return Container(
      margin: EdgeInsets.only(top: 122.w),
      child: eleButton(
        width: 513.w,
        con: '确认更改',
        color: btnSure ? ColorConfig.themeColor : ColorConfig.themeColor[100],
        circular: 40.w,
        height: 80.w,
        func: btnSure
            ? () {
                if (bizId == null) {
                  Loading.toast(msg: "请先获取验证码");
                  return false;
                }
                btnSure = false;
                setState(() {});
                Loading.show();
                Http.getInstance()
                    .smsVerify(
                        _phoneController.text, _codeController.text, bizId)
                    .then((value) {
                  Loading.show();
                  Http.getInstance()
                      .updPhone(_phoneController.text)
                      .then((value) {
                    Loading.toast(msg: "修改成功！");
                    //获取用户信息
                    Http.getInstance().getUserInfo().then((userInfo) {
                      UserInfo.setUserInfo(userInfo);
                      BlocProvider.of<UserInfoBloc>(context).add(UserStateEvent());
                      MyRoute.router.pop(context);
                    }).catchError((err){
                      MyRoute.router.pop(context);
                    });
                  }).catchError((err) {
                    btnSure = true;
                    setState(() {});
                  }).whenComplete(() => Loading.dismiss());
                }).catchError((err) {
                  btnSure = true;
                  setState(() {});
                }).whenComplete(() => Loading.dismiss());
              }
            : null,
      ),
    );
  }
}
