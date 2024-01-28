import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tob/entity/staff/staff_list_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/common_widget.dart';

class StaffPreTransfer extends StatefulWidget {
  const StaffPreTransfer({Key key}) : super(key: key);

  @override
  _StaffPreTransferState createState() => _StaffPreTransferState();
}

class _StaffPreTransferState extends State<StaffPreTransfer> {
  TextEditingController _searchController = new TextEditingController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  int _page = 1;
  int _limit = 15;
  StaffListEntity _staffListEntity;
  List<StaffListList> _staffListEntityList = [];

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
    return Scaffold(
      backgroundColor: Color(0xffF1F1F1),
      appBar: AppBar(
        title: Text(
          "权限转让",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
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
                  _onRefresh();
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
        width: 688.w,
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
                height: MediaQuery.of(context).size.height - 500.w,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
              if (_staffListEntityList[index].id == UserInfo.getUserInfoId())
                eleButton(
                    width: 150.w,
                    height: 60.w,
                    con: "我",
                    circular: 30.w,
                    color: ColorConfig.themeColor,
                    func: null),
              if (_staffListEntityList[index].id != UserInfo.getUserInfoId())
                eleButton(
                  width: 150.w,
                  height: 60.w,
                  con: "权限转让",
                  circular: 30.w,
                  color: ColorConfig.themeColor,
                  func: () {
                    navTo(context, Routes.staffTransfer+"?id="+_staffListEntityList[index].id.toString()).then((value){
                      _refreshController.requestRefresh();
                    });
                  },
                )
            ],
          ),
        );
      },
    );
  }
}
