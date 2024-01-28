import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tob/entity/address/address_list_entity.dart';
import 'package:tob/global/address.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';

class AddressListPage extends StatefulWidget {
  final String type;

  AddressListPage({this.type});

  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  int _page = 1;
  int _limit = 5;
  AddressListEntity _addressListEntity;
  List<AddressListList> _addressListList = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  //加载
  void _onLoading() {
    Http.getInstance().addressList(page: _page, limit: _limit).then((value) {
      _addressListEntity = value;
      if (mounted) {
        if (_addressListEntity.xList.length > 0) {
          _page++;
          setState(() {
            _addressListList.addAll(_addressListEntity.xList);
          });
          if (_addressListEntity.xList.length == _addressListEntity.count) {
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
    Http.getInstance().addressList(page: _page, limit: _limit).then((value) {
      _addressListEntity = value;
      if (mounted) {
        _addressListList.clear();
        if (_addressListEntity.xList.length > 0) {
          _page++;
          _addressListList.addAll(_addressListEntity.xList);
          if (_addressListEntity.xList.length == _addressListEntity.count) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('物流地址'),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        top: false,
        minimum: EdgeInsets.only(bottom: 60.w, top: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                navTo(context, Routes.addressEdit).then((value) {
                  if (value == true) {
                    Future.delayed(Duration(microseconds: 500)).then((value) {
                      _refreshController.requestRefresh();
                    });
                  }
                });
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(484.w, 96.w)),
                backgroundColor:
                    MaterialStateProperty.all(ColorConfig.themeColor),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(48.w),
                    ),
                  ),
                ),
              ),
              child: Text(
                "新增地址",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 32.sp,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: addressList(),
            ),
          ),
        ],
      ),
    );
  }

  addressList() {
    TextStyle style = TextStyle(
      fontSize: 28.sp,
      color: ColorConfig.fontColorBlack,
      fontWeight: FontWeight.w500,
    );

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _addressListList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            if (widget.type == null) {
              Address.setAddress(_addressListList[index]);
              Navigator.pop(context, _addressListList[index]);
            }
          },
          child: Container(
            width: 690.w,
            margin: EdgeInsets.only(top: 30.w, left: 30.w, right: 30.w),
            padding: EdgeInsets.all(30.w),
            decoration: comBoxDecoration(),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 300.w,
                      child: Text(
                        '${_addressListList[index].name}',
                        style: style,
                      ),
                    ),
                    Container(
                      width: 200.w,
                      child: Text(
                        '${_addressListList[index].mobile}',
                        style: style,
                      ),
                    ),
                    Container(
                      width: 130.w,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_right,
                        size: 98.w,
                        color: Color(0xffA5BFED),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${_addressListList[index].city.replaceAll('/', ' ') + " " + _addressListList[index].address}',
                    style: style,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 2.w,
                  margin: EdgeInsets.only(top: 30.w, bottom: 30.w),
                  color: ColorConfig.themeColor[100],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    eleButton(
                        color: Color(0xffE3E3E3),
                        width: 168.w,
                        height: 72.w,
                        circular: 16.w,
                        con: '删除',
                        func: () {
                          KlAlert.showAlert(
                              content: '确认删除？\n删除后不可恢复',
                              sureFunc: () {
                                Loading.show();
                                Http.getInstance()
                                    .deleteAddress(
                                        rid: _addressListList[index].id)
                                    .then((value) {
                                  showToast('删除成功');
                                  _addressListList.removeAt(index);
                                  MyRoute.router.pop(context);
                                  setState(() {});
                                }).whenComplete(() => Loading.dismiss());
                              },
                              cancelFunc: () {
                                MyRoute.router.pop(context);
                              });
                        }),
                    SizedBox(width: 64.w),
                    eleButton(
                      color: ColorConfig.themeColor,
                      width: 168.w,
                      height: 72.w,
                      circular: 16.w,
                      con: '编辑',
                      func: () {
                        MyRoute.router
                            .navigateTo(
                                context,
                                Routes.addressEdit +
                                    "?id=${_addressListList[index].id}")
                            .then(
                          (value) {
                            if (value == true) {
                              Future.delayed(Duration(microseconds: 500)).then(
                                (value) {
                                  _refreshController.requestRefresh();
                                },
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
