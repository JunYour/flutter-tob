import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tob/entity/staff/apply_list_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/widget/bloc/staff.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';

class StaffExaminePage extends StatefulWidget {
  const StaffExaminePage({Key key}) : super(key: key);

  @override
  _StaffExaminePageState createState() => _StaffExaminePageState();
}

class _StaffExaminePageState extends State<StaffExaminePage> {
  TextEditingController _searchController = new TextEditingController();

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  int _page = 1;
  int _limit = 15;
  ApplyListEntity _applyListEntity;
  List<ApplyListList> _applyListList = [];

  //加载
  void _onLoading() {
    Http.getInstance()
        .applyList(
            page: _page, limit: _limit, bid: UserInfo.getUserInfo().dealerId)
        .then((value) {
      _applyListEntity = value;
      if (mounted) {
        if (_applyListEntity.xList.length > 0) {
          _page++;
          setState(() {
            _applyListList.addAll(_applyListEntity.xList);
          });
          if (_applyListEntity.xList.length == _applyListEntity.count) {
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
        .applyList(
            page: _page, limit: _limit, bid: UserInfo.getUserInfo().dealerId)
        .then((value) {
      _applyListEntity = value;
      if (mounted) {
        _applyListList.clear();
        if (_applyListEntity.xList.length > 0) {
          _page++;
          _applyListList.addAll(_applyListEntity.xList);
          if (_applyListEntity.xList.length == _applyListEntity.count) {
            _refreshController.loadNoData();
          }
        } else {
          _refreshController.loadNoData();
        }
        _refreshController.refreshCompleted();
        setState(() {});
      }
    }).catchError((error) {
      _refreshController.refreshCompleted();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        startStaffApplyCountBloc();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Color(0xffF1F1F1),
        appBar: AppBar(
          title: Text(
            "申请审核",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          brightness: Brightness.dark,
          actions: [
            InkWell(
              onTap: () {
                KlAlert.showAlert(
                    content: "是否清除?",
                    sureFunc: () {
                      MyRoute.router.pop(context);
                      Loading.show();
                      Http.getInstance()
                          .applyClear(bid: UserInfo.getUserInfo().dealerId)
                          .then((value) {
                            _onRefresh();
                      }).whenComplete(() => Loading.dismiss());
                    },
                    cancelFunc: () {
                      MyRoute.router.pop(context);
                    });
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 30.w, left: 30.w),
                child: Text(
                  '清除',
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //  企业成员
            member(),
          ],
        ),
      ),
    );
  }

  member() {
    return Expanded(
      child: Container(
        width: 690.w,
        margin:
            EdgeInsets.only(top: 30.w, left: 30.w, right: 30.w, bottom: 10.w),
        padding:
            EdgeInsets.only(left: 24.w, right: 23.w, top: 26.w, bottom: 26.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.w),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "申请列表",
                  style: TextStyle(
                    fontSize: 30.sp,
                    color: ColorConfig.themeColor[500],
                    height: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "共${_applyListEntity != null ? _applyListEntity.count : 0}人",
                      style: TextStyle(
                          fontSize: 24.sp,
                          color: Color(0xff999999),
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Color(0xff999999),
                      size: 30.w,
                    ),
                  ],
                ),
              ],
            ),

            //  员工列表
            Expanded(
              child: Container(
                width: double.infinity,
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: memberList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  memberList() {
    return ListView.builder(
      itemCount: _applyListList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.w,
                color: Color(0xff999999),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: showImageNetwork(img:_applyListList[index].avatar ,w: 100.w,h: 100.w)
                  ),
                  SizedBox(width: 20.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 350.w,
                        child: Text(
                          "${_applyListList[index].username}",
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff333333),
                          ),
                        ),
                      ),
                      SizedBox(height: 22.w),
                      Text(
                        "${_applyListList[index].createtime}",
                        style: TextStyle(
                          fontSize: 24.sp,
                          height: 1,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff999999),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (_applyListList[index].status == 1)
                Column(
                  children: [
                    Container(
                      height: 50.w,
                      child: eleButton(
                          width: 120.w,
                          height: 50.w,
                          con: "同意",
                          circular: 10.w,
                          color: ColorConfig.themeColor,
                          func: () {
                            KlAlert.showAlert(
                                content: "确认同意该申请？",
                                sureFunc: () {
                                  Loading.show();
                                  Http.getInstance()
                                      .applyAgree(id: _applyListList[index].id)
                                      .then((value) {
                                    _applyListList[index].status = 2;
                                    setState(() {});
                                    MyRoute.router.pop(context);
                                  }).whenComplete(() => Loading.dismiss());
                                },
                                cancelFunc: () {
                                  MyRoute.router.pop(context);
                                });
                          }),
                    ),
                    SizedBox(height: 20.w),
                    Container(
                      height: 50.w,
                      child: eleButton(
                          width: 120.w,
                          height: 50.w,
                          con: "拒绝",
                          circular: 10.w,
                          color: Color(0xffe21c1c),
                          func: () {
                            KlAlert.showAlert(
                                content: "确认拒绝该申请？",
                                sureFunc: () {
                                  Loading.show();
                                  Http.getInstance()
                                      .applyRefuse(id: _applyListList[index].id)
                                      .then((value) {
                                    setState(() {
                                      _applyListList[index].status = 3;
                                    });
                                    MyRoute.router.pop(context);
                                  }).whenComplete(() => Loading.dismiss());
                                },
                                cancelFunc: () {
                                  MyRoute.router.pop(context);
                                });
                          }),
                    ),
                  ],
                ),
              if (_applyListList[index].status == 2)
                Text(
                  '已同意',
                  style: TextStyle(
                      color: Color(0xff999999),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      height: 1),
                ),
              if (_applyListList[index].status == 3)
                Text(
                  '已拒绝',
                  style: TextStyle(
                      color: Color(0xff999999),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      height: 1),
                )
            ],
          ),
        );
      },
    );
  }
}
