import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/bloc/tab/switch_tag_bloc.dart';
import 'package:tob/bloc/tab/switch_tag_event.dart';
import 'package:tob/bloc/userInfo/user_info_bloc.dart';
import 'package:tob/entity/base_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/main.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/loading.dart';

class ReVerifyPage extends StatefulWidget {
  const ReVerifyPage({Key key}) : super(key: key);

  @override
  _ReVerifyPageState createState() => _ReVerifyPageState();
}

class _ReVerifyPageState extends State<ReVerifyPage> {
  TextEditingController _controller = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  String _smsRequestId = "";
  String _smsBizId = "";

  bool btnSure = false;

  @override
  void initState() {
    super.initState();
    _controller.text = UserInfo.getUserInfo().mobile;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _codeController.dispose();
    Loading.dismiss();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: blueAppbarTitle(title: "重新认证", elevation: 0),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 96.w),
          child: Column(
            children: [
              SizedBox(height: 149.w),
              Text(
                "手机号码验证",
                style: TextStyle(
                    fontSize: 48.sp,
                    height: 1,
                    color: ColorConfig.themeColor,
                    fontWeight: FontWeight.bold),
              ),
              //手机号
              phone(),
              //验证码
              code(),
              //按钮
              btn(),
            ],
          ),
        ),
      ),
    );
  }

  //手机号输入
  phone() {
    return Container(
      margin: EdgeInsets.only(top: 148.w),
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
              controller: _controller,
              keyboardType: TextInputType.phone,
              readOnly: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 25.w),
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
            width: 250.w,
            child: TextField(
              maxLength: 6,
              controller: _codeController,
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                if (value.length == 6 && _controller.text.length == 11) {
                  btnSure = true;
                } else {
                  btnSure = false;
                }
                setState(() {});
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 25.w),
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
                Loading.show();
                Http.getInstance()
                    .smsSend(_controller.text, "login")
                    .then((value) {
                  startTime();
                  _smsRequestId = value.requestId;
                  _smsBizId = value.bizId;
                }).whenComplete(() => {Loading.dismiss()});
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

  btn() {
    return Container(
      margin: EdgeInsets.only(top: 50.w),
      child: eleButton(
          width: 513.w,
          height: 80.w,
          con: "重新认证",
          circular: 40.w,
          color: ColorConfig.themeColor,
          func: () async{
            if ((_smsRequestId == null || _smsRequestId.length <= 0) ||
                (_smsBizId == null || _smsBizId.length <= 0)) {
              Loading.toast(msg: '请先获取验证码');
              return false;
            }
            
            if(_codeController.text.length<=0){
              Loading.toast(msg: "请输入验证码");
              return false;
            }
            
            
            BaseEntity baseEntity= await Http.getInstance().smsVerify(_controller.text, _codeController.text, _smsBizId);
            if(baseEntity.code!=200){
              return false;
            }
            Loading.show();
            Http.getInstance().clearBusiness().then((value) {
              Loading.toast(msg: '清除认证成功！');
              Http.getInstance().getUserInfo().then((userInfo) {

                if (mounted) {
                  UserInfo.setUserInfo(userInfo);
                  BuildContext thisContext = navigatorKey.currentState.context;
                  BlocProvider.of<UserInfoBloc>(thisContext)
                      .add(UserStateEvent());
                  Future.delayed(Duration(seconds: 2)).then((value) {
                    if(mounted){
                      Navigator.of(context)
                          .popUntil((route) => route.settings.name == Routes.root);
                      BlocProvider.of<SwitchTagBloc>(context).add(
                        JustSwitchTagEvent(3, toOrder: false),
                      );
                    }
                  });
                }
              });
            }).whenComplete(() => Loading.dismiss());
          }),
    );
  }
}
