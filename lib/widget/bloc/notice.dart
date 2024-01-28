import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tob/bloc/notice/notice_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/global/color_config.dart';

iconNotice() {
  return BlocBuilder<NoticeBloc, NoticeState>(
    builder: (context, state) {
      int num = 0;
      if (state is NoticeLoadState) {
        num = state.noticeCountEntity.brocast + state.noticeCountEntity.notice;
      }
      return Badge(
        badgeColor: Colors.white,
        showBadge: num > 0 ? true : false,
        badgeContent: Text(
          '$num',
          style: TextStyle(
            color:ColorConfig.themeColor,
            // color: Color(0xffFF424B),
            fontSize: 20.sp,
          ),
        ),
        child: Icon(
          Icons.notifications,
          color: ColorConfig.themeColor,
        ),
      );
    },
  );
}

indexIconNotice() {
  return BlocBuilder<NoticeBloc, NoticeState>(
    builder: (context, state) {
      int num = 0;
      if (state is NoticeLoadState) {
        num = state.noticeCountEntity.brocast + state.noticeCountEntity.notice;
      }
      return Badge(
        position: BadgePosition.topStart(top: 15.w, start: 30.w),
        badgeColor: Colors.white,
        showBadge: num > 0 ? true : false,
        badgeContent: Text(
          '$num',
          style: TextStyle(
            color: ColorConfig.themeColor,
            // color: Color(0xffFF424B),
            fontSize: 20.sp,
          ),
        ),
        child: Image.asset(
          "assets/index_notice.png",
          width: 48.w,
          height: 46.w,
          color: ColorConfig.themeColor,
        ),
      );
    },
  );
}

numNotice() {
  return BlocBuilder<NoticeBloc, NoticeState>(
    builder: (context, state) {
      int num = 0;
      if (state is NoticeLoadState) {
        num = state.noticeCountEntity.brocast + state.noticeCountEntity.notice;
      }
      return num > 0 ? Text(num.toString()) : Text('');
    },
  );
}
