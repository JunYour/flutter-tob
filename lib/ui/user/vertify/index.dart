import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/bloc/userInfo/user_info_bloc.dart';
import 'package:tob/entity/user_info_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';

import '../../../main.dart';

class VerifyIndexPage extends StatefulWidget {
  const VerifyIndexPage({Key key}) : super(key: key);

  @override
  _VerifyIndexPageState createState() => _VerifyIndexPageState();
}

class _VerifyIndexPageState extends State<VerifyIndexPage> {
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  ///获取信息
  getInfo() {
    if (UserInfo.getUserInfoId() == null) {
      BuildContext thisContext = navigatorKey.currentState.context;
      navTo(thisContext, Routes.loginPhone + "?back=true").then((value) {
        if (value != null) {
          getUserInfo();
        } else {
          getInfo();
        }
      });
    } else {
      getUserInfo();
    }
  }

  ///获取用户信息
  getUserInfo() {
    Loading.show();
    Http.getInstance().getUserInfo().then((userInfo) {
      if (mounted) {
        UserInfo.setUserInfo(userInfo);
        BuildContext thisContext = navigatorKey.currentState.context;
        BlocProvider.of<UserInfoBloc>(thisContext).add(UserStateEvent());
      }
    }).whenComplete(() => Loading.dismiss());
  }

  @override
  void dispose() {
    super.dispose();
    Loading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1f1f1),
      appBar: blueAppbarTitle(title: "认证管理", elevation: 0),
      body: Column(
        children: [
          //提示
          tips(),
          //  我的认证
          verify(),
        ],
      ),
    );
  }

  tips() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 46.w, left: 31.w, bottom: 24.w),
      child: Text(
        "提示：通过身份认证才能拥有更多使用权限",
        style: TextStyle(
            fontSize: 24.sp,
            color: Color(0xffEA1E14),
            fontWeight: FontWeight.bold,
            height: 1),
      ),
    );
  }

  verify() {
    return Container(
      width: 688.w,
      margin: EdgeInsets.only(left: 31.w, right: 31.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.w),
      ),
      padding:
          EdgeInsets.only(left: 30.w, right: 24.w, top: 37.w, bottom: 23.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "我的认证",
            style: TextStyle(
                fontSize: 36.sp,
                color: ColorConfig.themeColor,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          BlocBuilder<UserInfoBloc, UserInfoState>(builder: (context, state) {
            UserInfoEntity userInfoEntity;
            if (state is UserState) {
              userInfoEntity = state.userInfoEntity;
            }
            return Container(
              height: 127.w,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1.w,
                    color: Color(0xff999999),
                  ),
                ),
              ),
              child: InkWell(
                onTap: () {
                  if (userInfoEntity.auth == 2) {
                    navTo(context, Routes.userVerifyInfo);
                  } else {
                    navTo(context, Routes.userVerify);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 83.w,
                          height: 83.w,
                          child: Image.asset("assets/realname.png"),
                        ),
                        SizedBox(width: 47.w),
                        Text(
                          "实名认证",
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        userInfoEntity.auth == 2
                            ? Text(
                                "已认证",
                                style: TextStyle(
                                  color: ColorConfig.themeColor,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                              )
                            : Text(
                                "未认证",
                                style: TextStyle(
                                  color: Color(0xffEA1E14),
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                              ),
                        SizedBox(width: 32.w),
                        Icon(Icons.chevron_right, size: 40.w)
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          BlocBuilder<UserInfoBloc, UserInfoState>(builder: (context, state) {
            UserInfoEntity userInfoEntity;
            if (state is UserState) {
              userInfoEntity = state.userInfoEntity;
            }
            return Column(
              children: [
                Container(
                  height: 127.w,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.w,
                        color: Color(0xff999999),
                      ),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (userInfoEntity.auth != 2) {
                        KlAlert.showAlert(
                            content: "请先进行实名认证",
                            sureFunc: () {
                              MyRoute.router.pop(context);
                            });
                        return false;
                      }
                      //
                      if (userInfoEntity.dealerId != 0) {
                        switch (userInfoEntity.dealer.status) {
                          case "1":
                            navTo(context,
                                "${Routes.companyVerifyInfo}?bid=${userInfoEntity.dealerId}");
                            break;
                          case "2":
                            navTo(context,
                                "${Routes.companyVerifyInfo}?bid=${userInfoEntity.dealerId}");
                            break;
                          case "3":
                            navTo(context, Routes.companyVerify);
                            break;
                          case "4":
                            navTo(context, Routes.companyVerify);
                            break;
                          default:
                            navTo(context, Routes.companyVerify);
                            break;
                        }
                      } else if (userInfoEntity.dealerApply != null) {
                        switch (userInfoEntity.dealerApply.status) {
                          case 1:
                            navTo(context,
                                "${Routes.companyVerifyInfo}?bid=${userInfoEntity.dealerApply.dealerId}");
                            break;
                          case 2:
                            navTo(context,
                                "${Routes.companyVerifyInfo}?bid=${userInfoEntity.dealerApply.dealerId}");
                            break;
                          case 3:
                            navTo(context, Routes.companyVerify);
                            break;
                          default:
                            navTo(context, Routes.companyVerify);
                            break;
                        }
                      } else {
                        navTo(context, Routes.companyVerify);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 83.w,
                              height: 83.w,
                              child: Image.asset("assets/business.png"),
                            ),
                            SizedBox(width: 47.w),
                            Text(
                              "企业认证",
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            companyStatus(userInfoEntity: userInfoEntity),
                            SizedBox(width: 32.w),
                            Icon(Icons.chevron_right, size: 40.w)
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
                if(userInfoEntity?.dealer != null)
                Container(
                  child: Text(
                    userInfoEntity?.dealer?.remark!=null?userInfoEntity?.dealer?.remark:'',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 26.sp,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  companyStatus({@required UserInfoEntity userInfoEntity}) {
    String text = "未认证";
    Color color = Color(0xffEA1E14);
    //已绑定企业
    if (userInfoEntity.dealerId != 0) {
      //企业认证状态
      if (userInfoEntity.dealer != null) {
        switch (userInfoEntity.dealer.status) {
          case "1":
            text = "审核中";
            color = ColorConfig.themeColor;
            break;
          case "2":
            text = "已认证";
            color = ColorConfig.themeColor;
            break;
          case "3":
            text = "已打回";
            break;
          case "4":
            text = "未认证";
            break;
          default:
            text = "未认证";
            break;
        }
      }
    } else if (userInfoEntity.dealerApply != null) {
      switch (userInfoEntity.dealerApply.status) {
        case 1:
          text = "审核中";
          color = ColorConfig.themeColor;
          break;
        case 2:
          text = "已认证";
          color = ColorConfig.themeColor;
          break;
        case 3:
          text = "已拒绝";
          break;
        default:
          text = "未认证";
          break;
      }
    }

    return Text(
      "$text",
      style: TextStyle(
        color: color,
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        height: 1,
      ),
    );
  }
}
