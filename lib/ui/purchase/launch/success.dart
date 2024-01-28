import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/bloc/tab/switch_tag_bloc.dart';
import 'package:tob/bloc/tab/switch_tag_event.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/main.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/common_widget.dart';

class PurchaseSuccess extends StatefulWidget {
  @override
  _PurchaseSuccessState createState() => _PurchaseSuccessState();
}

class _PurchaseSuccessState extends State<PurchaseSuccess> {
  String tips = "成功申请采购";
  String intro = "赶车网会在第一时间与您取得联系，核实您的采购申请内容，帮助您完成接下来的采购流程!";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navToUserOrder();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text("发起采购"),
          centerTitle: true,
        ),
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
                  navToUserOrder();
                },
              )
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
              Container(
                margin: EdgeInsets.only(left: 30.w, right: 30.w),
                child: Text(
                  "$tips",
                  style: TextStyle(
                      color: ColorConfig.themeColor[300], fontSize: 50.sp),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 80.w, right: 80.w),
                child: Text(
                  "$intro",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  navToUserOrder() {
    Navigator.of(context)
        .popUntil((route) => route.settings.name == Routes.root);
    BlocProvider.of<SwitchTagBloc>(context).add(
      JustSwitchTagEvent(3, toOrder: true),
    );

  }
}
