import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tob/entity/bank_entity.dart';
import 'package:tob/entity/order/order_detail_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/order.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/widget/image_show.dart';

class OrderDetailPage extends StatefulWidget {
  final int id;

  OrderDetailPage({@required this.id});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderDetailEntity _orderDetailEntity;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    Http.getInstance().orderDetail(id: widget.id).then((value) {
      setState(() {
        _orderDetailEntity = value;
        BankEntity bankEntity = new BankEntity();
        bankEntity.bankName = value.bankName;
        bankEntity.bankNum = value.bankNum;
        bankEntity.receiveName = value.receiveName;
        Order.setBank(bankEntity);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbarTitle(title: '项目详情'),
      body: _orderDetailEntity == null
          ? loadingData()
          : SingleChildScrollView(
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
      bottomNavigationBar: SafeArea(
        bottom: true,
        top: false,
        minimum: const EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                MyRoute.router.navigateTo(
                    context,
                    Routes.purchaseList +
                        "?oid=${widget.id}&countSum=${_orderDetailEntity.countSum}&count=${_orderDetailEntity.count}&status=${_orderDetailEntity.status}");
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(436.w, 72.w)),
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
                "采购管理",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 28.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  info() {
    return Transform.translate(
      offset: Offset(0, -48.w),
      child: Column(
        children: [
          Container(
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
                Container(
                  width: 490.w,
                  margin: EdgeInsets.only(right: 34.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state(_orderDetailEntity.status),
                        style: TextStyle(
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff242A37),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          List _list = [];
                          for (int i = 0;
                              i < _orderDetailEntity.contract.length;
                              i++) {
                            _list.add(_orderDetailEntity.contract[i].url);
                          }
                          if (_list.length > 0) {
                            Navigator.push(
                              context,
                              GradualChangeRoute(PhotoPreview(
                                galleryItems: _list,
                                defaultImage: 0,
                                title:_orderDetailEntity.contractNo.toString()
                              )),
                            );
                          }
                        },
                        child: Container(
                          width: 218.w,
                          height: 72.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _orderDetailEntity.contract.length > 0
                                ? ColorConfig.themeColor
                                : ColorConfig.themeColor[100],
                            borderRadius: BorderRadius.circular(20.w),
                          ),
                          child: Text(
                            '查看合同',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.w),
          //订单详情内容
          Container(
            width: 690.w,
            padding: EdgeInsets.only(
                left: 30.w, bottom: 86.w, top: 40.w, right: 20.w),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16.w)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffEFEFEF),
                    offset: Offset(0, 6.w),
                    blurRadius: 20.w,
                    spreadRadius: 0,
                  )
                ]),
            child: Column(
              children: [
                //车型名称
                Row(
                  children: [
                    Container(
                      width: 98.w,
                      height: 98.w,
                      margin: EdgeInsets.only(right: 30.w),
                      child: Image.network('${_orderDetailEntity.brandImg}'),
                    ),
                    Container(
                      width: 504.w,
                      height: 98.w,
                      child: Text(
                        '${_orderDetailEntity.specName}',
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

                //指导价价格
                SizedBox(height: 46.w),
                Container(
                  width: 640.w,
                  height: 2.w,
                  color: Color(0xffF1F2F6),
                ),
                SizedBox(height: 40.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '指导价:${_orderDetailEntity.zdj}',
                      style: TextStyle(
                        fontSize: 28.sp,
                        color: Color(0xffA5BFED),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${_orderDetailEntity.min}-${_orderDetailEntity.max}',
                        style: TextStyle(
                          fontSize: 34.sp,
                          color: ColorConfig.themeColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                //数量价格
                SizedBox(height: 56.w),
                priceCount(),
                //物流
                SizedBox(height: 48.w),
                Container(
                  width: 640.w,
                  height: 136.w,
                  padding: EdgeInsets.only(right: 62.w, left: 30.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      comShadow(),
                    ],
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 78.w,
                            height: 78.w,
                            margin: EdgeInsets.only(right: 4.w),
                            child: Image.asset('assets/logistics.png',
                                width: 78.w, height: 78.w),
                          ),
                          Text(
                            '物流',
                            style: TextStyle(
                              fontSize: 32.w,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff242A37),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${_orderDetailEntity.delivery}',
                        style: TextStyle(
                          fontSize: 32.w,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff242A37),
                        ),
                      ),
                    ],
                  ),
                ),

                //备注
                SizedBox(height: 48.w),
                Container(
                  width: 640.w,
                  padding: EdgeInsets.only(
                      left: 36.w, right: 34.w, top: 48.w, bottom: 74.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      comShadow(),
                    ],
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56.w,
                            height: 56.w,
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
                          '${_orderDetailEntity.remarks}',
                          style: TextStyle(
                            fontSize: 28.w,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff242A37),
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
    );
  }

  //价格Widget
  priceCount() {
    TextStyle titleStyle = TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );

    TextStyle listStyle = TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.w500,
      color: Color(0xff436B8F),
    );

    pCRow(String title, String content) {
      return Container(
        width: double.infinity,
        height: 80.w,
        padding: EdgeInsets.only(left: 30.w, right: 30.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$title',
              style: TextStyle(
                fontSize: 28.sp,
                color: Color(0xff242A37),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '$content',
              style: TextStyle(
                fontSize: 32.sp,
                color: Color(0xff242A37),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    Container pCContainer(int type, String content, TextStyle style,
        {bool showBorder = false}) {
      BoxDecoration boxDecoration = BoxDecoration(
        border: Border(
          right: BorderSide(
            width: showBorder == true ? 1.0.w : 0,
            color: Colors.grey[300],
          ),
        ),
      );
      if (showBorder == false) {
        boxDecoration = BoxDecoration();
      }

      return Container(
        width: 128.w * type,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: boxDecoration,
        child: Text(
          '$content',
          style: style,
        ),
      );
    }

    return Container(
      width: 640.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.w),
          bottomRight: Radius.circular(24.w),
        ),
        boxShadow: [
          comShadow(),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 98.w,
            decoration: BoxDecoration(
                color: ColorConfig.themeColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.w),
                    topRight: Radius.circular(24.w))),
            child: Row(
              children: [
                pCContainer(1, '外观', titleStyle),
                pCContainer(2, '采购数量', titleStyle),
                pCContainer(1, '单价', titleStyle),
                pCContainer(1, '总计', titleStyle),
              ],
            ),
          ),
          for (int i = 0; i < _orderDetailEntity.detail.length; i++)
            Container(
              width: double.infinity,
              height: 98.w,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1.w, color: Colors.grey[300]))),
              child: Row(
                children: [
                  pCContainer(1, '${_orderDetailEntity.detail[i].colorName}',
                      listStyle),
                  pCContainer(
                      2, '${_orderDetailEntity.detail[i].sum}', listStyle),
                  pCContainer(
                      1, '${_orderDetailEntity.detail[i].perprice}', listStyle,showBorder: true),
                  pCContainer(
                      1, '${_orderDetailEntity.detail[i].money}', listStyle),
                ],
              ),
            ),
          pCRow('数量合计', '${_orderDetailEntity.countSum}'),
          pCRow('金额合计', '${_orderDetailEntity.priceSum}'),
          pCRow('订单号', '${_orderDetailEntity.orderNum}'),
        ],
      ),
    );
  }

  BoxShadow comShadow() {
    return BoxShadow(
        offset: Offset(0, 6.w),
        blurRadius: 20.w,
        spreadRadius: 0,
        color: Color.fromRGBO(0, 0, 0, 0.08));
  }

  String state(int status) {
    String text;
    switch (status) {
      case 1:
        text = "进行中";
        break;
      case 2:
        text = "已完成";
        break;
      case 3:
        text = "已取消";
        break;
    }
    return text;
  }
}
