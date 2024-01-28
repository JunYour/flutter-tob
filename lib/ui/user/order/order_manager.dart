import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tob/bloc/tab_purchase/tab_purchase_list_bloc.dart';
import 'package:tob/entity/tab_purchase/car_order_list_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/ui/user/order/orderStatusBtn.dart';
import 'package:tob/widget/loading.dart';

class UserOrderManagerPage extends StatefulWidget {
  const UserOrderManagerPage({Key key}) : super(key: key);

  @override
  _UserOrderManagerPageState createState() => _UserOrderManagerPageState();
}

class _UserOrderManagerPageState extends State<UserOrderManagerPage> {
  int _page = 1;
  int _limit = 5;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  List _statusList = [
    {"name": "全部订单", "chose": true, "id": 0},
    {"name": "审核中", "chose": false, "id": 1},
    {"name": "签合同", "chose": false, "id": 2},
    {"name": "待付款", "chose": false, "id": 3},
    {"name": "待发车", "chose": false, "id": 4},
    {"name": "已发车", "chose": false, "id": 5},
    {"name": "已收车", "chose": false, "id": 6},
    {"name": "回传资料", "chose": false, "id": 7},
    {"name": "已完成", "chose": false, "id": 8},
    {"name": "已取消", "chose": false, "id": 9},
  ];
  int _choseStatusListIndex = 0;
  CarOrderListEntity _carOrderListEntity;
  List<CarOrderListList> _carOrderListList = [];

