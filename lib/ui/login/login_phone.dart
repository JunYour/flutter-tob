import 'dart:async';
import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tob/bloc/userInfo/user_info_bloc.dart';
import 'package:tob/entity/base_data_entity.dart';
import 'package:tob/entity/user_info_entity.dart';
import 'package:tob/global/app.dart';
import 'package:tob/global/baseData.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/sdk/ji_guang.dart';
import 'package:tob/sdk/weixin.dart';
import 'package:tob/ui/tabbar/home_tabbar.dart';
import 'package:tob/util/common_util.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/content_webview_dart.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/kl_dialog.dart';
import 'package:tob/widget/loading.dart';
import 'package:tob/widget/update_overlay_util.dart';

import '../../main.dart';
import 'login_top.dart';

class LoginPhonePage extends StatefulWidget {
  final bool back;

  LoginPhonePage({this.back});

  @override
  _LoginPhonePageState createState() => _LoginPhonePageState();
}

class _LoginPhonePageState extends State<LoginPhonePage> {
  int _loginType = 0; //登录方式类型,0手机号登录,1密码登录

  TextEditingController _controller = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  String _smsRequestId = "";
  String _smsBizId = "";

  bool btnSure = false;

  @override
  void initState() {
    getBaseData();
    super.initState();
  }

