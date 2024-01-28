import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tob/bloc/purchase/list/purchase_list_bloc.dart';
import 'package:tob/bloc/purchase/num/purchase_num_bloc.dart';
import 'package:tob/entity/purchase/purchase_list_entity.dart';
import 'package:tob/entity/purchase/purchase_num_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';

class PurchaseListPage extends StatefulWidget {
  final int oid;
  final int countSum;
  final int count;
  final int status;
  PurchaseListPage(
      {@required this.oid, @required this.countSum, @required this.count,@required this.status});

  @override
  _PurchaseListPageState createState() => _PurchaseListPageState();
}

class _PurchaseListPageState extends State<PurchaseListPage> {
  int _page = 1;
  int _limit = 5;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  List<PurchaseListList> _purchaseListList = [];
  PurchaseListEntity _purchaseListEntity;
  int _opacity = 0;
  String _stateName = "全部采购";
  List purchaseState = [
    {'title': '全部采购', 'chose': true},
    {'title': '待付款', 'chose': false},
    {'title': '待发车', 'chose': false},
    {'title': '已发车', 'chose': false},
    {'title': '已收车', 'chose': false},
    {'title': '回传资料', 'chose': false},
    {'title': '已完成', 'chose': false},
    {'title': '已取消', 'chose': false}
  ];
  int _state = 0;

