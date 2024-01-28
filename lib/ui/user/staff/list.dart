import 'package:extended_image/extended_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tob/entity/staff/staff_list_entity.dart';
import 'package:tob/entity/user_info_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/bloc/staff.dart';
import 'package:tob/widget/common_widget.dart';

import 'dialog/invite.dart';

class StaffListPage extends StatefulWidget {
  const StaffListPage({Key key}) : super(key: key);

  @override
  _StaffListPageState createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> {
  TextEditingController _searchController = new TextEditingController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  int _page = 1;
  int _limit = 15;
  StaffListEntity _staffListEntity;
  List<StaffListList> _staffListEntityList = [];
  UserInfoEntity userInfoEntity = UserInfo.getUserInfo();

  //加载
  void _onLoading() {
    Http.getInstance()
        .staffList(
            page: _page,
            limit: _limit,
            bid: UserInfo.getUserInfo().dealerId,
            keyWord: _searchController.text)
        .then((value) {
      _staffListEntity = value;
      if (mounted) {
        if (_staffListEntity.xList.length > 0) {
          _page++;
          setState(() {
            _staffListEntityList.addAll(_staffListEntity.xList);
          });
          if (_staffListEntity.xList.length == _staffListEntity.count) {
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
    _staffListEntityList.clear();
    setState(() {

    });
    _refreshController.resetNoData();
    Http.getInstance()
        .staffList(
            page: _page,
            limit: _limit,
            bid: UserInfo.getUserInfo().dealerId,
            keyWord: _searchController.text)
        .then((value) {
      _staffListEntity = value;
      if (mounted) {
        _staffListEntityList.clear();
        if (_staffListEntity.xList.length > 0) {
          _page++;
          _staffListEntityList.addAll(_staffListEntity.xList);
          if (_staffListEntity.xList.length == _staffListEntity.count) {
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
    return Scaffold(
      backgroundColor: Color(0xffF1F1F1),
      appBar: AppBar(
        title: Text(
          "员工列表",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        brightness: Brightness.dark,
        actions: [
          isManager()
              ? InkWell(
                  onTap: () {
                    navTo(context, Routes.staffManage).then((value){
                        _refreshController.requestRefresh();
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 30.w, left: 30.w),
                    child: staffApplyCount(Text(
                      '管理',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: isManager()
          ? SafeArea(
              child: Container(
                padding: EdgeInsets.only(
                    left: 118.w, right: 118.w, bottom: 20.w, top: 20.w),
                child: eleButton(
                    width: 513.w,
                    height: 80.w,
                    con: "一键邀请",
                    circular: 40.w,
                    color: ColorConfig.themeColor,
                    func: () {
                      _alertSimpleDialog();
                    }),
              ),
            )
          : SizedBox.shrink(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //  搜索
          search(),
          //  企业成员
          member(),
        ],
      ),
    );
  }

  search() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 19.w, bottom: 25.w),
        width: 623.w,
        height: 60.w,
        padding: EdgeInsets.only(left: 31.w, right: 31.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              color: Color(0xff999999),
              size: 35.w,
            ),
            SizedBox(width: 20.w),
            Container(
              alignment: Alignment.centerLeft,
              width: 500.w,
              child: TextField(
                textInputAction: TextInputAction.search,
                controller: _searchController,
                onSubmitted: (value) {
                  _refreshController.requestRefresh();
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 20.w),
                    hintText: "请输入关键字",
                    hintStyle: TextStyle(
                      color: Color(
                        0xff999999,
                      ),
                    ),
                    border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }

  member() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(bottom: 30.h),
        width: 688.w,
        padding:
            EdgeInsets.only(left: 24.w, right: 23.w, top: 26.h, bottom: 26.h),
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
                  "企业成员",
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
                      "共${_staffListEntity == null ? "0" : _staffListEntity.count}人",
                      style: TextStyle(
                          fontSize: 24.sp,
                          color: Color(0xff999999),
                          fontWeight: FontWeight.bold,
                          height: 1),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Color(0xff999999),
                      size: 30.sp,
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
      itemCount: _staffListEntityList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width: double.infinity,
          height: 134.w,
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
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                ),
                child: showImageNetwork(img:_staffListEntityList[index].avatar ,w: 100.w,h: 100.w)
              ),
              SizedBox(width: 44.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25.w),
                  Text(
                    "${_staffListEntityList[index].username}",
                    style: TextStyle(
                      fontSize: 36.sp,
                      height: 1,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff333333),
                    ),
                  ),
                  SizedBox(height: 22.w),
                  Text(
                    "${_staffListEntityList[index].identity}",
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
        );
      },
    );
  }

  _alertSimpleDialog() async {
    var alertDialogs = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StaffInvite();
        });
    return alertDialogs;
  }

  /*
   * 判断是不是管理员
   */
  bool isManager() {
    return userInfoEntity.ifLoginAdmin == '2' ? true : false;
  }
}
