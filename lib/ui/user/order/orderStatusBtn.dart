import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/entity/tab_purchase/car_order_detail_entity.dart';
import 'package:tob/entity/tab_purchase/car_order_list_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/image_show.dart';
import 'package:tob/widget/kl_alert.dart';

comOrderStatusBtn({
  @required BuildContext context,
  @required int status, //订单状态
  @required int type, //1=列表2=详情
  int contractStatus, //合同状态
  CarOrderListList carOrderListList, //列表数据,type=1时必传
  CarOrderDetailEntity carOrderDetailEntity, //详情数据,type=2时必传
  Function signContract, //签合同
  Function payFunc, //去支付
  Function cancelFunc, //取消
  Function deleteFunc, //删除
}) {
  // 1、审核中
  //
  // 2、待签合同
  //
  // 3、待付款
  //
  // 4、待发车
  //
  // 5、已发车
  //
  // 6、已收车
  //
  // 7、回传资料
  //
  // 8、已完成
  //
  // 9、已取消

  containerRight({Widget widget}) {
    return Container(
      height: 50.w,
      // margin: EdgeInsets.only(left: 20.w),
      padding: EdgeInsets.zero,
      child: widget,
    );
  }

  double _width = 50.w;
  double _height = 50.w;

  return Container(
    margin: EdgeInsets.only(top: 20.w),
    alignment: Alignment.centerRight,
    child: Wrap(
      runSpacing: 15.w,
      spacing: 10.w,
      alignment: WrapAlignment.end,
      children: [
        if (status == 2)
          containerRight(
            widget: eleButton(
                width: _width,
                height: 50.w,
                size: 25.sp,
                con: "签合同",
                circular: 5.w,
                color: ColorConfig.themeColor,
                func: () {
                  if (signContract != null) {
                    signContract();
                  }
                }),
          ),
        if ((status >= 3 && status < 9) ||
            contractStatus == 1 ||
            contractStatus == 0)
          containerRight(
            widget: eleButton(
              width: _width,
              height: 50.w,
              size: 25.sp,
              con: "查看合同",
              circular: 5.w,
              color: ColorConfig.themeColor,
              func: () {
                if (type == 1) {
                  navTo(
                    context,
                    Routes.userOrderContract +
                        "?id=" +
                        carOrderListList.id.toString() +
                        "&type=sel",
                  );

                  // List list = [];
                  // var tempList =
                  //     carOrderListList?.contract?.contract?.split(',');
                  // if (tempList != null && tempList.length > 0) {
                  //   list = tempList;
                  // }
                  // Navigator.push(
                  //   context,
                  //   GradualChangeRoute(
                  //     PhotoPreview(
                  //       galleryItems: list,
                  //       defaultImage: 0,
                  //       title:
                  //           carOrderListList.pNum,
                  //     ),
                  //   ),
                  // );
                } else {
                  navTo(
                    context,
                    Routes.userOrderContract +
                        "?id=" +
                        carOrderDetailEntity.id.toString() +
                        "&type=sel",
                  );

                  // List list = [];
                  // var tempList =
                  //     carOrderDetailEntity?.contract?.contract?.split(',');
                  // if (tempList != null && tempList.length > 0) {
                  //   list = tempList;
                  // }
                  //
                  // Navigator.push(
                  //   context,
                  //   GradualChangeRoute(
                  //     PhotoPreview(
                  //       galleryItems: list,
                  //       defaultImage: 0,
                  //       title: carOrderDetailEntity?.pNum.toString(),
                  //     ),
                  //   ),
                  // );
                }
              },
            ),
          ),
        if (status == 3)
          containerRight(
            widget: eleButton(
                width: _width,
                height: 50.w,
                size: 25.sp,
                con: "去支付",
                circular: 5.w,
                color: ColorConfig.themeColor,
                func: () {
                  if (payFunc != null) {
                    payFunc();
                  }
                }),
          ),
        if ((status > 3 && status < 9) ||
            (status < 3 &&
                (carOrderListList?.payVoucherStatus == "2" ||
                    carOrderDetailEntity?.payVoucherStatus == "2")))
          containerRight(
            widget: eleButton(
              width: _width,
              height: 50.w,
              size: 25.sp,
              con: "支付凭证",
              circular: 5.w,
              color: ColorConfig.themeColor,
              func: () {
                if (type == 1) {
                  navTo(
                      context,
                      Routes.tabPurchasePayInfo +
                          "?pid=${carOrderListList.id.toString()}" +
                          "&image=${Uri.encodeComponent(carOrderListList.payVoucherImage.toString())}" +
                          "&type=sel" +
                          "&error=${carOrderListList.payVoucherRemark}");
                } else {
                  navTo(
                      context,
                      Routes.tabPurchasePayInfo +
                          "?pid=${carOrderDetailEntity.id.toString()}" +
                          "&image=${Uri.encodeComponent(carOrderDetailEntity.payVoucherImage.toString())}" +
                          "&type=sel" +
                          "&error=${carOrderDetailEntity.payVoucherRemark}");
                }
              },
            ),
          ),
        if (status == 5)
          containerRight(
            widget: eleButton(
              width: _width,
              height: _height,
              size: 25.sp,
              con: "去收车",
              circular: 5.w,
              color: ColorConfig.themeColor,
              func: () {
                if (type == 1) {
                  navTo(
                      context,
                      Routes.tabPurchaseReceivedCar +
                          "?pid=${carOrderListList.id.toString()}");
                } else {
                  navTo(
                      context,
                      Routes.tabPurchaseReceivedCar +
                          "?pid=${carOrderDetailEntity.id.toString()}");
                }
              },
            ),
          ),
        if (status >= 6 && status < 9)
          containerRight(
            widget: eleButton(
              width: _width,
              height: 50.w,
              size: 25.sp,
              con: "收车单",
              circular: 5.w,
              color: ColorConfig.themeColor,
              func: () {
                if (type == 1) {
                  navTo(
                      context,
                      Routes.tabPurchaseReceivedCar +
                          "?pid=${carOrderListList.id.toString()}");
                } else {
                  navTo(
                      context,
                      Routes.tabPurchaseReceivedCar +
                          "?pid=${carOrderDetailEntity.id.toString()}");
                }
              },
            ),
          ),
        if (status == 7)
          containerRight(
            widget: eleButton(
              width: _width,
              height: 50.w,
              size: 25.sp,
              con: "回传资料",
              circular: 5.w,
              color: ColorConfig.themeColor,
              func: () {
                if (type == 1) {
                  navTo(
                      context,
                      Routes.tabPurchaseCarFileList +
                          "?pid=${carOrderListList.id}");
                } else {
                  navTo(
                      context,
                      Routes.tabPurchaseCarFileList +
                          "?pid=${carOrderDetailEntity.id}");
                }
              },
            ),
          ),
        if (status == 8)
          containerRight(
            widget: eleButton(
                width: _width,
                height: 50.w,
                size: 25.sp,
                con: "资料查看",
                circular: 5.w,
                color: ColorConfig.themeColor,
                func: () {
                  if (type == 1) {
                    navTo(
                        context,
                        Routes.tabPurchaseCarFileList +
                            "?pid=${carOrderListList.id}");
                  } else {
                    navTo(
                        context,
                        Routes.tabPurchaseCarFileList +
                            "?pid=${carOrderDetailEntity.id}");
                  }
                }),
          ),
        if (status < 4)
          containerRight(
            widget: eleButton(
              width: _width,
              height: 50.w,
              size: 25.sp,
              con: "取消",
              circular: 5.w,
              color: Colors.grey,
              func: () {
                if (cancelFunc != null) {
                  KlAlert.showAlert(
                      content: "确定取消订单?",
                      sureFunc: () {
                        cancelFunc();
                        MyRoute.router.pop(context);
                      },
                      cancelFunc: () {
                        MyRoute.router.pop(context);
                      });
                }
              },
            ),
          ),
        if (status == 9 || status == 8)
          containerRight(
            widget: eleButton(
              width: _width,
              height: 50.w,
              size: 25.sp,
              con: "删除",
              circular: 5.w,
              color: Colors.grey,
              func: () {
                KlAlert.showAlert(
                  content: "确认删除该订单?",
                  sureFunc: () {
                    deleteFunc();
                    MyRoute.router.pop(context);
                  },
                  cancelFunc: () {
                    MyRoute.router.pop(context);
                  },
                );
              },
            ),
          ),
      ],
    ),
  );
}

///计算金额
String calcMoney(List<CarOrderListListColors> list) {
  double money=0;
  list.asMap().forEach((key, value) {
    money = money + value.money*value.sum;
  });
  return money.toString();
}

///计算金额
String calcMoneyDetail(List<CarOrderDetailColors> list) {
  double money=0;
  list.asMap().forEach((key, value) {
    money = money + value.money*value.sum;
  });
  return money.toString();
}
