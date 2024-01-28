import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/bloc/notice/notice_bloc.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/ui/user/message/message_list.dart';

class MessagePage extends StatefulWidget {
  final int type;
  MessagePage({this.type});
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  int choseType = 1;
  List types = [1, 2];

  @override
  void initState() {
    if (widget.type != null) {
      choseType = widget.type;
    }
    BlocProvider.of<NoticeBloc>(context).add(NoticeLoadEvent(reload: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '消息通知',
          style: TextStyle(color: Colors.black, fontSize: 36.sp ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //修改颜色
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              color: ColorConfig.themeColor,
              height: 302.w,
            ),
          ),
          //按钮
          Positioned(
            top: 58.w,
            left: 28.w,
            right: 36.w,
            child: Container(
              width: 684.w,
              height: 90.w,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.w),
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (choseType == 2) {
                        setState(() {
                          choseType = 1;
                        });
                      }
                    },
                    child: Container(
                      width: 342.w,
                      alignment: Alignment.center,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.w),
                            bottomLeft: Radius.circular(10.w),
                          ),
                          color: choseType == 1
                              ? Colors.white
                              : ColorConfig.themeColor),
                      child: Text(
                        '公告',
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: choseType == 1
                              ? ColorConfig.themeColor
                              : Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (choseType == 1) {
                        setState(() {
                          choseType = 2;
                        });
                      }
                    },
                    child: Container(
                      width: 342.w,
                      alignment: Alignment.center,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.w),
                          bottomRight: Radius.circular(10.w),
                        ),
                        color: choseType == 2
                            ? Colors.white
                            : ColorConfig.themeColor,
                      ),
                      child: Text(
                        '通知',
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: choseType == 2
                              ? ColorConfig.themeColor
                              : Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //消息数量
          Positioned(
              top: 40.w,
              right: 16.w,
              child: BlocBuilder<NoticeBloc, NoticeState>(
                  builder: (context, state) {
                int num = 0;
                if (state is NoticeLoadState) {
                  num = state?.noticeCountEntity?.notice;
                }
                if (num > 0) {
                  return Container(
                    width: 56.w,
                    height: 56.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28.w),
                    ),
                    child: Text(
                      '$num',
                      style: TextStyle(
                        color: Color(0xFF0047CC),
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                } else {
                  return Text('');
                }
              })),
          Positioned(
              top: 40.w,
              left: 16.w,
              child: BlocBuilder<NoticeBloc, NoticeState>(
                  builder: (context, state) {
                int num = 0;
                if (state is NoticeLoadState) {
                  num = state.noticeCountEntity?.brocast;
                }
                if (num > 0) {
                  return Container(
                    width: 56.w,
                    height: 56.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28.w),
                    ),
                    child: Text(
                      '$num',
                      style: TextStyle(
                        color: Color(0xFF0047CC),
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                } else {
                  return Text('');
                }
              })),

          //信息列表

          Positioned(
            top: 214.w,
            child: Offstage(
              offstage: choseType == 1 ? false : true,
              child: Container(
                width: 750.w,
                height: MediaQuery.of(context).size.height - 214.w,
                child: MessageListPage(
                  type: 1,
                ),
              ),
            ),
          ),
          Positioned(
            top: 214.w,
            child: Offstage(
              offstage: choseType == 2 ? false : true,
              child: Container(
                width: 750.w,
                height: MediaQuery.of(context).size.height - 214.w,
                child: MessageListPage(
                  type: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
