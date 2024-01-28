import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/bloc/tab_purchase/tab_purchase_detail_bloc.dart';
import 'package:tob/bloc/tab_purchase/tab_purchase_list_bloc.dart';
import 'package:tob/entity/tab_purchase/car_order_detail_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';
import 'orderStatusBtn.dart';

class UserOrderDetail extends StatefulWidget {
  final int oid;

  const UserOrderDetail({Key key, @required this.oid}) : super(key: key);

  @override
  _UserOrderDetailState createState() => _UserOrderDetailState();
}

class _UserOrderDetailState extends State<UserOrderDetail> {
  CarOrderDetailEntity _carOrderDetailEntity;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getData() {
    Http.getInstance().carOrderDetail(oid: widget.oid).then((value) {
      _carOrderDetailEntity = value;
      BlocProvider.of<TabPurchaseDetailBloc>(context)
          .add(new TabPurchaseDetailEntityEvent(_carOrderDetailEntity));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<TabPurchaseDetailBloc>(context)
            .add(new TabPurchaseDetailEntityEvent(null));
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ColorConfig.bgColor,
        appBar: AppBar(
          title: Text("订单详情"),
          centerTitle: true,
          brightness: Brightness.dark,
        ),
        body: BlocBuilder<TabPurchaseDetailBloc, TabPurchaseDetailState>(
          builder: (context, state) {
            if (state is TabPurchaseDetailEntityState) {
              _carOrderDetailEntity = state.carOrderDetailEntity;
              if (_carOrderDetailEntity != null) {
                BlocProvider.of<TabPurchaseListBloc>(context).add(
                    new TabPurchaseEntityUpdByIdEvent(
                        id: _carOrderDetailEntity.id,
                        status: _carOrderDetailEntity.status));
              }
            }
            return _carOrderDetailEntity != null
                ? GestureDetector(
                    onTap: () {
                      closeBoard(context: context);
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //  订单号
                          orderNum(),

                          ///  采购车型
                          car(),
                          //  地址
                          address(),
                          //  颜色-数量-单价-小计
                          detail(),
                          //  合计
                          all(),
                          //  备注
                          if (_carOrderDetailEntity.remarks != null &&
                              _carOrderDetailEntity.remarks.length > 0)
                            remark(),
                          //按钮组
                          btn(),
                        ],
                      ),
                    ),
                  )
                : loadingData();
          },
        ),
      ),
    );
  }

  orderNum() {
    TextStyle style = TextStyle(
        color: ColorConfig.themeColor,
        fontSize: 30.w,
        height: 1,
        fontWeight: FontWeight.bold);

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
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      );
    }

    return Container(
      width: 690.w,
      margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 18.w),
      padding:
          EdgeInsets.only(top: 50.w, bottom: 50.w, left: 25.w, right: 25.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          stateText(state: _carOrderDetailEntity.status),
          SizedBox(height: 15.w),
          Text("订单号   ${_carOrderDetailEntity.pNum}", style: style),
          SizedBox(height: 15.w),
          Text("${_carOrderDetailEntity.createtime}", style: style),
        ],
      ),
    );
  }

  ///采购车型
  car() {
    return GestureDetector(
      onTap: () {
        if (_carOrderDetailEntity.car.status == 0) {
          KlAlert.showAlert(
              content: "该车源已下架",
              sureFunc: () {
                MyRoute.router.pop(context);
              });
          return false;
        }
        navTo(
            context,
            Routes.tabPurchaseTabDetail +
                "?id=${_carOrderDetailEntity.car.id}");
      },
      child: Container(
        width: 690.w,
        margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 18.w),
        padding:
            EdgeInsets.only(top: 20.w, bottom: 44.w, left: 25.w, right: 30.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 30.w),
              child: Text(
                "采购车型",
                style: TextStyle(
                    color: ColorConfig.themeColor,
                    fontSize: 30.w,
                    height: 1,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 19.w),
                  child: Image.network(
                    "${_carOrderDetailEntity.car.imgIndex}",
                    width: 120.w,
                    height: 120.w,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 400.w,
                            child: Text(
                              "${_carOrderDetailEntity.specName}",
                              style: TextStyle(
                                fontSize: 30.sp,
                                color: Color(0xff333333),
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.arrow_right,
                            size: 92.w,
                            color: ColorConfig.themeColor[100],
                          ),
                        ],
                      ),
                      Container(
                        width: 600.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "采购价：${_carOrderDetailEntity.normalPrice}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.sp,
                                  color: Color(0xff666666),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "会员价：${_carOrderDetailEntity.primePrice}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.sp,
                                  color: Color(0xff666666),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  address() {
    TextStyle style = TextStyle(
        color: Color(0xff333333),
        fontSize: 30.w,
        height: 1,
        fontWeight: FontWeight.bold);
    return Container(
      width: 690.w,
      margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 25.w),
      padding:
          EdgeInsets.only(top: 56.w, bottom: 59.w, left: 30.w, right: 30.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${_carOrderDetailEntity.receiveName}   ${_carOrderDetailEntity.receiveMobile}",
              style: style),
          SizedBox(height: 33.w),
          Text(
              "${_carOrderDetailEntity.city + ' ' + _carOrderDetailEntity.address}",
              style: style),
        ],
      ),
    );
  }

  detail() {
    Container titleContainer(String text) {
      return Container(
        alignment: Alignment.center,
        width: 172.5.w,
        child: Text(
          "$text",
          style: TextStyle(
              fontSize: 36.sp,
              color: ColorConfig.themeColor,
              height: 1,
              fontWeight: FontWeight.bold),
        ),
      );
    }

    rowContent(
        {String color = "",
        String num = "",
        String per = "",
        String price = ""}) {
      Container contentContainer(String text) {
        return Container(
          alignment: Alignment.center,
          width: 172.5.w,
          child: Text(
            "$text",
            style: TextStyle(
                fontSize: 30.sp,
                color: Color(0xff333333),
                height: 1,
                fontWeight: FontWeight.bold),
          ),
        );
      }

      return Container(
        margin: EdgeInsets.only(top: 35.w),
        child: Column(
          children: [
            Row(
              children: [
                contentContainer(color),
                contentContainer(num),
                contentContainer(per),
                contentContainer(price),
              ],
            ),
            SizedBox(height: 20.w),
            Container(
              width: 637.w,
              height: 1.w,
              color: Color(0xff999999),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 690.w,
      margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 25.w),
      padding: EdgeInsets.only(top: 26.w, bottom: 32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Column(
        children: [
          Row(
            children: [
              titleContainer("颜色"),
              titleContainer("数量"),
              titleContainer("单价"),
              titleContainer("小计"),
            ],
          ),
          for (int i = 0; i < _carOrderDetailEntity.colors.length; i++)
            rowContent(
                color: "${_carOrderDetailEntity.colors[i].colorName}",
                num: "x ${_carOrderDetailEntity.colors[i].sum}",
                per: "${_carOrderDetailEntity.colors[i].money}万",
                price:
                    "${_carOrderDetailEntity.colors[i].money * _carOrderDetailEntity.colors[i].sum}万"),
        ],
      ),
    );
  }

  all() {
    TextStyle style = TextStyle(
        color: ColorConfig.themeColor,
        fontSize: 30.w,
        height: 1,
        fontWeight: FontWeight.bold);
    return Container(
      width: 690.w,
      margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 18.w, bottom: 28.w),
      padding:
          EdgeInsets.only(top: 23.w, bottom: 23.w, left: 34.w, right: 25.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 30.w),
                    child: Image.asset(
                      'assets/pc_car.png',
                      color: ColorConfig.themeColor,
                      width: 50.w,
                      height: 50.w,
                    ),
                  ),
                  Text("数量合计", style: style),
                ],
              ),
              Text("${_carOrderDetailEntity.countSum}", style: style),
            ],
          ),
          SizedBox(height: 49.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 30.w),
                    child: Image.asset(
                      'assets/pc_sure.png',
                      color: ColorConfig.themeColor,
                      width: 50.w,
                      height: 50.w,
                    ),
                  ),
                  Text("金额合计", style: style),
                ],
              ),
              Text(
                  "${calcMoneyDetail(
                    _carOrderDetailEntity.colors,
                  )}万",
                  style: style),
            ],
          ),
        ],
      ),
    );
  }

  remark() {
    return Container(
        width: 690.w,
        margin:
            EdgeInsets.only(left: 30.w, right: 30.w, top: 18.w, bottom: 28.w),
        padding: EdgeInsets.all(30.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Text("${_carOrderDetailEntity.remarks}"));
  }

  btn() {
    return Container(
      margin: EdgeInsets.only(bottom: 30.w),
      padding: EdgeInsets.only(left: 30.w, right: 30.w),
      child: comOrderStatusBtn(
          context: context,
          status: _carOrderDetailEntity.status,
          carOrderDetailEntity: _carOrderDetailEntity,
          type: 2,
          contractStatus: _carOrderDetailEntity?.contract?.status,
          signContract: () {
            //同时也要更改列表的状态
            navTo(
              context,
              Routes.userOrderContract +
                  "?id=" +
                  _carOrderDetailEntity.id.toString(),
            ).then(
              (value) {
                if (value != null) {
                  updInfo(value);
                }
              },
            );
          },
          payFunc: () {
            navTo(
                    context,
                    Routes.tabPurchasePayInfo +
                        "?pid=${_carOrderDetailEntity.id.toString()}" +
                        "&image=${Uri.encodeComponent(_carOrderDetailEntity.payVoucherImage.toString())}" +
                        "&type=upd" +
                        "&error=${_carOrderDetailEntity.payVoucherRemark}")
                .then(
              (value) {
                if (value != null) {
                  updInfo(value);
                }
              },
            );
          },
          cancelFunc: () {
            Loading.show(status: '取消订单中');
            Http.getInstance().carOrderCancel(id: widget.oid).then((value) {
              var res = {"status": 9};
              updInfo(res);
              Loading.toast(msg: "取消成功");
            }).whenComplete(() => Loading.dismiss());
          },
          deleteFunc: () {
            Loading.show(status: '删除订单中');
            Http.getInstance().carOrderDelete(oid: widget.oid).then((value) {
              var res = {
                "status": _carOrderDetailEntity.status,
                'remove': true
              };
              updInfo(res);
              Loading.toast(msg: "删除成功", maskType: EasyLoadingMaskType.clear);
              Future.delayed(Duration(seconds: 2)).then((value) {
                MyRoute.router.pop(context);
              });
            }).whenComplete(() => Loading.dismiss());
          }),
    );
  }

  /*
   * 更新详情和列表的状态
   */
  updInfo(value) {
    _carOrderDetailEntity.status = value['status'];
    _carOrderDetailEntity.payVoucherStatus = "2";

    //更新详情
    BlocProvider.of<TabPurchaseDetailBloc>(context).add(
      new TabPurchaseDetailEntityEvent(_carOrderDetailEntity),
    );
    //更新列表
    BlocProvider.of<TabPurchaseListBloc>(context).add(
      new TabPurchaseEntityUpdByIdEvent(
          id: _carOrderDetailEntity.id,
          status: value['status'],
          remove: value['remove'] ?? false),
    );
  }
}
