
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tob/bloc/notice/notice_bloc.dart';
import 'package:tob/entity/notice/notice_list_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/content_webview_dart.dart';
import 'package:tob/widget/kl_alert.dart';

class MessageListPage extends StatefulWidget {
  final int type;

  MessageListPage({@required this.type});

  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  int _page = 1;
  int _limit = 10;
  int _type = 1; //1公告，2消息
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  NoticeListEntity _noticeListEntity;
  List<NoticeListList> _noticeListList = [];

  @override
  void initState() {
    _type = widget.type;
    super.initState();
  }

  //加载
  void _onLoading() {
    Http.getInstance()
        .noticeList(type: _type, page: _page, limit: _limit)
        .then((value) {
      _noticeListEntity = value;
      if (mounted) {
        if (_noticeListEntity.xList.length > 0) {
          _page++;
          setState(() {
            _noticeListList.addAll(_noticeListEntity.xList);
          });
          if (_noticeListEntity.xList.length == _noticeListEntity.count) {
            _refreshController.loadNoData();
          } else {
            _refreshController.loadComplete();
          }
        } else {
          _refreshController.loadNoData();
        }
      }
    }).catchError((error) {});
  }

  //刷新
  void _onRefresh() {
    _page = 1;
    _refreshController.resetNoData();
    Http.getInstance()
        .noticeList(type: _type, page: _page, limit: _limit)
        .then((value) {
      _noticeListEntity = value;
      if (mounted) {
        _noticeListList.clear();
        if (_noticeListEntity.xList.length > 0) {
          _page++;
          _noticeListList.addAll(_noticeListEntity.xList);
          if (_noticeListEntity.xList.length == _noticeListEntity.count) {
            _refreshController.loadNoData();
          }
        } else {
          _refreshController.loadNoData();
        }
        setState(() {});
        _refreshController.refreshCompleted();
      }
    }).catchError((error) {
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: noticeData(),
    );
  }

  noticeData() {
    jump(NoticeListList noticeListList) {
      if(int.parse(noticeListList.isjump.toString()) ==1){
        //跳转应用内的界面
        if (int.parse(noticeListList.jumptype.toString())== 1) {
          if (noticeListList.jumpUrl == "purchase") {
            //项目采购

            if(noticeListList.extras['oid']==null || noticeListList.extras['pid']==null ){
              KlAlert.showAlert(content: '缺少参数,无法跳转', sureFunc: (){
                MyRoute.router.pop(context);
              });
              return false;
            }

            MyRoute.router.navigateTo(
                context,
                Routes.purchaseDetail +
                    "?oid=${noticeListList.extras['oid'].toString()}&pid=${noticeListList.extras['pid'].toString()}",
                transition: TransitionType.inFromRight);
          }else if(noticeListList.jumpUrl == "carPurchase"){
            //车源采购
            if(noticeListList.extras['carId']==null || noticeListList.extras['pid']==null ){
              KlAlert.showAlert(content: '缺少参数,无法跳转', sureFunc: (){
                MyRoute.router.pop(context);
              });
              return false;
            }
            navTo(context, Routes.userOrderDetail+"?oid=${noticeListList.extras["pid"]}");
          }
        //  跳转h5
        }else if(int.parse(noticeListList.jumptype.toString()) == 0){
          MyRoute.router.navigateTo(
              context,
              Routes.webViewPage +
                  "?title=${Uri.encodeComponent(noticeListList.title)}&url=${Uri.encodeComponent(noticeListList.jumpUrl)}",transition: TransitionType.inFromRight);
        }else if(int.parse(noticeListList.jumptype.toString()) == 2){
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) {
                return new ContentWebView(
                    html: noticeListList.ncontent , title:noticeListList.title);
              },
            ),
          );
        }
      }
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _noticeListList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            //如果未读
            if (_noticeListList[index].isRead == null ||
                _noticeListList[index].isRead == 0) {
              Http.getInstance()
                  .noticeSetread(nid: _noticeListList[index].id, type: _type)
                  .then((value) {
                _noticeListList[index].isRead=1;
                setState(() {});
                BlocProvider.of<NoticeBloc>(context)
                    .add(NoticeLoadEvent(reload: true));
                 jump(_noticeListList[index]);
              });
            } else {

              jump(_noticeListList[index]);
            }
          },
          child: Opacity(
            opacity: 0.95,
            child: Container(
              margin: EdgeInsets.only(bottom: 64.w, left: 30.w, right: 30.w),
              padding: EdgeInsets.only(right: 40.w),
              width: 686.w,
              height: 172.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.w),
                border: Border.all(color: Color(0xFFDFDFDF), width: 2.w),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    child: Offstage(
                      offstage: _noticeListList[index].isRead == null ||
                              _noticeListList[index].isRead == 0
                          ? false
                          : true,
                      child: Container(
                        width: 100.w,
                        height: 35.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ColorConfig.themeColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.w),
                            bottomRight: Radius.circular(10.w),
                          ),
                        ),
                        child: Text('未读',style: TextStyle(
                          color: Colors.white
                        ),),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40.w,
                    left: 40.w,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_noticeListList[index].title}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 28.sp,
                                    color: ColorConfig.themeColor),
                              ),
                              Text(
                                '${_noticeListList[index].createtime}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 24.sp,
                                    color: ColorConfig.themeColor),
                              ),
                            ],
                          ),
                          width: 620.w,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16.w),
                          child: Text(
                            '${_noticeListList[index].summary}',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 24.sp,
                                color: ColorConfig.themeColor),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
