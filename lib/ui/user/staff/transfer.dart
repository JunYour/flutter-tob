import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/bloc/tab/switch_tag_bloc.dart';
import 'package:tob/bloc/tab/switch_tag_event.dart';
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

class StaffTransferPage extends StatefulWidget {
  final int id;

  const StaffTransferPage({Key key, @required this.id}) : super(key: key);

  @override
  _StaffTransferPageState createState() => _StaffTransferPageState();
}

class _StaffTransferPageState extends State<StaffTransferPage> {
  bool btnSure = false;
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  String _smsRequestId = "";
  String _smsBizId = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _codeController.dispose();
    _phoneController.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        closeBoard(context: context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("权限转让"),
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
      ),
    );
  }

  //文字
  word() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 184.w, bottom: 98.w),
      child: Text(
        "手机号码验证",
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
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                checkBtnSure();
              },
              decoration: InputDecoration(
                counterText: "",
                //输入框内边距
                // contentPadding: EdgeInsets.symmetric(vertical: 20.w),
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
                checkBtnSure();
              },
              decoration: InputDecoration(
                counterText: "",
                //输入框内边距
                // contentPadding: EdgeInsets.symmetric(vertical: 20.w),
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
                Loading.show(status: "手机号验证中");
                Http.getInstance().phoneVerify(_phoneController.text,userId: UserInfo.getUserInfoId()).then((value){
                  Loading.show(status: "短信发送中");
                  Http.getInstance()
                      .smsSend(_phoneController.text, "authMove")
                      .then((value) {
                    startTime();
                    _smsRequestId = value.requestId;
                    _smsBizId = value.bizId;
                  }).whenComplete(() => {Loading.dismiss()});
                }).whenComplete(() => Loading.dismiss());



              }
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

  checkBtnSure() {
    if (_phoneController.text.length == 11 &&
        _codeController.text.length == 6) {
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
        con: '确认转让',
        color: btnSure ? ColorConfig.themeColor : ColorConfig.themeColor[100],
        circular: 40.w,
        height: 80.w,
        func: btnSure
            ? () {
                if (_smsBizId == null || _smsRequestId == null) {
                  Loading.toast(msg: "请先获取验证码");
                  return false;
                }
                KlAlert.showAlert(content: "确定转让权限吗？", sureFunc: (){
                  Loading.show();
                  Http.getInstance()
                      .smsVerify(
                      _phoneController.text, _codeController.text, _smsBizId)
                      .then((value) async {
                    Http.getInstance().staffTransfer(id: widget.id).then((value) {
                      Loading.toast(msg: "转让成功",maskType: EasyLoadingMaskType.clear);
                      Future.delayed(Duration(seconds: 2)).then((value) {
                        if (mounted) {
                          //获取用户信息
                          Http.getInstance().getUserInfo().then((userInfo) {
                            UserInfo.setUserInfo(userInfo);
                            BlocProvider.of<UserInfoBloc>(context)
                                .add(UserStateEvent());
                            Navigator.of(context)
                                .popUntil((route) => route.settings.name == Routes.root);
                            BlocProvider.of<SwitchTagBloc>(context)
                                .add(JustSwitchTagEvent(3, toOrder: false));
                          }).catchError((err) {
                            BlocProvider.of<SwitchTagBloc>(context)
                                .add(JustSwitchTagEvent(3, toOrder: false));
                          });
                        }
                      });
                    });
                  }).whenComplete(() => Loading.dismiss());
                },cancelFunc: (){
                  MyRoute.router.pop(context);
                });


              }
            : null,
      ),
    );
  }
}
