import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/bloc/userInfo/user_info_bloc.dart';
import 'package:tob/entity/base_entity.dart';
import 'package:tob/entity/vip/legal_right_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/widget/bloc/user.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/entity/user_info_entity.dart';
import 'package:tob/widget/content_webview_dart.dart';
import 'package:tob/widget/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({Key key}) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  List<LegalRightEntity> _legalRightEntity = [];
  String pageName = "我的会员";
  UserInfoEntity _userInfoEntity;

  @override
  void initState() {
    getList();
    getUserInfo();
    super.initState();
  }

  //获取用户信息用以刷新
  getUserInfo() {
    try {
      Http.getInstance().getUserInfo().then((value) {
        UserInfo.setUserInfo(value);
        BlocProvider.of<UserInfoBloc>(context).add(UserStateEvent());
      });
    } catch (e) {
      debugPrint(pageName);
      debugPrint(e);
    }
  }

  //获取会员权益
  getList() {
    try {
      Loading.show();
      Http.getInstance().legalRightList().then((value) {
        if (mounted) {
          _legalRightEntity = value;
          setState(() {});
        }
      }).whenComplete(() => Loading.dismiss());
    } catch (e) {
      debugPrint(pageName);
      debugPrint(e);
    }
  }

  @override
  void dispose() {
    Loading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "我的会员",
        ),
        centerTitle: true,
        elevation: 0,
        brightness: Brightness.dark,
      ),
      //开通会员
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Container(
          padding:
              EdgeInsets.only(bottom: 10.h, top: 10.h, left: 60.w, right: 60.w),
          child: btn(),
        ),
      ),
      body: Column(
        children: [
          //  顶部
          top(),
          //  尊享权益
          interests(),
        ],
      ),
    );
  }

  //顶部
  top() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(builder: (context, state) {
      if (state is UserState) {
        _userInfoEntity = state.userInfoEntity;
      }
      return Container(
        width: double.infinity,
        height: 222.w,
        color: ColorConfig.themeColor,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: 34.w, left: 28.w, bottom: 36.w, right: 28.w),
                  width: 104.w,
                  height: 104.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(52.w),
                  ),
                  child: blocHeadImage(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    blocNameText(),
                    SizedBox(height: 10.w),
                    blocPhone(hide: true),
                    SizedBox(height: 10.w),
                    if (_userInfoEntity?.auth == 2)
                      Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.w),
                        ),
                        child: Text(
                          "已认证",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              height: 1,
                              color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 32.w, right: 29.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _userInfoEntity.isVip == 1
                        ? "开通会员享${_legalRightEntity.length}项特权"
                        : "",
                    style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.white,
                        height: 1,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _userInfoEntity.isVip == 1
                        ? "您还未开通会员"
                        : "${_userInfoEntity.vipEndTime}到期",
                    style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.white,
                        height: 1,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  //会员权益列表
  interests() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 49.w),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 33.w),
            child: Text(
              "尊享权益",
              style: TextStyle(
                  fontSize: 36.sp,
                  color: ColorConfig.themeColor,
                  height: 1,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 49.w),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    String content = _legalRightEntity[index].content;
                    if (content != null && content.length > 0) {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) {
                            return new ContentWebView(
                                html: content,
                                title: _legalRightEntity[index].name);
                          },
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 125.w,
                    margin: EdgeInsets.only(left: 30.w, right: 30.w),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.w,
                          color: Color(0xff999999),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 90.w,
                          height: 90.w,
                          margin: EdgeInsets.only(right: 28.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35.w),
                          ),
                          child: showImageNetwork(
                              img: "${_legalRightEntity[index].iconimage}"),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_legalRightEntity[index].name}",
                                style: TextStyle(
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff333333),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 13.w),
                                child: Text(
                                  "${_legalRightEntity[index].summary}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff999999),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: _legalRightEntity.length,
            ),
          ),
        ],
      ),
    );
  }

  //开通会员按钮
  btn() {
    return BlocBuilder<UserInfoBloc, UserInfoState>(builder: (context, state) {
      if (state is UserState) {
        _userInfoEntity = state.userInfoEntity;
      }
      return eleButton(
        width: 513.w,
        height: 72.w,
        con: _userInfoEntity.isVip == 1 ? "开通会员" : "续费会员",
        circular: 36.w,
        color: ColorConfig.themeColor,
        func: () {
          _alertSimpleDialog();
        },
      );
    });
  }

  //开通弹框
  _alertSimpleDialog() async {
    Loading.show();
    BaseEntity baseEntity = await Http.getInstance()
        .getConnectMobile()
        .whenComplete(() => Loading.dismiss());
    String mobile = baseEntity.data;
    var alertDialogs = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              width: 497.w,
              height: 291.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.w),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(height: 78.w),
                  Text(
                    '联系客服',
                    style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff333333),
                        height: 1),
                  ),
                  SizedBox(height: 23.w),
                  Text(
                    "$mobile",
                    style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorConfig.themeColor,
                        height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      eleButton(
                          width: 150.w,
                          height: 60.w,
                          con: "取消",
                          circular: 18.w,
                          color: ColorConfig.themeColor,
                          func: () {
                            MyRoute.router.pop(context);
                          }),
                      SizedBox(width: 85.w),
                      eleButton(
                          width: 150.w,
                          height: 60.w,
                          con: "确认",
                          circular: 18.w,
                          color: ColorConfig.themeColor,
                          func: () {
                            launch("tel://$mobile");
                          }),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
    return alertDialogs;
  }
}