  List<TextSpan> _buildSpans() {
    List<TextSpan> list = [];
    List termList = [
      BaseData.getUserAgreement(),
      BaseData.getPrivacyPolicy(),
    ];
    int length = termList.length;
    for (int i = 0; i < length; i++) {
      BaseDataEntity term = termList[i];
      list.add(TextSpan(
          text: "《${term.title}》",
          style: TextStyle(
            fontSize: 26.sp,
            color: Color(0xff5E80FF),
            fontWeight: FontWeight.w400,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    return new ContentWebView(
                        html: term.content, title: term.title);
                  },
                ),
              );
            }));
      if (i != length - 1) {
        list.add(TextSpan(
          text: "、",
          style: TextStyle(
            fontSize: 24.sp,
            color: Color(0xff131313),
            fontWeight: FontWeight.w400,
          ),
        ));
      }
    }
    return list;
  }

  //获取基础数据
  getBaseData() {
    Http.getInstance().baseData().then((value) {
      for (int i = 0; i < value.length; i++) {
        if (value[i].name == BaseData.helpCenter) {
          BaseData.setHelpCenter(value[i]);
        } else if (value[i].name == BaseData.userAgreement) {
          BaseData.setUserAgreement(value[i]);
        } else if (value[i].name == BaseData.privacyPolicy) {
          BaseData.setPrivacyPolicy(value[i]);
        } else if (value[i].name == BaseData.intro) {
          BaseData.setIntro(value[i]);
        }
      }
      Future.delayed(Duration(milliseconds: 0)).then((value) {
        //查看用户是否同意过用户协议
        print(App.hasAcceptLicense());
        if (App.hasAcceptLicense() == null || App.hasAcceptLicense() == false) {
          _showDialog();
        }
      });
    });
  }

  void _showDialog() {
    BuildContext thisContext = navigatorKey.currentState.context;
    Future.delayed(Duration(milliseconds: Platform.isIOS ? 300 : 0), () {
      showDialog(
          context: thisContext,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.all(60.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.w),
                        color: Colors.white),
                    child: Column(
                      children: _content(),
                    ),
                  )
                ],
              ),
            );
          }).then((value) {
        if (!App.hasAcceptLicense()) {
          //退出app
          exit(0);
        }
      });
    });
  }

  List<Widget> _content() {
    List<Widget> list = [];
    list.add(HomeWebView(BaseData.getIntro()));
    list.add(RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
            text: "查看完整版",
            style: TextStyle(
              fontSize: 24.sp,
              color: Color(0xff666666),
              fontWeight: FontWeight.w400,
            )),
        ..._buildSpans()
      ]),
    ));
    list.add(Padding(
      padding: EdgeInsets.fromLTRB(0, 50.0.w, 0, 30.w),
      child: Column(
        children: <Widget>[
          Container(
            width: 400.w,
            height: 54.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ColorConfig.themeColor[300], ColorConfig.themeColor],
              ),
              // 渐变色
              borderRadius: BorderRadius.circular(40.w),
            ),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(ColorConfig.themeColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.w),
                  ),
                ),
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              child: Text(
                "同意",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                App.setAcceptLicense(accept: true);
                if (App.hasAcceptLicense()) {
                  ///极光推送注册
                  JiGuang.initPlatformState();

                  ///微信sdk注册
                  Weixin.initFluWx();

                  ///极光魔链
                  JiGuang.initJml();
                }
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.w),
            width: 400.w,
            height: 54.w,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(40.w)),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.w),
                  ),
                ),
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              child: Text(
                "不同意,并退出app",
                style: TextStyle(
                  color: Color(0xff999999),
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                //直接退出app
                exit(0);
              },
            ),
          ),
        ],
      ),
    ));
    return list;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    Loading.dismiss();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeBoard(context: context);
      },
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 顶部
            stackWidget(text: _loginType == 0 ? "手机号登录" : "密码登录"),
            phone(),
            _loginType == 0 ? code() : password(),
            SizedBox(
              height: 30.w,
            ),
            //其他按钮
            other(),
            loginBtn(),
          ],
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
            height: 75.w,
            child: TextField(
              maxLength: 11,
              controller: _controller,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                if (_loginType == 0) {
                  if (value.length == 11 && _codeController.text.length == 6) {
                    btnSure = true;
                  } else {
                    btnSure = false;
                  }
                } else {
                  if (value.length == 11 &&
                      _passwordController.text.length >= 6) {
                    btnSure = true;
                  } else {
                    btnSure = false;
                  }
                }

                setState(() {});
              },
              decoration: InputDecoration(
                counterText: "",
                //输入框内边距
                contentPadding: EdgeInsets.only(bottom: 24.w),
                //输入框内容提示
                hintText: '请输入手机号',
                hintStyle: TextStyle(
                  fontSize: 24.sp,
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
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                if (value.length == 6 && _controller.text.length == 11) {
                  btnSure = true;
                } else {
                  btnSure = false;
                }
                setState(() {});
              },
              decoration: InputDecoration(
                counterText: "",
                //输入框内边距
                // contentPadding: EdgeInsets.symmetric(vertical: 20.w),
                contentPadding: EdgeInsets.only(bottom: 24.w),
                //输入框内容提示
                hintText: '请输入验证码',
                hintStyle: TextStyle(
                  fontSize: 24.sp,
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
                if (_controller.text.isEmpty) {
                  KlAlert.showAlert(
                      content: "请输入手机号",
                      sureFunc: () {
                        MyRoute.router.pop(context);
                      });
                  return false;
                }
                if (!CommonUtil.isChinaPhoneLegal(_controller.text)) {
                  KlAlert.showAlert(
                      content: "请输入正确的手机号",
                      sureFunc: () {
                        MyRoute.router.pop(context);
                      });
                  return false;
                }
                Loading.show();
                Http.getInstance().phoneVerify(_controller.text).then((value) {
                  Loading.show();
                  Http.getInstance()
                      .smsSend(_controller.text, "login")
                      .then((value) {
                    startTime();
                    _smsRequestId = value.requestId;
                    _smsBizId = value.bizId;
                  }).whenComplete(() => {Loading.dismiss()});
                }).catchError((value) {
                  klDialog(
                    widget: Container(
                      padding: EdgeInsets.all(30.w),
                      child: Column(
                        children: [
                          Text("提示"),
                          Text("该手机号未注册"),
                          SizedBox(
                            height: 30.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              eleButton(
                                  width: 180.w,
                                  height: 70.w,
                                  con: "取消",
                                  circular: 35.w,
                                  color: ColorConfig.themeColor[100],
                                  size: 28.sp,
                                  func: () {
                                    MyRoute.router.pop(context);
                                  }),
                              SizedBox(
                                width: 50.w,
                              ),
                              eleButton(
                                width: 180.w,
                                height: 70.w,
                                con: "去注册",
                                circular: 35.w,
                                color: ColorConfig.themeColor,
                                size: 28.sp,
                                func: () {
                                  MyRoute.router.pop(context);
                                  MyRoute.router.navigateTo(
                                      context, Routes.passRegister + "?type=0",
                                      transition: TransitionType.cupertino);
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
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
          Container(
            width: 400.w,
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                if (value.length >= 6 && _controller.text.length == 11) {
                  btnSure = true;
                } else {
                  btnSure = false;
                }
                setState(() {});
              },
              decoration: InputDecoration(
                counterText: "",
                //输入框内边距
                contentPadding: EdgeInsets.only(bottom: 24.w),
                //输入框内容提示
                hintText: '请输入密码',
                hintStyle: TextStyle(
                  fontSize: 24.sp,
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

  //登录按钮
  loginBtn() {
    return Container(
      margin: EdgeInsets.only(top: 30.w),
      child: ElevatedButton(
        onPressed: btnSure
            ? () async {
                FocusScope.of(context).requestFocus(FocusNode());
                //验证码登录
                if (_loginType == 0) {
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
                          _controller.text, _codeController.text, _smsBizId)
                      .then((value) async {

                    ///极光推送注册
                    JiGuang.initPlatformState();
                    print('++++++++++ok+++++++++++');

                    bool enabled = await jpush.isNotificationEnabled();
                    if (enabled) {
                      jpush.getRegistrationID().then((value) {
                        ///获取到了极光的id
                        loginApi(value);
                      }).catchError((error) {
                        ///未获取到极光的id
                        loginApi('-');
                      });
                    } else {
                      ///推送不可用
                      loginApi('-');
                    }
                  }).catchError((err) {
                    setState(() {
                      btnSure = true;
                    });
                    Loading.dismiss();
                  }).whenComplete(() => Loading.dismiss());
                } else {
                  //密码登录
                  if (_passwordController.text.length <= 0) {
                    Loading.toast(msg: "请输入密码");
                    return false;
                  }
                  Loading.show();
                  bool enabled = await jpush.isNotificationEnabled();
                  if (enabled) {
                    jpush.getRegistrationID().then((value) {
                      ///获取到了极光的id
                      passLoginApi(value);
                    }).catchError((error) {
                      ///未获取到极光的id
                      passLoginApi('-');
                    });
                  } else {
                    ///推送不可用
                    passLoginApi('-');
                  }
                }
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
          "登录",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 32.sp,
              color: Colors.white),
        ),
      ),
    );
  }

  ///手机号登录
  void loginApi(String value) {
    Http.getInstance().login(_controller.text, value).then((res) {
      loginEdDeal(res);
    }).whenComplete(() => {Loading.dismiss()});
  }

  ///密码登录
  void passLoginApi(String value) {
    Http.getInstance()
        .passLogin(_controller.text, _passwordController.text, value)
        .then((res) {
          loginEdDeal(res);
        })
        .whenComplete(() => {Loading.dismiss()})
        .catchError((err) {
          setState(() {
            btnSure = true;
          });
        });
  }

  ///登录后的处理
  void loginEdDeal(UserInfoEntity res) {
    UserInfo.setUserInfo(res);
    BlocProvider.of<UserInfoBloc>(context).add(UserStateEvent());
    if (widget.back == true) {
      Navigator.pop(context);
    } else {
      MyRoute.router
          .navigateTo(context, Routes.home, replace: true, clearStack: true);
    }
  }

  other() {
    TextStyle style = TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: ColorConfig.themeColor,
        height: 1);
    return Container(
      margin: EdgeInsets.only(top: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              if (_loginType == 0) {
                setState(() {
                  _loginType = 1;
                });
              } else {
                MyRoute.router.navigateTo(
                    context, Routes.passRegister + "?type=1",
                    transition: TransitionType.inFromRight);
              }
            },
            child: Container(
              alignment: Alignment.center,
              height: 50.w,
              child: Text(
                _loginType == 0 ? "密码登录" : "忘记密码?",
                style: style,
              ),
            ),
          ),
          Container(
            width: 2.w,
            height: 28.w,
            color: Colors.grey,
            margin: EdgeInsets.only(left: 30.w, right: 30.w),
          ),
          InkWell(
            onTap: () {
              if (_loginType == 0) {
                closeBoard(context: context);
                MyRoute.router.navigateTo(
                    context, Routes.passRegister + "?type=0",
                    transition: TransitionType.inFromRight);
              } else {
                setState(() {
                  _loginType = 0;
                });
              }
            },
            child: Container(
              height: 50.w,
              alignment: Alignment.center,
              child: Text(
                _loginType == 0 ? "新用户注册" : "手机号登录",
                style: style,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
