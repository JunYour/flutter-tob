import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tob/entity/order/order_list_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/bloc/notice.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with AutomaticKeepAliveClientMixin {
  int _page = 1;
  int _limit = 5;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  List orderState = [
    {'title': '全部项目', 'chose': true},
    {'title': '进行中', 'chose': false},
    {'title': '已完成', 'chose': false},
    {'title': '已取消', 'chose': false}
  ];
  double _opacity = 0;
  int _state = 0;
  String _stateName = "全部项目";
  OrderListEntity _orderListEntity;
  List<OrderListList> _orderListList = [];

  @override
  void initState() {
    super.initState();
  }

  //加载
    void _onLoading() {
      Http.getInstance()
          .orderList(status: _state, page: _page, limit: _limit)
          .then((value) {
      _orderListEntity = value;
      if (mounted) {
        if (_orderListEntity.xList.length > 0) {
          _page++;
          setState(() {
            _orderListList.addAll(_orderListEntity.xList);
          });
          if (_orderListEntity.xList.length >= _limit) {
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
        .orderList(status: _state, page: _page, limit: _limit)
        .then((value) {
      _orderListEntity = value;
      if (mounted) {
        _orderListList.clear();
        if (_orderListEntity.xList.length > 0) {
          _page++;
          _orderListList.addAll(_orderListEntity.xList);
          if (_orderListEntity.xList.length == _orderListEntity.count) {
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
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '项目管理',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          //消息按钮
          IconButton(
            icon: iconNotice(),
            onPressed: () async{
              MyRoute.router.navigateTo(context, Routes.message,transition: TransitionType.inFromRight);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              color: ColorConfig.themeColor,
              height: 88.w,
            ),
          ),
          Positioned(
            top: 32.w,
            left: 30.w,
            right: 30.w,
            child: Container(
              width: 690.w,
              height: 162.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.w),
                border: Border.all(color: Color(0xFFEFEFF4), width: 2.w),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 30.w, right: 30.w),
                      width: 98.w,
                      height: 98.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(49.w),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          ),
          Positioned(
            top: 240.w,
            child: Container(
              width: 750.w,
              height: MediaQuery.of(context).size.height - 240.w - 250.w,
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: orderListData(),
              ),
            ),
          ),
          Positioned(
            top: 200.w,
            left: 30.w,
            child: Offstage(
              child: Container(
                width: 690.w,
                height: 320.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.w),
                  border: Border.all(color: Color(0xFFEFEFF4), width: 2.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < orderState.length; i++)
                      InkWell(
                        onTap: () {
                          setState(() {
                            for (int k = 0; k < orderState.length; k++) {
                              orderState[k]['chose'] = false;
                            }
                            orderState[i]['chose'] = true;
                            _stateName = orderState[i]['title'];
                            _state = i;
                            _opacity = 0;
                            _refreshController.requestRefresh(
                                duration: Duration(milliseconds: 1));
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 158.w),
                          height: 78.w,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${orderState[i]['title']}',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w500,
                              color: orderState[i]['chose']
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
          ),
        ],
      ),
    );
  }

  ///列表数据
  orderListData() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _orderListList.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            onTap: () {
              MyRoute.router.navigateTo(context,
                  Routes.orderDetail + "?id=${_orderListList[index].id}",transition: TransitionType.fadeIn);
            },
            child: Container(
              width: 690.w,
              margin: EdgeInsets.only(left: 30.w, bottom: 48.w, right: 30.w),
              padding: EdgeInsets.only(
                  left: 30.w, right: 28.w, top: 36.w, bottom: 60.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.w),
                // color: Colors.grey,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffEFFFFF),
                    blurRadius: 20.w,
                    spreadRadius: 0,
                    offset: Offset(0, 6.w),
                  ),
                ],
              ),
              child: Column(
                children: [
                  //车型名称
                  Row(
                    children: [
                      Container(
                        width: 98.w,
                        height: 98.w,
                        margin: EdgeInsets.only(right: 30.w),
                        child:
                            Image.network("${_orderListList[index].brandImg}"),
                      ),
                      Container(
                        width: 504.w,
                        height: 98.w,
                        child: Text(
                          '${_orderListList[index].specName}',
                          style: TextStyle(
                            fontSize: 34.sp,
                            color: Color(0xff242A37),
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  //状态-价格
                  SizedBox(
                    height: 58.w,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      status(_orderListList[index].status),
                      Text(
                        '${_orderListList[index].priceSum}',
                        style: TextStyle(
                          color: ColorConfig.themeColor,
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  //数量
                  SizedBox(height: 44.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '采购总数量',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff242A37),
                        ),
                      ),
                      Text(
                        '${_orderListList[index].countSum}',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffA5BFED),
                        ),
                      ),
                    ],
                  ),
                  //颜色
                  SizedBox(height: 34.w),
                  colorContainer(_orderListList[index].detail),
                  //创建时间
                  SizedBox(height: 34.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '创建时间',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff242A37),
                        ),
                      ),
                      Text(
                        '${_orderListList[index].createtime}',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff242A37),
                        ),
                      ),
                    ],
                  ),
                  //订单号
                  SizedBox(height: 36.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '订单号',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff242A37),
                        ),
                      ),
                      Text(
                        '${_orderListList[index].orderNum}',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff242A37),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  //颜色x数量组装
  Container colorContainer(List<OrderListListDetail> _orderListListDetail) {
    List _list = [];
    for (int i = 0; i < _orderListListDetail.length; i++) {
      _list.add(
          '${_orderListListDetail[i].colorName}x${_orderListListDetail[i].sum}');
    }
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        '${_list.join(',')}',
        style: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.w500,
          color: Color(0xff242A37),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget status(int state) {
    String text;
    Color color = Color(0xffA5BFED);
    switch (state) {
      case 1:
        text = "进行中";
        break;
      case 2:
        color = ColorConfig.themeColor;
        text = "已完成";
        break;
      case 3:
        color = Color(0xffDFDFDF);
        text = "已取消";
        break;
    }

    return Container(
      width: 218.w,
      height: 72.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Text(
        "$text",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 28.sp,
        ),
      ),
    );
  }
}
