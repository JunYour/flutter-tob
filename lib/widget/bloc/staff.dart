
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tob/bloc/staff_apply/staff_apply_bloc.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/main.dart';

///员工申请未处理
staffApplyCount( Widget widget){
  return BlocBuilder<StaffApplyBloc, StaffApplyState>(builder: (context, state) {
    int count = 0;
    if (state is StaffApplyCountState) {
      count = state.count;
    }
    return Badge(
      badgeColor: Colors.white,
      showBadge: count>0?true:false,
      badgeContent: Text(
        '$count',
        style: TextStyle(color: Color(0xffFF424B)),
      ),
      child:widget,
    );
  });
}

///触发bloc
startStaffApplyCountBloc(){
  if(UserInfo.getUserInfo().dealerId !=0 && UserInfo.getUserInfo().ifLoginAdmin=="2"){
    navigatorKey.currentState.overlay.context
        .read<StaffApplyBloc>()
        .add(StaffApplyCountEvent(UserInfo.getUserInfo().dealerId));
  }
}