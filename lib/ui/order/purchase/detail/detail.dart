import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/bloc/purchase/list/purchase_list_bloc.dart';
import 'package:tob/bloc/purchase/num/purchase_num_bloc.dart';
import 'package:tob/bloc/purchase/purchase/purchase_detail_bloc.dart';
import 'package:tob/entity/purchase/purchase_detail_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/ui/order/purchase/com_purchase.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';

class PurchaseDetailPage extends StatefulWidget {
  final int pid;
  final int oid;
  PurchaseDetailPage({@required this.pid, @required this.oid});

  @override
  _PurchaseDetailPageState createState() => _PurchaseDetailPageState();
}

class _PurchaseDetailPageState extends State<PurchaseDetailPage> {
  PurchaseDetailEntity _purchaseDetailEntity;

  @override
  void initState() {
    BlocProvider.of<PurchaseDetailBloc>(context)
        .add(PurchaseDetailInitEvent(id: widget.pid,clear: true));
    BlocProvider.of<PurchaseDetailBloc>(context)
        .add(PurchaseDetailInitEvent(id: widget.pid,clear: false));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = '采购详情';
    return BlocBuilder<PurchaseDetailBloc, PurchaseDetailState>(
      builder: (context, state) {
        if (state is PurchaseDetailInitState) {
          _purchaseDetailEntity = state.purchaseDetailEntity;
        }
        if (_purchaseDetailEntity == null) {
          return Scaffold(
              appBar: commonAppbarTitle(title: title), body: loadingData());
        }
        return Scaffold(
          appBar: commonAppbarTitle(title: title),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 88.w,
                    decoration: BoxDecoration(
                      color: ColorConfig.themeColor,
                    ),
                  ),
                  info(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  info() {
    return Transform.translate(
      offset: Offset(0, -56.w),
      child: Column(
        children: [
          //状态
          status(),
          //物流
          SizedBox(height: 22.w),
          logistics(),
          //数量
          SizedBox(height: 22.w),
          purchaseInfo(),
          //总计
          countRowContainer(),
          //备注
          remarkContainer(),
          //按钮
          Container(
            width: 690.w,
            margin: EdgeInsets.only(top: 66.w, bottom: 134.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Offstage(
                  offstage: _purchaseDetailEntity.status == "1" &&
                          (_purchaseDetailEntity.payVoucherStatus == "1" ||
                              _purchaseDetailEntity.payVoucherStatus == "4")
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
                                  pid: _purchaseDetailEntity.id)
                                  .then((value) {
                                _purchaseDetailEntity.status = '7';
                                BlocProvider.of<PurchaseNumBloc>(context)
                                    .add(PurchaseNumInitEvent(oid: widget.oid));
                                BlocProvider.of<PurchaseListBloc>(context)
                                    .add(PurchaseListRefreshEvent(true));
                                MyRoute.router.pop(context);
                                BlocProvider.of<PurchaseDetailBloc>(context)
                                    .add(PurchaseDetailInitEvent(id: widget.pid,clear: false));
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
                  offstage: _purchaseDetailEntity.status == "1" &&
                          (_purchaseDetailEntity.payVoucherStatus == "1" ||
                              _purchaseDetailEntity.payVoucherStatus == "4")
                      ? false
                      : true,
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      stateButton('修改', Color(0xffA5BFED), () {
                        MyRoute.router.navigateTo(
                            context,
                            Routes.launchPurchase +
                                '?oid=${widget.oid}&purchaseListList=${Uri.encodeComponent(jsonEncode(_purchaseDetailEntity))}',
                            transition: TransitionType.fadeIn).then((value){
                          BlocProvider.of<PurchaseDetailBloc>(context)
                              .add(PurchaseDetailInitEvent(id: widget.pid,clear: false));
                        });
                      }),
                    ],
                  ),
                ),
                Offstage(
                  offstage: _purchaseDetailEntity.status == "1" &&
                          (_purchaseDetailEntity.payVoucherStatus == "1" ||
                              _purchaseDetailEntity.payVoucherStatus == "4")
                      ? false
                      : true,
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      stateButton('去支付', ColorConfig.themeColor, () {
                        if (_purchaseDetailEntity.payVoucherStatus == '4') {
                          MyRoute.router
                              .navigateTo(
                                  context,
                                  Routes.payInfoPage +
                                      "?pid=${_purchaseDetailEntity.id}&error=${Uri.encodeComponent(_purchaseDetailEntity.payVoucherRemark)}&img=${Uri.encodeComponent(_purchaseDetailEntity.payVoucherImage)}&type=upd")
                              .then((value) {
                            BlocProvider.of<PurchaseDetailBloc>(context)
                                .add(PurchaseDetailInitEvent(id: widget.pid,clear: false));
                          });
                        } else {
                          MyRoute.router
                              .navigateTo(
                                  context,
                                  Routes.payInfoPage +
                                      "?pid=${_purchaseDetailEntity.id}&type=upd")
                              .then((value) {
                            BlocProvider.of<PurchaseDetailBloc>(context)
                                .add(PurchaseDetailInitEvent(id: widget.pid,clear: false));
                          });
                        }
                      }),
                    ],
                  ),
                ),
                Offstage(
                  offstage: int.parse(_purchaseDetailEntity.status) >= 5 && int.parse(_purchaseDetailEntity.status) < 7
                      ? false
                      : true,
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      stateButton(int.parse(_purchaseDetailEntity.status)==5?'回传资料':'查看资料', ColorConfig.themeColor, () {
                        MyRoute.router.navigateTo(
                            context,
                            Routes.fileList +
                                "?pid=${_purchaseDetailEntity.id}",
                            transition: TransitionType.fadeIn).then((value) {
                          BlocProvider.of<PurchaseDetailBloc>(context)
                              .add(PurchaseDetailInitEvent(id: widget.pid,clear: false));
                        });
                      }),
                    ],
                  ),
                ),
                Offstage(
                  offstage: _purchaseDetailEntity.status == "3" ? false : true,
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      stateButton('确认收车', ColorConfig.themeColor, () {
                        MyRoute.router.navigateTo(
                            context,
                            Routes.receivedCar +
                                "?pid=${_purchaseDetailEntity.id}",transition: TransitionType.inFromRight).then((value) {
                          BlocProvider.of<PurchaseDetailBloc>(context)
                              .add(PurchaseDetailInitEvent(id: widget.pid,clear: false));
                        });
                      }),
                    ],
                  ),
                ),
                Offstage(
                  offstage:
                  int.parse(_purchaseDetailEntity.status) >= 4 &&
                      int.parse(_purchaseDetailEntity.status) < 7
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
                                  "?pid=${_purchaseDetailEntity.id}",transition: TransitionType.inFromRight);
                        },
                      ),
                    ],
                  ),
                ),
                Offstage(
                  offstage: (_purchaseDetailEntity.payVoucherStatus == "2" ||
                          _purchaseDetailEntity.payVoucherStatus == "3") && int.parse(_purchaseDetailEntity.status) < 7
                      ? false
                      : true,
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      stateButton('付款凭证', ColorConfig.themeColor, () {
                        MyRoute.router.navigateTo(
                            context,
                            Routes.payInfoPage +
                                "?pid=${_purchaseDetailEntity.id}&type=sel&img=${Uri.encodeComponent(_purchaseDetailEntity.payVoucherImage)}",
                            transition: TransitionType.inFromRight).then((value) {
                          BlocProvider.of<PurchaseDetailBloc>(context)
                              .add(PurchaseDetailInitEvent(id: widget.pid,clear: false));
                        });
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //备注
  Container remarkContainer() {
    return Container(
      width: 690.w,
      margin: EdgeInsets.only(top: 44.w),
      padding: EdgeInsets.all(30.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 6.w),
            blurRadius: 20.w,
            spreadRadius: 0,
            color: Color.fromRGBO(0, 0, 0, 0.08),
          ),
        ],
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10.w),
                child: Icon(
                  Icons.insert_drive_file_outlined,
                  color: ColorConfig.themeColor,
                  size: 56.w,
                ),
              ),
              Text(
                '备注',
                style: TextStyle(
                  fontSize: 32.w,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff242A37),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 18.w),
            width: double.infinity,
            child: Text(
              '${_purchaseDetailEntity.remarks}',
              style: TextStyle(
                fontSize: 28.w,
                fontWeight: FontWeight.w500,
                color: Color(0xff242A37),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //状态
  status() {
    double titleSize = 28.sp;
    double conSize = 28.sp;
    TextStyle style(double size) => new TextStyle(
          fontSize: size,
          color: Color(0xff242A37),
          fontWeight: FontWeight.w500,
        );
    return Container(
      width: 690.w,
      height: 196.w,
      padding: EdgeInsets.all(30.w),
      decoration: comBoxDecoration(),
      child: Row(
        children: [
          Container(
            width: 98.w,
            height: 98.w,
            margin: EdgeInsets.only(right: 32.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(49.w),
              color: ColorConfig.themeColor,
            ),
            alignment: Alignment.center,
            child: Text(
              '${purchaseState[int.parse(_purchaseDetailEntity.status)]['title']}',
              style: TextStyle(
                fontSize: purchaseState[int.parse(_purchaseDetailEntity.status)]['title'].length>=4?20.sp:28.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: 470.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(
                      width: 200.w,
                      child: Text(
                        '采购编号',
                        style: style(titleSize),
                      ),
                    ),
                    Container(
                      width: 270.w,
                      child: Text(
                        '${_purchaseDetailEntity.pNum}',
                        style: style(conSize),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 200.w,
                      child: Text(
                        '采购时间',
                        style: style(titleSize),
                      ),
                    ),
                    Container(
                      width: 270.w,
                      child: Text(
                        '${_purchaseDetailEntity.createtime}',
                        style: style(conSize),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration comBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16.w),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 6.w),
          blurRadius: 20.w,
          color: Color.fromRGBO(0, 0, 0, 0.08),
        ),
      ],
    );
  }

  //物流
  logistics() {
    TextStyle style = TextStyle(
      fontSize: 28.sp,
      fontWeight: FontWeight.w500,
      color: ColorConfig.fontColorBlack,
    );
    return Container(
      width: 690.w,
      padding: EdgeInsets.all(30.w),
      decoration: comBoxDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 360.w,
                child: Text(
                  '${_purchaseDetailEntity.receiveName}',
                  style: style,
                ),
              ),
              Container(
                width: 270.w,
                alignment: Alignment.centerRight,
                child: Text(
                  '${_purchaseDetailEntity.receiveMobile}',
                  style: style,
                ),
              ),
              // Container(
              //   width: 130.w,
              //   alignment: Alignment.centerRight,
              //   child: Icon(
              //     Icons.arrow_right,
              //     size: 98.w,
              //     color: Color(0xffA5BFED),
              //   ),
              // ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '${_purchaseDetailEntity.city.replaceAll('/', '') + ' ' + _purchaseDetailEntity.address}',
              style: style,
            ),
          ),
        ],
      ),
    );
  }

  //总数量
  Container countRowContainer() {
    return Container(
      width: 690.w,
      padding: EdgeInsets.only(left: 38.w, right: 80.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(color: Color(0xFFEFEFF4), width: 2.w),
      ),
      child: Column(
        children: [
          countRow('assets/pc_car.png', 52.w, 48.w, '数量合计',
              '${_purchaseDetailEntity.countSum}台'),
          countRow('assets/pc_sure.png', 52.w, 48.w, '金额合计',
              '${_purchaseDetailEntity.priceSum}万'),
        ],
      ),
    );
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
      fontSize: 34.sp,
    );
    return Container(
      height: 80.w,
      alignment: Alignment.center,
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
              SizedBox(width: 32.w),
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

  //采购信息
  purchaseInfo() {
    TextStyle titleStyle = TextStyle(
      color: Color(0xff242A37),
      fontSize: 32.sp,
      fontWeight: FontWeight.w500,
    );
    return Column(
      children: [
        //标题
        Container(
          width: 640.w,
          height: 98.w,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 6.w),
                blurRadius: 20.w,
                spreadRadius: 0,
                color: Color.fromRGBO(0, 0, 0, 0.08),
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.w),
              topRight: Radius.circular(16.w),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 160.w,
                height: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  '外观',
                  style: titleStyle,
                ),
              ),
              Container(
                width: 160.w,
                height: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  '采购数量',
                  style: titleStyle,
                ),
              ),
              Container(
                width: 160.w,
                height: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  '单价',
                  style: titleStyle,
                ),
              ),
              Container(
                width: 160.w,
                height: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  '小计',
                  style: titleStyle,
                ),
              ),
            ],
          ),
        ),

        //添加数量
        for (int i = 0; i < _purchaseDetailEntity.specs.length; i++)
          countContainer(_purchaseDetailEntity.specs[i], i),
      ],
    );
  }

  //数量
  Container countContainer(PurchaseDetailSpecs purchaseDetailSpecs, index) {
    TextStyle listStyle = TextStyle(
      color: Colors.white,
      fontSize: 32.sp,
      fontWeight: FontWeight.w500,
    );
    return Container(
      width: 690.w,
      margin: EdgeInsets.only(bottom: 20.w),
      padding: EdgeInsets.only(left: 40.w, right: 40.w, bottom: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.w),
        color: ColorConfig.themeColor,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 122.w,
                height: 100.w,
                alignment: Alignment.centerLeft,
                child: Text(
                  '${purchaseDetailSpecs.colorName}',
                  style: listStyle,
                ),
              ),
              Container(
                width: 182.w,
                height: 100.w,
                alignment: Alignment.center,
                child: Container(
                  height: 60.w,
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(
                      //   Icons.remove_circle,
                      //   size: 45.w,
                      //   color: ColorConfig.themeColor,
                      // ),
                      Container(
                        // width: 72.w,
                        // height: 60.w,
                        alignment: Alignment.center,
                        child: Text(
                          '${purchaseDetailSpecs.count}',
                          style: TextStyle(
                            fontSize: 32.sp,
                            color: ColorConfig.themeColor,
                          ),
                        ),
                        // TextField(
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //     fontSize: 32.sp,
                        //     color: ColorConfig.themeColor,
                        //   ),
                        //   decoration: InputDecoration(
                        //       border: InputBorder.none,
                        //       contentPadding: EdgeInsets.only(
                        //           left: 0, right: 0, top: 0, bottom: 28.w)),
                        // ),
                      ),
                      // Icon(
                      //   Icons.add_circle,
                      //   color: ColorConfig.themeColor,
                      //   size: 45.w,
                      // ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 152.w,
                height: 100.w,
                alignment: Alignment.center,
                child: Text(
                  '${purchaseDetailSpecs.perprice}万',
                  style: listStyle,
                ),
              ),
              Container(
                width: 152.w,
                height: 100.w,
                alignment: Alignment.centerRight,
                child: Text(
                  '${purchaseDetailSpecs.price}万',
                  style: listStyle,
                ),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       '剩余数量',
          //       style: listStyle,
          //     ),
          //     Text(
          //       '${purchaseDetailSpecs.}台',
          //       style: listStyle,
          //     ),
          //   ],
          // ),
        ],
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
        minimumSize: MaterialStateProperty.all(Size(164.w, 72.w)),
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(36.w),
            ),
          ),
        ),
      ),
      child: Text(
        con,
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 28.sp, color: Colors.white),
      ),
    );
  }
}
