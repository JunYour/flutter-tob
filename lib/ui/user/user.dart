import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/bloc/notice/notice_bloc.dart';
import 'package:tob/bloc/userInfo/user_info_bloc.dart';
import 'package:tob/entity/base_data_entity.dart';
import 'package:tob/entity/user_info_entity.dart';
import 'package:tob/global/baseData.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/main.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/bloc/notice.dart';
import 'package:tob/widget/bloc/staff.dart';
import 'package:tob/widget/bloc/user.dart';
import 'package:tob/widget/loading.dart';
import 'package:tob/widget/wx_share.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    navigatorKey.currentState.overlay.context
        .read<NoticeBloc>()
        .add(NoticeLoadEvent(reload: true));
    startStaffApplyCountBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: bodyS(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  bodyS() {
    return SingleChildScrollView(
      child: Container(
        color: ColorConfig.bgColor,
        child: Column(
          children: [
            //顶部
            Container(
              width: double.infinity,
              color: ColorConfig.themeColor,
              child: Column(
                children: [
                  SizedBox(height: 96.w),
                  Text(
                    "我的",
                    style: TextStyle(
                        fontSize: 48.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1),
                  ),
                  //个人信息
                  SizedBox(height: 49.w),
                  BlocBuilder<UserInfoBloc, UserInfoState>(
                      builder: (context, state) {
                    UserInfoEntity userInfoEntity;
                    if (state is UserState) {
                      userInfoEntity = state.userInfoEntity;
                    }
                    return Container(
                      padding: EdgeInsets.only(left: 36.w, right: 36.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              blocHeadImage(),
                              SizedBox(
                                width: 10.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      blocNameText(),
                                      userInfoEntity?.auth == 2
                                          ? Container(
                                              margin:
                                                  EdgeInsets.only(left: 12.w),
                                              padding: EdgeInsets.all(5.w),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 1.w),
                                              ),
                                              child: Text(
                                                "已认证",
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1,
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Text(""),
                                      userInfoEntity?.isVip == 2
                                          ? Container(
                                              padding:
                                                  EdgeInsets.only(left: 16.w),
                                              child: Text(
                                                'VIP',
                                                style: TextStyle(
                                                    fontSize: 30.sp,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1),
                                              ),
                                            )
                                          : Text(""),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 12.w),
                                    child: blocPhone(hide: true),
                                  ),
                                  userInfoEntity?.dealer != null
                                      ? Container(
                                          margin: EdgeInsets.only(top: 14.w),
                                          child: Text(
                                            "${userInfoEntity.dealer.name}",
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                height: 1),
                                          ),
                                        )
                                      : Text(""),
                                ],
                              ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     Text(
                          //       "管理员",
                          //       style: TextStyle(
                          //           fontSize: 24.sp,
                          //           color: Colors.white,
                          //           height: 1,
                          //           fontWeight: FontWeight.bold),
                          //     ),
                          //     Icon(Icons.chevron_right,
                          //         size: 40.w, color: Colors.white),
                          //   ],
                          // ),
                        ],
                      ),
                    );
                  }),
                  //按钮组
                  SizedBox(height: 45.w),
                  Container(
                    padding: EdgeInsets.only(bottom: 20.w),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            MyRoute.router.navigateTo(context, Routes.member,
                                transition: TransitionType.cupertino);
                          },
                          child: Container(
                            width: 185.w,
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/huiyuan.png",
                                  width: 42.w,
                                  height: 44.w,
                                ),
                                Text(
                                  "我的会员",
                                  style: TextStyle(
                                      fontSize: 30.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            MyRoute.router.navigateTo(
                                context, Routes.userOrderManager,
                                transition: TransitionType.cupertino);
                          },
                          child: Container(
                            width: 185.w,
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/dingdanguanli.png",
                                  width: 42.w,
                                  height: 44.w,
                                ),
                                Text(
                                  "订单管理",
                                  style: TextStyle(
                                      fontSize: 30.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (UserInfo.getUserInfo().dealerId > 0 &&
                                UserInfo.getUserInfo().dealer.status == '2') {
                              navTo(context, Routes.staffList);
                            } else {
                              Loading.toast(msg: "请先加入企业");
                            }
                          },
                          child: Container(
                            width: 185.w,
                            child: Column(
                              children: [
                                staffApplyCount(
                                  Image.asset(
                                    "assets/yuangongguanli.png",
                                    width: 42.w,
                                    height: 44.w,
                                  ),
                                ),
                                Text(
                                  "员工管理",
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            MyRoute.router.navigateTo(
                                context, Routes.verifyIndex,
                                transition: TransitionType.cupertino);
                          },
                          child: Container(
                            width: 185.w,
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/icon-report.png",
                                  width: 42.w,
                                  height: 44.w,
                                ),
                                Text(
                                  "认证管理",
                                  style: TextStyle(
                                      fontSize: 30.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //列表
            list(),
          ],
        ),
      ),
    );
  }

  list() {
    return Container(
      margin: EdgeInsets.only(top: 42.w),
      padding: EdgeInsets.only(left: 30.w, right: 30.w),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          listWidget(
              title: "消息通知",
              widget: Container(
                width: 34.w,
                height: 34.w,
                child: Image.asset("assets/renzheng.png"),
              ),
              rightWidget: numNotice(),
              func: () {
                MyRoute.router.navigateTo(context, Routes.message,
                    transition: TransitionType.cupertino);
              }),
          listWidget(
              title: "地址管理",
              widget: Container(
                width: 34.w,
                height: 34.w,
                child: Icon(
                  Icons.location_on,
                  color: ColorConfig.themeColor,
                  size: 38.r,
                ),
              ),
              func: () {
                navTo(context, Routes.addressList + '?type=manager');
              }),
          // listWidget(
          //     title: "帮助中心",
          //     widget: Container(
          //       width: 34.w,
          //       height: 34.w,
          //       child: Image.asset("assets/bangzhuzhongxin.png"),
          //     ),
          //     func: () {
          //       String url =
          //           'https://tob.sobot.com/chat/h5/v2/index.html?sysnum=7c2be7c274b74a319b02858abbdf6b5d&channelid=2';
          //       BaseDataEntity baseDataEntity = BaseData.getHelpCenter();
          //       if (baseDataEntity != null && baseDataEntity.value != null) {
          //         url = baseDataEntity.value;
          //       }
          //       navTo(
          //           context,
          //           Routes.webViewPage +
          //               "?title=帮助中心&url=${Uri.encodeComponent(url)}");
          //     }),
          listWidget(
              title: "一键邀请",
              widget: Container(
                width: 34.w,
                height: 34.w,
                child: Image.asset("assets/yaoqing.png"),
              ),
              func: () {
                Http.getInstance().getInviteLink().then((value) {
                  wxShare(
                      url: value.data, title: "邀请注册", description: "邀请新用户注册");
                });
              }),
          listWidget(
            title: "设置",
            widget: Container(
              width: 34.w,
              height: 34.w,
              child: Image.asset("assets/shezhi.png"),
            ),
            show: false,
            func: () {
              MyRoute.router.navigateTo(context, Routes.set,
                  transition: TransitionType.cupertino);
            },
          ),
        ],
      ),
    );
  }

  listWidget(
      {@required String title,
      @required Widget widget,
      Function func,
      Widget rightWidget,
      bool show = true}) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            func();
          },
          child: Container(
            height: 98.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Icon(
                    //   Icons.settings,
                    //   size: 34.w,
                    //   color: ColorConfig.themeColor,
                    // ),
                    widget,
                    SizedBox(width: 17.w),
                    Text(
                      "$title",
                      style: TextStyle(
                        fontSize: 36.sp,
                        height: 1,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff333333),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (rightWidget != null) rightWidget,
                    Icon(
                      Icons.chevron_right,
                      color: Color(0xff666666),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        if (show == true)
          Container(
            margin: EdgeInsets.only(top: 1.w, bottom: 1.w),
            width: 690.w,
            height: 2.w,
            color: Colors.grey[300],
          ),
      ],
    );
  }
}
