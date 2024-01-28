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
import 'package:tob/route/routes.dart';
import 'package:tob/util/common_util.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';
import '../../main.dart';
import 'login_top.dart';

class PassRegisterPage extends StatefulWidget {
  final int type;

  PassRegisterPage({@required this.type});

  @override
  _PassRegisterPageState createState() => _PassRegisterPageState();
}

class _PassRegisterPageState extends State<PassRegisterPage> {
  int _type = 0; //类型,0是注册账号,1是找回密码
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  TextEditingController _passNewController = new TextEditingController();
  TextEditingController _passConfirmController = new TextEditingController();
  bool btnSure = false;
  String _smsRequestId = "";
  String _smsBizId = "";

  Timer _timer;
  int _codeCountdown = 60;

  startTime() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      _codeCountdown--;
      if (_codeCountdown == 0) {
        _codeCountdown = 60;
        _timer.cancel();
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _type = widget.type;
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    _passNewController.dispose();
    _passConfirmController.dispose();
    Loading.dismiss();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeBoard(context: context);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // 顶部
              stackWidget(context: context, text: _type == 0 ? "注册账号" : "找回密码"),
              phone(),
              code(),
              passNew(),
              passConfirm(),
              SizedBox(
                height: 108.w,
              ),
              loginBtn(),
            ],
          ),
        ),
      ),
    );
  }

  //手机号输入
  phone() {
    return Container(
      margin: EdgeInsets.only(top: 131.w),
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
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                checkBtn();
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                counterText: "",
                //输入框内边距
                // contentPadding: EdgeInsets.symmetric(vertical: 20.w),
                contentPadding: EdgeInsets.only(bottom: 25.w),
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

  ///验证码
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
            width: 250.w,
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
                // contentPadding: EdgeInsets.symmetric(vertical: 20.w),
                contentPadding: EdgeInsets.only(bottom: 25.w),
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
          InkWell(
            onTap: () {
              if (_codeCountdown == 60) {
                FocusScope.of(context).requestFocus(FocusNode());
                _smsRequestId = "";
                _smsBizId = "";
                if (_phoneController.text.isEmpty) {
                  KlAlert.showAlert(
                      content: "请输入手机号",
                      sureFunc: () {
                        MyRoute.router.pop(context);
                      });
                  return false;
                }
                if (!CommonUtil.isChinaPhoneLegal(_phoneController.text)) {
                  KlAlert.showAlert(
                      content: "请输入正确的手机号",
                      sureFunc: () {
                        MyRoute.router.pop(context);
                      });
                  return false;
                }

                if (_type == 0) {
                  //注册
                  btnSure = false;
                  setState(() {});
                  Loading.show();
                  Http.getInstance()
                      .smsSend(_phoneController.text, "register")
                      .then((value) {
                    startTime();
                    _smsRequestId = value.requestId;
                    _smsBizId = value.bizId;
                  }).catchError((err) {
                    btnSure = false;
                    setState(() {});
                  }).whenComplete(() => {Loading.dismiss()});
                } else {
                  btnSure = false;
                  setState(() {});
                  Loading.show();
                  //修改密码
                  Http.getInstance()
                      .phoneVerify(_phoneController.text)
                      .then((value) {
                    Loading.show();
                    Http.getInstance()
                        .smsSend(_phoneController.text, "modifyPhone")
                        .then((value) {
                      startTime();
                      _smsRequestId = value.requestId;
                      _smsBizId = value.bizId;
                    }).catchError((err) {
                      btnSure = false;
                      setState(() {});
                    }).whenComplete(() => {Loading.dismiss()});
                  }).catchError((err) {
                    btnSure = false;
                    setState(() {});
                  }).whenComplete(() => {Loading.dismiss()});
                }
              }
            },
            child: Container(
              width: 150.w,
              alignment: Alignment.center,
              child: Text(
                _codeCountdown == 60
                    ? "获取验证码"
                    : "${_codeCountdown.toString()}s",
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

  ///按钮
  loginBtn() {
    return ElevatedButton(
      onPressed: btnSure
          ? () {
              if (_smsBizId.isEmpty || _smsRequestId.isEmpty) {
                KlAlert.showAlert(
                    content: "请获取验证码",
                    sureFunc: () {
                      MyRoute.router.pop(context);
                    });
                return false;
              }
              Loading.show();
              Http.getInstance()
                  .smsVerify(
                      _phoneController.text, _codeController.text, _smsBizId)
                  .then((value) async {
                if (_type == 0) {
                  //注册
                  bool enabled = await jpush.isNotificationEnabled();
                  if (enabled) {
                    jpush.getRegistrationID().then((value) {
                      //获取到了极光的id
                      Http.getInstance()
                          .register(
                              _phoneController.text,
                              _passNewController.text,
                              _passConfirmController.text,
                              value)
                          .then((value) {
                        UserInfo.setUserInfo(value);
                        BlocProvider.of<UserInfoBloc>(context)
                            .add(UserStateEvent());
                        MyRoute.router.navigateTo(context, Routes.home,
                            replace: true, clearStack: true);
                      }).whenComplete(() => {Loading.dismiss()});
                    }).catchError((error) {
                      //未获取到极光的id
                      Http.getInstance()
                          .register(
                              _phoneController.text,
                              _passNewController.text,
                              _passConfirmController.text,
                              '-')
                          .then((value) {
                        UserInfo.setUserInfo(value);
                        BlocProvider.of<UserInfoBloc>(context)
                            .add(UserStateEvent());
                        MyRoute.router.navigateTo(context, Routes.home,
                            replace: true, clearStack: true);
                      }).whenComplete(() => {Loading.dismiss()});
                    });
                  } else {
                    Http.getInstance()
                        .register(
                            _phoneController.text,
                            _passNewController.text,
                            _passConfirmController.text,
                            '-')
                        .then((value) {
                      UserInfo.setUserInfo(value);
                      BlocProvider.of<UserInfoBloc>(context)
                          .add(UserStateEvent());
                      MyRoute.router.navigateTo(context, Routes.home,
                          replace: true, clearStack: true);
                    }).whenComplete(() => {Loading.dismiss()});
                  }
                } else {
                  // 找回密码
                  bool enabled = await jpush.isNotificationEnabled();
                  if (enabled) {
                    jpush.getRegistrationID().then((value) {
                      //获取到了极光的id
                      Http.getInstance()
                          .findPass(
                              _phoneController.text,
                              _passNewController.text,
                              _passConfirmController.text,
                              value)
                          .then((value) {
                        UserInfo.setUserInfo(value);
                        BlocProvider.of<UserInfoBloc>(context)
                            .add(UserStateEvent());
                        MyRoute.router.navigateTo(context, Routes.home,
                            replace: true, clearStack: true);
                      }).whenComplete(() => {Loading.dismiss()});
                    }).catchError((error) {
                      //未获取到极光的id
                      Http.getInstance()
                          .findPass(
                              _phoneController.text,
                              _passNewController.text,
                              _passConfirmController.text,
                              '-')
                          .then((value) {
                        UserInfo.setUserInfo(value);
                        BlocProvider.of<UserInfoBloc>(context)
                            .add(UserStateEvent());
                        MyRoute.router.navigateTo(context, Routes.home,
                            replace: true, clearStack: true);
                      }).whenComplete(() => {Loading.dismiss()});
                    });
                  } else {
                    Http.getInstance()
                        .findPass(
                            _phoneController.text,
                            _passNewController.text,
                            _passConfirmController.text,
                            '-')
                        .then((value) {
                      UserInfo.setUserInfo(value);
                      BlocProvider.of<UserInfoBloc>(context)
                          .add(UserStateEvent());
                      MyRoute.router.navigateTo(context, Routes.home,
                          replace: true, clearStack: true);
                    }).whenComplete(() => {Loading.dismiss()});
                  }
                }
              }).whenComplete(() => Loading.dismiss());
            }
          : null,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(513.w, 80.w)),
        backgroundColor: MaterialStateProperty.all(
            btnSure ? ColorConfig.themeColor : ColorConfig.themeColor[100]),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(40.w),
            ),
          ),
        ),
      ),
      child: Text(
        _type == 0 ? "注册" : "找回密码",
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 32.sp, color: Colors.white),
      ),
    );
  }

  ///密码
  passNew() {
    return Container(
      margin: EdgeInsets.only(top: 30.w),
      padding: EdgeInsets.only(left: 36.w, right: 36.w),
      width: 556.w,
      height: 75.w,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorConfig.themeColor, width: 2.w),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_rounded, color: ColorConfig.themeColor, size: 34.w),
          SizedBox(width: 10.w),
          Container(
            width: 400.w,
            child: TextField(
              controller: _passNewController,
              onChanged: (value) {
                checkBtn();
              },
              textInputAction: TextInputAction.next,
              obscureText: true,
              decoration: InputDecoration(
                counterText: "",
                //输入框内边距
                // contentPadding: EdgeInsets.symmetric(vertical: 20.w),
                contentPadding: EdgeInsets.only(bottom: 25.w),
                //输入框内容提示
                hintText: '请输入密码',
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

  ///确认密码
  passConfirm() {
    return Container(
      margin: EdgeInsets.only(top: 30.w),
      padding: EdgeInsets.only(left: 36.w, right: 36.w),
      width: 556.w,
      height: 75.w,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorConfig.themeColor, width: 2.w),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_rounded, color: ColorConfig.themeColor, size: 34.w),
          SizedBox(width: 10.w),
          Container(
            width: 400.w,
            child: TextField(
              controller: _passConfirmController,
              onChanged: (value) {
                checkBtn();
              },
              textInputAction: TextInputAction.done,
              obscureText: true,
              decoration: InputDecoration(
                counterText: "",
                //输入框内边距
                // contentPadding: EdgeInsets.symmetric(vertical: 20.w),
                contentPadding: EdgeInsets.only(bottom: 25.w),
                //输入框内容提示
                hintText: '请再次输入密码',
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

  //检查按钮是否可用
  checkBtn() {
    if (_phoneController.text.length == 11 &&
        _codeController.text.length == 6 &&
        _passConfirmController.text.length >= 6 &&
        _passConfirmController.text.length >= 6) {
      btnSure = true;
    } else {
      btnSure = false;
    }
    setState(() {});
  }
}