  //加载
  void _onLoading() {
    Http.getInstance()
        .purchaseList(
            oid: widget.oid, status: _state, page: _page, limit: _limit)
        .then((value) {
      _purchaseListEntity = value;
      if (mounted) {
        if (_purchaseListEntity.xList.length > 0) {
          _page++;
          setState(() {
            _purchaseListList.addAll(_purchaseListEntity.xList);
          });
          if (_purchaseListEntity.xList.length == _purchaseListEntity.count) {
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
    BlocProvider.of<PurchaseListBloc>(context)
        .add(PurchaseListRefreshEvent(false));
    BlocProvider.of<PurchaseNumBloc>(context)
        .add(PurchaseNumInitEvent(oid: widget.oid));
    Http.getInstance()
        .purchaseList(
            oid: widget.oid, status: _state, page: _page, limit: _limit)
        .then((value) {
      _purchaseListEntity = value;
      if (mounted) {
        _purchaseListList.clear();
        if (_purchaseListEntity.xList.length > 0) {
          _page++;
          _purchaseListList.addAll(_purchaseListEntity.xList);
          if (_purchaseListEntity.xList.length == _purchaseListEntity.count) {
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
    BlocProvider.of<PurchaseNumBloc>(context)
        .add(PurchaseNumInitEvent(oid: widget.oid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: commonAppbarTitle(title: '采购管理'),
        body: Stack(
          children: [
            //顶部蓝条
            Align(
              alignment: Alignment.topLeft,
              child: BlocBuilder<PurchaseListBloc, PurchaseListState>(
                builder: (context, state) {
                  if (state is PurchaseListRefreshState) {
                    if (state.refresh) {
                      Future.delayed(Duration.zero).then((value) {
                        _refreshController.requestRefresh(
                            duration: Duration(milliseconds: 200));
                      });
                    }
                  }
                  return Container(
                    color: ColorConfig.themeColor,
                    height: 88.w,
                  );
                },
              ),
            ),
            //列表
            Positioned(
              top: 400.w,
              child: Container(
                width: 750.w,
                height: MediaQuery.of(context).size.height - 400.w - 240.w,
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: purchaseListData(),
                ),
              ),
            ),
            //采购数量
            Positioned(
              top: 32.w,
              left: 30.w,
              right: 30.w,
              child: Container(
                width: 690.w,
                height: 180.w,
                padding: EdgeInsets.only(left: 62.w, right: 54.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.w),
                  border: Border.all(color: Color(0xFFEFEFF4), width: 2.w),
                ),
                child: BlocBuilder<PurchaseNumBloc, PurchaseNumState>(
                    builder: (context, state) {
                  PurchaseNumEntity _purchaseNumEntity;
                  if (state is PurchaseNumInitState) {
                    _purchaseNumEntity = state.purchaseNumEntity;
                  }
                  return Column(
                    children: [
                      countRow('assets/pc_car.png', 39.w, 36.w, '采购数',
                          '${_purchaseNumEntity?.shouldCount}台'),
                      countRow('assets/pc_sure.png', 39.w, 36.w, '已采购',
                          '${_purchaseNumEntity?.alreadyCount}台'),
                      countRow('assets/pc_time.png', 39.w, 37.5.w, '剩余可采购',
                          '${_purchaseNumEntity?.canCount}台'),
                    ],
                  );
                }),
              ),
            ),
            //全部采购选项
            Positioned(
              top: 240.w,
              left: 30.w,
              right: 30.w,
              child: Container(
                width: 690.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.w),
                  border: Border.all(color: Color(0xFFEFEFF4), width: 2.w),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 122.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 30.w, right: 30.w),
                              width: 88.w,
                              height: 88.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(44.w),
                                color: ColorConfig.themeColor,
                              ),
                              alignment: Alignment.center,
                              child: Image.asset('assets/order_manager.png',
                                  width: 66.w, height: 56.w)),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (_opacity > 0) {
                                  _opacity = 0;
                                } else {
                                  _opacity = 1;
                                }
                              });
                            },
                            child: Container(
                              width: 490.w,
                              margin: EdgeInsets.only(right: 34.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('$_stateName'),
                                  Icon(
                                    _opacity == 0
                                        ? Icons.arrow_drop_down
                                        : Icons.arrow_drop_up,
                                    size: 98.w,
                                    color: Color(0xffA5BFED),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Offstage(
                      child: Container(
                        width: 690.w,
                        child: Wrap(
                          children: [
                            for (int i = 0; i < purchaseState.length; i++)
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    for (int k = 0;
                                        k < purchaseState.length;
                                        k++) {
                                      purchaseState[k]['chose'] = false;
                                    }
                                    purchaseState[i]['chose'] = true;
                                    _stateName = purchaseState[i]['title'];
                                    _state = i;
                                    _opacity = 0;
                                    _refreshController.requestRefresh(
                                        duration: Duration(milliseconds: 1));
                                  });
                                },
                                child: Container(
                                  width: 220.w,
                                  // margin: EdgeInsets.only(left: 158.w),
                                  height: 78.w,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${purchaseState[i]['title']}',
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.w500,
                                      color: purchaseState[i]['chose']
                                          ? ColorConfig.themeColor
                                          : Color(0xff242A37),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      offstage: _opacity == 1 ? false : true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BlocBuilder<PurchaseNumBloc, PurchaseNumState>(
          builder: (context, state) {
            PurchaseNumEntity _purchaseNumEntity;
            if (state is PurchaseNumInitState) {
              _purchaseNumEntity = state.purchaseNumEntity;
            }
            if (_purchaseNumEntity == null ||
                _purchaseNumEntity.canCount <= 0 || widget.status > 1) {
              return SafeArea(
                bottom: true,
                top: false,
                minimum: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: null,
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(Size(436.w, 72.w)),
                        backgroundColor: MaterialStateProperty.all(
                            ColorConfig.themeColor[100]),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.w),
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        "发起采购",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 32.sp,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SafeArea(
                bottom: true,
                top: false,
                minimum: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        MyRoute.router
                            .navigateTo(context,
                                Routes.launchPurchase + "?oid=${widget.oid}",
                                transition: TransitionType.fadeIn)
                            .then((value) {
                          if (value != null && value == true) {
                            _refreshController.requestRefresh();
                          }
                        });
                      },
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(Size(436.w, 72.w)),
                        backgroundColor:
                            MaterialStateProperty.all(ColorConfig.themeColor),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.w),
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        "发起采购",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 32.sp,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }

  //数量
  countRow(
    String assets,
    double width,
    double height,
    String title,
    String num,
  ) {
    TextStyle style = TextStyle(
      color: ColorConfig.themeColor,
      fontWeight: FontWeight.w500,
      fontSize: 28.sp,
    );
    return Container(
      height: 58.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                assets,
                width: width,
                height: height,
                color: ColorConfig.themeColor,
              ),
              SizedBox(width: 18.w),
              Text(
                title,
                style: style,
              ),
            ],
          ),
          Text(
            num,
            style: style,
          ),
        ],
      ),
    );
  }

  purchaseListData() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _purchaseListList.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            MyRoute.router.navigateTo(
                context,
                Routes.purchaseDetail +
                    '?pid=${_purchaseListList[index].id}&oid=${widget.oid}',
                transition: TransitionType.fadeIn);
          },
          child: Container(
            width: 690.w,
            padding: EdgeInsets.only(
                left: 30.w, right: 30.w, top: 38.w, bottom: 68.w),
            margin: EdgeInsets.only(left: 30.w, right: 30.w, bottom: 48.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.w),
              border: Border.all(color: Color(0xFFEFEFF4), width: 2.w),
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 14.w),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffA5BFED),
                          width: 8.w,
                        ),
                      ),
                    ),
                    child: statusText(
                      int.parse(
                        _purchaseListList[index].status.toString(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cGBHText('采购编号'),
                    cGBHText('${_purchaseListList[index].pNum}'),
                  ],
                ),
                SizedBox(height: 24.w),
                Container(
                  padding: EdgeInsets.only(right: 30.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      cJSJText('创建时间'),
                      cJSJText('${_purchaseListList[index].createtime}'),
                    ],
                  ),
                ),
                Container(
                  height: 2.w,
                  margin: EdgeInsets.only(top: 10.w, bottom: 20.w),
                  color: Color(0xffF1F2F6),
                ),

                //价格
                priceCount(_purchaseListList[index].specs),
                //状态按钮
                SizedBox(height: 30.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Offstage(
                      offstage: _purchaseListList[index].status == "1" &&
                              (_purchaseListList[index].payVoucherStatus ==
                                      "1" ||
                                  _purchaseListList[index].payVoucherStatus ==
                                      "4")
                          ? false
                          : true,
                      child: Row(
                        children: [
                          stateButton('取消', Color(0xffDFDFDF), () {
                            KlAlert.showAlert(
                                content: '确认取消该采购单？',
                                sureFunc: () {
                                  Loading.show();
                                  Http.getInstance()
                                      .purchaseCancel(
                                          pid: _purchaseListList[index].id)
                                      .then((value) {
                                    _purchaseListList[index].status = '7';
                                    BlocProvider.of<PurchaseNumBloc>(context)
                                        .add(PurchaseNumInitEvent(oid: widget.oid));
                                    setState(() {});
                                    MyRoute.router.pop(context);
                                  }).whenComplete(() {
                                    Loading.dismiss();
                                  });
                                },
                                cancelFunc: () {
                                  MyRoute.router.pop(context);
                                });
                          }),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage: _purchaseListList[index].status == "1" &&
                              (_purchaseListList[index].payVoucherStatus ==
                                      "1" ||
                                  _purchaseListList[index].payVoucherStatus ==
                                      "4")
                          ? false
                          : true,
                      child: Row(
                        children: [
                          SizedBox(width: 16.w),
                          stateButton('修改', Color(0xffA5BFED), () {
                            MyRoute.router.navigateTo(
                                context,
                                Routes.launchPurchase +
                                    '?oid=${widget.oid}&purchaseListList=${Uri.encodeComponent(jsonEncode(_purchaseListList[index]))}',
                                transition: TransitionType.fadeIn);
                          }),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage: _purchaseListList[index].status == "1" &&
                              (_purchaseListList[index].payVoucherStatus ==
                                      "1" ||
                                  _purchaseListList[index].payVoucherStatus ==
                                      "4")
                          ? false
                          : true,
                      child: Row(
                        children: [
                          SizedBox(width: 16.w),
                          stateButton('去支付', ColorConfig.themeColor, () {
                            if (_purchaseListList[index].payVoucherStatus ==
                                '4') {
                              MyRoute.router.navigateTo(
                                  context,
                                  Routes.payInfoPage +
                                      "?pid=${_purchaseListList[index].id}&error=${Uri.encodeComponent(_purchaseListList[index].payVoucherRemark)}&img=${Uri.encodeComponent(_purchaseListList[index].payVoucherImage)}&type=upd",
                                  transition: TransitionType.inFromRight);
                            } else {
                              MyRoute.router.navigateTo(
                                  context,
                                  Routes.payInfoPage +
                                      "?pid=${_purchaseListList[index].id}&type=upd",
                                  transition: TransitionType.inFromRight);
                            }
                          }),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage:
                          int.parse(_purchaseListList[index].status) >= 5 &&
                                  int.parse(_purchaseListList[index].status) < 7
                              ? false
                              : true,
                      child: Row(
                        children: [
                          SizedBox(width: 16.w),
                          stateButton(int.parse(_purchaseListList[index].status)==5?'回传资料':'查看资料', ColorConfig.themeColor, () {
                            MyRoute.router.navigateTo(
                                context,
                                Routes.fileList +
                                    "?pid=${_purchaseListList[index].id}",
                                transition: TransitionType.fadeIn);
                          }),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage:
                          _purchaseListList[index].status == "3" ? false : true,
                      child: Row(
                        children: [
                          SizedBox(width: 16.w),
                          stateButton('确认收车', ColorConfig.themeColor, () {
                            MyRoute.router.navigateTo(
                                context,
                                Routes.receivedCar +
                                    "?pid=${_purchaseListList[index].id}",
                                transition: TransitionType.inFromRight);
                          }),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage:
                          int.parse(_purchaseListList[index].status) >= 4 &&
                                  int.parse(_purchaseListList[index].status) < 7
                              ? false
                              : true,
                      child: Row(
                        children: [
                          SizedBox(width: 16.w),
                          stateButton(
                            '收车单',
                            ColorConfig.themeColor,
                            () {
                              MyRoute.router.navigateTo(
                                  context,
                                  Routes.receivedCar +
                                      "?pid=${_purchaseListList[index].id}",
                                  transition: TransitionType.inFromRight);
                            },
                          ),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage: (_purchaseListList[index].payVoucherStatus ==
                                  "2" ||
                              _purchaseListList[index].payVoucherStatus == "3") && int.parse(_purchaseListList[index].status)  < 7
                          ? false
                          : true,
                      child: Row(
                        children: [
                          SizedBox(width: 16.w),
                          stateButton('付款凭证', ColorConfig.themeColor, () {
                            MyRoute.router.navigateTo(
                                context,
                                Routes.payInfoPage +
                                    "?pid=${_purchaseListList[index].id}&type=sel&img=${Uri.encodeComponent(_purchaseListList[index].payVoucherImage)}",
                                transition: TransitionType.inFromRight);
                          }),
                        ],
                      ),
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

  //状态
  Text statusText(int status) {
    String text = "";
    // 1=待付款,2=待发车,3=已发车,4=已收车,5=回传资料,6=已完成,7=已取消,8=已关闭
    switch (status) {
      case 1:
        text = "待付款";
        break;
      case 2:
        text = "待发车";
        break;
      case 3:
        text = "已发车";
        break;
      case 4:
        text = "已收车";
        break;
      case 5:
        text = "回传资料";
        break;
      case 6:
        text = "已完成";
        break;
      case 7:
        text = "已取消";
        break;
    }
    return Text(
      '$text',
      style: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w500,
        color: ColorConfig.themeColor,
      ),
    );
  }

  //状态按钮
  ElevatedButton stateButton(String con, Color color, Function func) {
    return ElevatedButton(
      onPressed: () {
        func();
      },
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(140.w, 60.w)),
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(20.w),
            ),
          ),
        ),
      ),
      child: Text(
        con,
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 24.sp, color: Colors.white),
      ),
    );
  }

  //价格Widget
  priceCount(List<PurchaseListListSpecs> spec) {
    TextStyle listStyle = TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.w500,
      color: Color(0xff436B8F),
    );

    pCRow(String title, String content) {
      return Container(
        width: double.infinity,
        // height: 50.w,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$title',
              style: TextStyle(
                fontSize: 24.sp,
                color: Color(0xff242A37),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '$content',
              style: TextStyle(
                fontSize: 28.sp,
                color: Color(0xff242A37),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    Container pCContainer(int type, String content, TextStyle style,
        Alignment align, {bool borderShow=false}) {
      BoxDecoration boxDecoration = BoxDecoration(
        border: Border(
          right: BorderSide(
            width: borderShow == true ? 1.0.w : 0,
            color: Colors.grey[300],
          ),
        ),
      );
      if(borderShow == false){
        boxDecoration = BoxDecoration();
      }
      return Container(
        width: 155.w * type,
        // height: double.infinity,
        alignment: align,
        decoration: boxDecoration,
        child: Text(
          '$content',
          style: style,
          // maxLines: 1,
          // overflow: TextOverflow.ellipsis,
        ),
      );
    }

    int count = 0;
    double price = 0;
    for (int i = 0; i < spec.length; i++) {
      count = count + int.parse(spec[i].count);
      price = price + double.parse(spec[i].price);
    }

    return Container(
      child: Column(
        children: [
          for (int i = 0; i < spec.length; i++)
            Container(
              // height: 58.w,
              padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: ColorConfig.themeColor[100], width: 1.w),
                ),
              ),
              child: Row(
                children: [
                  pCContainer(1, '${spec[i].colorName}', listStyle,
                      Alignment.centerLeft),
                  pCContainer(1, '${spec[i].count}台', listStyle,
                      Alignment.center),
                  pCContainer(1, '${spec[i].perprice}万', listStyle,
                      Alignment.center,borderShow: true),
                  pCContainer(1, '${spec[i].price}万', listStyle,
                      Alignment.centerRight),
                ],
              ),
            ),
          pCRow('数量合计', '$count台'),
          pCRow('金额合计', '$price万'),
        ],
      ),
    );
  }

  //采购编号
  cGBHText(String con) {
    return Text(
      con,
      style: TextStyle(
        color: Color(0xff242A37),
        fontWeight: FontWeight.w500,
        fontSize: 28.sp,
      ),
    );
  }

  //创建时间
  cJSJText(String con) {
    return Text(
      con,
      style: TextStyle(
        color: Color(0xff6D7278),
        fontWeight: FontWeight.w500,
        fontSize: 28.sp,
      ),
    );
  }
}
