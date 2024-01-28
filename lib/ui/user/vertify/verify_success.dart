import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/bloc/userInfo/user_info_bloc.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/widget/common_widget.dart';

import '../../../main.dart';

class VerifySuccess extends StatefulWidget {
  final int type;
   VerifySuccess({@required this.type});

  @override
  _CompanyVerifySuccessState createState() => _CompanyVerifySuccessState();
}

class _CompanyVerifySuccessState extends State<VerifySuccess> {
  int _type = 0; //0==实名认证，1=企业认证，2=企业申请
  String tips = "";
  String intro = "";

  @override
  void initState() {
    _type = widget.type;
    if (_type == 0) {
      tips = "认证成功";
      intro = "恭喜你，完成实名认证";
    } else {
      tips = "申请成功";
      if(_type == 1){
        intro = "您的企业认证已申请，请等待审核";
      }else if(_type==2){
        intro = "您已申请加入企业，请等待审核";
      }
    }
    //更新用户信息
    Http.getInstance().getUserInfo().then((userInfo) {
      UserInfo.setUserInfo(userInfo);
      BuildContext thisContext = navigatorKey.currentState.context;
      BlocProvider.of<UserInfoBloc>(thisContext).add(UserStateEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbarTitle(title: "$tips", actions: [
        Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Text("查看认证"),
        ),
      ]),
      bottomNavigationBar: SafeArea(
        bottom: true,
        top: false,
        minimum: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            eleButton(
                width: 500.w,
                height: 70.w,
                con: "完成",
                circular: 35.w,
                color: ColorConfig.themeColor,
                func: () {

                  MyRoute.router.pop(context);
                })
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(),
            SizedBox(height: 300.w),
            Icon(
              Icons.check_circle_sharp,
              size: 200.sp,
              color: ColorConfig.themeColor[300],
            ),
            Text(
              "$tips",
              style: TextStyle(
                  color: ColorConfig.themeColor[300], fontSize: 50.sp),
            ),
            Text(
              "$intro",
            ),
          ],
        ),
      ),
    );
  }
}