  //加载
  void _onLoading() {
    Http.getInstance()
        .carOrderList(
            page: _page,
            limit: _limit,
            status: _statusList[_choseStatusListIndex]['id'])
        .then((value) {
      _carOrderListEntity = value;
      if (mounted) {
        if (_carOrderListEntity.xList.length > 0) {
          _page++;
          // setState(() {
          _carOrderListList.addAll(_carOrderListEntity.xList);
          BlocProvider.of<TabPurchaseListBloc>(context)
              .add(TabPurchaseEntityEvent(_carOrderListList));
          // });
          if (_carOrderListEntity.xList.length >= _limit) {
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
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
        .carOrderList(
            page: _page,
            limit: _limit,
            status: _statusList[_choseStatusListIndex]['id'])
        .then((value) {
      _carOrderListEntity = value;
      if (mounted) {
        _carOrderListList.clear();
        if (_carOrderListEntity.xList.length > 0) {
          _page++;
          _carOrderListList.addAll(_carOrderListEntity.xList);
          if (_carOrderListEntity.xList.length >= _limit) {
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        } else {
          _refreshController.loadNoData();
        }
        BlocProvider.of<TabPurchaseListBloc>(context)
            .add(TabPurchaseEntityEvent(_carOrderListList));
        _refreshController.refreshCompleted();
      }
    }).catchError((error) {
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.bgColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text("订单管理"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          //  订单状态选择
          orderStatus(),
          //  订单列表
          orderList(),
        ],
      ),
    );
  }

//  订单状态选择
  orderStatus() {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.only(left: 30.w, right: 30.w, top: 22.w, bottom: 18.w),
      height: 170.w,
      color: Colors.white,
      child: Wrap(
        spacing: 22.w,
        runSpacing: 10.w,
        children: [
          for (int i = 0; i < _statusList.length; i++)
            GestureDetector(
              onTap: () {
                if (_choseStatusListIndex != i) {
                  _statusList.asMap().forEach((key, value) {
                    _statusList[key]['chose'] = false;
                  });
                  _statusList[i]['chose'] = true;
                  _choseStatusListIndex = i;
                  _refreshController.requestRefresh();
                  setState(() {});
                }
              },
              child: orderStatusText(
                  title: "${_statusList[i]['name']}",
                  chose: _statusList[i]['chose']),
            ),
        ],
      ),
    );
  }

  orderStatusText({@required String title, bool chose = false}) {
    return Container(
      width: 150.w,
      height: 40.sp,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: chose ? ColorConfig.themeColor : Colors.transparent,
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: Text(
        "$title",
        style: TextStyle(
          fontSize: 28.sp,
          color: chose ? Colors.white : Color(0xff333333),
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    );
  }

  //订单列表
  orderList() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 20.w),
        child: BlocBuilder<TabPurchaseListBloc, TabPurchaseListState>(
          builder: (context, state) {
            if (state is TabPurchaseListEntityState) {
              _carOrderListList = state.carOrderListList;
            }
            return SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                itemCount: _carOrderListList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      navTo(
                          context,
                          Routes.userOrderDetail +
                              "?oid=${_carOrderListList[index].id}");
                    },
                    child: Container(
                      width: 690.w,
                      margin: EdgeInsets.only(
                          left: 30.w, right: 30.w, bottom: 16.w),
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.w),
                      ),
                      child: Column(
                        children: [
                          //状态-订单号
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              stateText(state: _carOrderListList[index].status),
                              Text(
                                "订单号：${_carOrderListList[index].pNum}",
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  height: 1,
                                  color: Color(0xff333333),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.w),
                          //车型名称-时间
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 350.w,
                                child: Text(
                                  "${_carOrderListList[index].specName}",
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    height: 1,
                                    color: Color(0xff333333),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                "${_carOrderListList[index].createtime}",
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  height: 1,
                                  color: Color(0xff999999),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.w),
                          //数量-金额
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 325.w,
                                child: Row(
                                  children: [
                                    for (int i = 0;
                                        i <
                                            _carOrderListList[index]
                                                .colors
                                                ?.length;
                                        i++)
                                      if (i < 3)
                                        Container(
                                          width: 100.w,
                                          child: Column(
                                            children: [
                                              num("${_carOrderListList[index].colors[i].colorName}",
                                                  overflow: true),
                                              num("x"),
                                              num("${_carOrderListList[index].colors[i].sum}"),
                                            ],
                                          ),
                                        ),
                                    if (_carOrderListList[index].colors.length >
                                        3)
                                      Column(
                                        children: [
                                          num(""),
                                          num("..."),
                                          num(""),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 325.w,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              child: Image.asset(
                                                'assets/pc_car.png',
                                                color: ColorConfig.themeColor,
                                                width: 36.w,
                                                height: 36.w,
                                              ),
                                            ),
                                            SizedBox(width: 20.w),
                                            num("采购总数量"),
                                          ],
                                        ),
                                        num("${_carOrderListList[index].countSum}"),
                                      ],
                                    ),
                                    SizedBox(height: 16.w),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              child: Image.asset(
                                                'assets/pc_sure.png',
                                                color: ColorConfig.themeColor,
                                                width: 36.w,
                                                height: 36.w,
                                              ),
                                            ),
                                            SizedBox(width: 20.w),
                                            num("金额合计:"),
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          width: 130.w,
                                          child: num(
                                            calcMoney(
                                                  _carOrderListList[index]
                                                      .colors,
                                                ) +
                                                '万',
                                            overflow: true
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          comOrderStatusBtn(
                              context: context,
                              status: _carOrderListList[index].status,
                              type: 1,
                              carOrderListList: _carOrderListList[index],
                              contractStatus:
                                  _carOrderListList[index]?.contract?.status,
                              //签合同
                              signContract: () {
                                navTo(
                                        context,
                                        Routes.userOrderContract +
                                            "?id=" +
                                            _carOrderListList[index]
                                                .id
                                                .toString())
                                    .then((value) {
                                  if (value != null) {
                                    int status =
                                        int.parse(value['status'].toString());
                                    _carOrderListList[index].status = status;
                                    BlocProvider.of<TabPurchaseListBloc>(
                                            context)
                                        .add(new TabPurchaseEntityEvent(
                                            _carOrderListList));
                                  }
                                });
                              },
                              //去支付
                              payFunc: () {
                                navTo(
                                        context,
                                        Routes.tabPurchasePayInfo +
                                            "?pid=${_carOrderListList[index].id.toString()}" +
                                            "&image=${Uri.encodeComponent(_carOrderListList[index].payVoucherImage.toString())}" +
                                            "&type=upd" +
                                            "&error=${_carOrderListList[index].payVoucherRemark}")
                                    .then(
                                  (value) {
                                    if (value != null) {
                                      int status =
                                          int.parse(value['status'].toString());
                                      _carOrderListList[index].status = status;
                                      _carOrderListList[index]
                                          .payVoucherStatus = '2';
                                      BlocProvider.of<TabPurchaseListBloc>(
                                              context)
                                          .add(new TabPurchaseEntityEvent(
                                              _carOrderListList));
                                    }
                                  },
                                );
                              },
                              cancelFunc: () {
                                Loading.show(status: '取消订单中');
                                Http.getInstance()
                                    .carOrderCancel(
                                        id: _carOrderListList[index].id)
                                    .then((value) {
                                  _carOrderListList[index].status = 9;
                                  BlocProvider.of<TabPurchaseListBloc>(context)
                                      .add(new TabPurchaseEntityEvent(
                                          _carOrderListList));
                                  Loading.toast(msg: "取消成功");
                                }).whenComplete(() => Loading.dismiss());
                              },
                              deleteFunc: () {
                                Loading.show(status: '删除订单中');
                                Http.getInstance()
                                    .carOrderDelete(
                                        oid: _carOrderListList[index].id)
                                    .then((value) {
                                  _carOrderListList.removeAt(index);
                                  BlocProvider.of<TabPurchaseListBloc>(context)
                                      .add(new TabPurchaseEntityEvent(
                                          _carOrderListList));
                                  Loading.toast(msg: "删除成功");
                                }).whenComplete(() => Loading.dismiss());
                              }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  num(String con, {bool overflow = false}) {
    return Text(
      "$con",
      style: TextStyle(
        fontSize: 28.sp,
        height: 1,
        color: ColorConfig.themeColor,
        fontWeight: FontWeight.bold,
      ),
      maxLines: overflow ? 1 : null,
      overflow: overflow ? TextOverflow.ellipsis : null,
    );
  }

  stateText({int state}) {
    String text = "审核中";
    Color color = ColorConfig.themeColor;
    switch (state) {
      case 1:
        break;
      case 2:
        text = "待签合同";
        break;
      case 3:
        text = "待付款";
        color = Colors.red;
        break;
      case 4:
        text = "待发车";
        break;
      case 5:
        text = "已发车";
        break;
      case 6:
        text = "已收车";
        break;
      case 7:
        text = "回传资料";
        break;
      case 8:
        text = "已完成";
        color = Colors.grey;
        break;
      case 9:
        text = "已取消";
        color = Colors.grey;
        break;
      default:
        break;
    }

    return Text(
      "$text",
      style: TextStyle(color: color),
    );
  }
}
