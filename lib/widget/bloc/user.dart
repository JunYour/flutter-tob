import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tob/bloc/userInfo/user_info_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//姓名采用全局状态管理
blocNameText({double size,Color color}) {

  return BlocBuilder<UserInfoBloc, UserInfoState>(builder: (context, state) {
    String name = "";
    if (state is UserState) {
      name = state.userInfoEntity?.username;
    }
    return Text(
      '$name',
      style: TextStyle(
          fontSize:  size??36.sp,
          height: 1,
          color: color??Colors.white,
          fontWeight: FontWeight.bold),
    );
  });
}

/// 手机号显示全局管理
blocPhone({Color colors = Colors.white,double size ,bool hide=false}) {
  if(size==null){
    size = 26.sp;
  }
  return BlocBuilder<UserInfoBloc, UserInfoState>(builder: (context, state) {
    String phone = "";
    if (state is UserState) {
      phone = state.userInfoEntity?.mobile;
      if(hide == true && phone.length==11){
        phone = phone.replaceFirst(new RegExp(r'\d{4}'), '****', 3);
      }
    }
    return Text(
      "$phone",
      style: TextStyle(
        fontSize: size,
        color: colors,
        fontWeight: FontWeight.bold,
        height: 1,
      ),
    );
  });
}

//头像采用全局管理
blocHeadImage({double width, double height}) {
  return BlocBuilder<UserInfoBloc, UserInfoState>(builder: (context, state) {
    String avatar = "";
    if (state is UserState) {
      avatar = state.userInfoEntity?.avatar;
    }
    if(avatar != null && avatar!="" ){
      return ExtendedImage.network(
        '$avatar',
        width: 120.w,
        height: 120.w,
        fit: BoxFit.fill,
        loadStateChanged: (ExtendedImageState state) {
          Widget wig;
          if (state.extendedImageLoadState == LoadState.failed) {
            wig = Image.asset("assets/user.png", width: 120.w);
          }
          return wig;
        },
        cache: false,
        shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(60.w),
      );
    }else{
      return Image.asset("assets/user.png", width: 120.w);
    }
  });
}
