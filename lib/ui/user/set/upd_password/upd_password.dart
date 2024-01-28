import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';

class UpdPasswordPage extends StatefulWidget {
  const UpdPasswordPage({Key key}) : super(key: key);

  @override
  _UpdPasswordPageState createState() => _UpdPasswordPageState();
}

class _UpdPasswordPageState extends State<UpdPasswordPage> {
  TextEditingController _passOldController = new TextEditingController();
  TextEditingController _passNewController = new TextEditingController();
  TextEditingController _passConfirmController = new TextEditingController();
  bool _oldObscure = false;
  bool _newObscure = false;
  bool _confirmObscure = false;

  @override
  void dispose() {
    super.dispose();
    _passOldController.dispose();
    _passNewController.dispose();
    _passConfirmController.dispose();
    Loading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeBoard(context: context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("修改密码"),
          centerTitle: true,
          brightness: Brightness.dark,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 99.w, right: 96.w),
            child: Column(
              children: [
                //文字
                word(),
                //  旧密码
                password(),
                //  新密码
                passNew(),
                //  确认新密码
                passConfirm(),
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
      margin: EdgeInsets.only(top: 184.w, bottom: 88.w),
      child: Text(
        "修改密码",
        style: TextStyle(
          fontSize: 48.sp,
          fontWeight: FontWeight.bold,
          height: 1,
          color: ColorConfig.themeColor,
        ),
      ),
    );
  }

  //密码
  password() {
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
          Expanded(
            child: TextField(
              controller: _passOldController,
              obscureText: !_oldObscure,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 25.w),
                counterText: "",
                //输入框内边距
                // contentPadding: EdgeInsets.symmetric(vertical: 20.w),
                //输入框内容提示
                hintText: '请输入原密码',
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
          GestureDetector(
            onTap: () {
              _oldObscure = !_oldObscure;
              setState(() {});
            },
            child: _oldObscure
                ? Icon(Icons.remove_red_eye_outlined,
                    color: ColorConfig.themeColor)
                : Icon(Icons.remove_red_eye, color: ColorConfig.themeColor),
          ),
        ],
      ),
    );
  }

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
          Expanded(
            child: TextField(
              controller: _passNewController,
              obscureText: !_newObscure,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 25.w),
                counterText: "",
                //输入框内边距
                // contentPadding: EdgeInsets.symmetric(vertical: 20.w),
                //输入框内容提示
                hintText: '请输入新密码',
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
          GestureDetector(
            onTap: () {
              _newObscure = !_newObscure;
              setState(() {});
            },
            child: _newObscure
                ? Icon(Icons.remove_red_eye_outlined,
                color: ColorConfig.themeColor)
                : Icon(Icons.remove_red_eye, color: ColorConfig.themeColor),
          ),
        ],
      ),
    );
  }

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
          Expanded(
            child: TextField(
              controller: _passConfirmController,
              obscureText: !_confirmObscure,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 25.w),
                counterText: "",
                //输入框内边距
                // contentPadding: EdgeInsets.symmetric(vertical: 20.w),
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
          GestureDetector(
            onTap: () {
              _confirmObscure = !_confirmObscure;
              setState(() {});
            },
            child: _confirmObscure
                ? Icon(Icons.remove_red_eye_outlined,
                color: ColorConfig.themeColor)
                : Icon(Icons.remove_red_eye, color: ColorConfig.themeColor),
          ),
        ],
      ),
    );
  }

  sub() {
    return Container(
      margin: EdgeInsets.only(top: 122.w),
      child: eleButton(
        width: 513.w,
        con: '确认更改',
        color: ColorConfig.themeColor,
        circular: 40.w,
        height: 80.w,
        func: () {
          closeBoard(context: context);
          if (_passOldController.text.length <= 0) {
            Loading.toast(msg: "请输入原密码");
            return false;
          }
          if (_passNewController.text.length <= 0) {
            Loading.toast(msg: "请输入新密码");
            return false;
          }
          if (_passConfirmController.text.length <= 0) {
            Loading.toast(msg: "请输入确认密码");
            return false;
          }
          if (_passNewController.text != _passConfirmController.text) {
            Loading.toast(msg: "两次密码输入不一致");
            return false;
          }

          KlAlert.showAlert(
              content: "确认修改密码?",
              sureFunc: () {
                Loading.show();
                Http.getInstance()
                    .updPass(_passOldController.text, _passNewController.text)
                    .then((value) {
                  MyRoute.router.pop(context);
                  Loading.toast(msg: "修改成功");
                  Future.delayed(Duration(seconds: 2)).then((value){
                    if(mounted){
                      MyRoute.router.pop(context);
                    }
                  });
                }).whenComplete(() => Loading.dismiss());
              },
              cancelFunc: () {
                MyRoute.router.pop(context);
              });
        },
      ),
    );
  }
}
