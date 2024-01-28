import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/entity/address/address_list_entity.dart';
import 'package:tob/entity/purchase/purchase_list_entity.dart';
import 'package:tob/entity/tab_purchase/car_pre_order_entity.dart';
import 'package:tob/global/address.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';

class PurchaseLaunchPage extends StatefulWidget {
  final int oid;
  final AddressListList addressListList;
  final PurchaseListList purchaseListList;

  PurchaseLaunchPage(
      {@required this.oid, this.addressListList, this.purchaseListList});

  @override
  _PurchaseLaunchState createState() => _PurchaseLaunchState();
}

class _PurchaseLaunchState extends State<PurchaseLaunchPage> {
  AddressListList _addressListList = new AddressListList();
  TextEditingController _remarksController = new TextEditingController();

  CarPreOrderEntity _carPreOrderEntity;
  List<CarPreOrderColors> _carPreOrderColors = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds:1)).then((value) {
        if (mounted) {
          getData();
        }
      });
    });
    super.initState();
  }

  //获取预采购数据
  getData() {
    Http.getInstance().carPreOrder(id: widget.oid).then((value) {
      if (mounted) {
        setState(() {
          _carPreOrderColors = value.colors;
          //获取之前选中的地址
          AddressListList addressListList = Address.getAddress();
          if (addressListList != null) {
            _addressListList = addressListList;
          } else {
            _addressListList = null;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    Loading.dismiss();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeBoard(context: context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("发起采购"),
          centerTitle: true,
          brightness: Brightness.dark,
        ),
        body: _carPreOrderColors.length > 0
            ? SingleChildScrollView(
                child: Center(
                  child: info(),
                ),
              )
            : loadingData(),
        bottomNavigationBar: SafeArea(
          bottom: true,
          top: false,
          minimum: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              eleButton(
                width: 484.w,
                height: 96.w,
                color: ColorConfig.themeColor,
                circular: 48.w,
                con: _carPreOrderEntity == null ? '提交采购' : '确认修改',
                func: () {
                  closeBoard(context: context);
                  if (_addressListList == null) {
                    KlAlert.showAlert(
                        content: '请选择地址',
                        sureFunc: () {
                          MyRoute.router.pop(context);
                        });
                    return false;
                  }
                  int count = 0;

                  for (int i = 0; i < _carPreOrderColors.length; i++) {
                    int num = _carPreOrderColors[i].num == null
                        ? 0
                        : _carPreOrderColors[i].num;
                    count = count + num;
                  }
                  if (count <= 0) {
                    KlAlert.showAlert(
                        content: '请选择采购的规格与数量',
                        sureFunc: () {
                          MyRoute.router.pop(context);
                        });
                    return false;
                  }

                  KlAlert.showAlert(
                    content: '确认发起采购？',
                    sureFunc: () {
                      Loading.show();
                      Http.getInstance()
                          .carOrder(
                              id: widget.oid,
                              colors: jsonEncode(_carPreOrderColors),
                              addressId: _addressListList.id,
                              remark: _remarksController.text)
                          .then((value) {
                        navTo(context, Routes.tabPurchaseSuccess);
                      }).whenComplete(() => Loading.dismiss());
                    },
                    cancelFunc: () {
                      MyRoute.router.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //内容
  info() {
    return Column(
      children: [
        SizedBox(height: 30.w),
        //物流
        logistics(),
        //采购信息
        SizedBox(height: 48.w),
        purchaseInfo(),
        //数量
        SizedBox(height: 48.w),
        countRowContainer(),
        //备注
        SizedBox(height: 48.w),
        remarkContainer(),
        //提交按钮
        SizedBox(height: 56.w),
      ],
    );
  }

//备注
  Container remarkContainer() {
    return Container(
      width: 640.w,
      padding: EdgeInsets.all(30.w),
      decoration: comBoxDecoration(),
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
            child: TextField(
              controller: _remarksController,
              keyboardType: TextInputType.multiline,
              maxLines: 4, //不限制行数
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }

  Container countRowContainer() {
    int count = 0;
    double price = 0;
    for (int i = 0; i < _carPreOrderColors.length; i++) {
      count += _carPreOrderColors[i].num;
      if (UserInfo.getUserInfo().isVip == 2) {
        price += _carPreOrderColors[i].perPprice * _carPreOrderColors[i].num;
      } else {
        price += _carPreOrderColors[i].perNprice * _carPreOrderColors[i].num;
      }
    }

    return Container(
      width: 690.w,
      height: 230.w,
      padding: EdgeInsets.only(left: 38.w, right: 80.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(color: Color(0xFFEFEFF4), width: 2.w),
      ),
      child: Column(
        children: [
          countRow(
              'assets/pc_car.png', 52.w, 48.w, '数量合计', '${count.toString()}台'),
          countRow('assets/pc_sure.png', 52.w, 48.w, '金额合计',
              '${price.toStringAsFixed(2)}万'),
        ],
      ),
    );
  }

  //数量
  countRow(
      String assets, double width, double height, String title, String num) {
    TextStyle style = TextStyle(
      color: ColorConfig.themeColor,
      fontWeight: FontWeight.w500,
      fontSize: 34.sp,
    );
    return Container(
      height: 110.w,
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

  //物流
  Container logistics() {
    TextStyle style = TextStyle(
      fontSize: 28.sp,
      fontWeight: FontWeight.w500,
      color: ColorConfig.fontColorBlack,
    );
    return Container(
      width: 690.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(color: Color(0xFFEFEFF4), width: 2.w),
      ),
      child: _addressListList == null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(30.w),
                  width: 98.w,
                  height: 98.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(49.w),
                    color: ColorConfig.themeColor,
                  ),
                  alignment: Alignment.center,
                  child: Image.asset('assets/wallet.png',
                      width: 64.w, height: 64.w),
                ),
                InkWell(
                  onTap: () {
                    MyRoute.router
                        .navigateTo(context, Routes.addressList,
                            transition: TransitionType.inFromRight)
                        .then((value) {
                      if (value != null) {
                        setState(() {
                          _addressListList = value;
                        });
                      } else {
                        Http.getInstance()
                            .addressList(page: 1, limit: 10)
                            .then((value) {
                          if (value.count == 0) {
                            _addressListList = null;
                          } else {
                            List<AddressListList> _thisAddressListList =
                                value.xList;
                            int addressId;
                            _thisAddressListList.map((e) {
                              if (e.id == _addressListList.id) {
                                addressId = e.id;
                              }
                              if (addressId == null) {
                                _addressListList = null;
                              }
                            });
                          }
                        });
                      }
                    });
                  },
                  child: Container(
                    width: 490.w,
                    margin: EdgeInsets.only(right: 34.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '请填写物流地址',
                          style: TextStyle(
                            color: Color(0xff242A37),
                            fontSize: 34.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.arrow_right,
                          size: 98.w,
                          color: Color(0xffA5BFED),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: () {
                MyRoute.router
                    .navigateTo(context, Routes.addressList,
                        transition: TransitionType.inFromRight)
                    .then(
                  (value) {
                    if (value != null) {
                      setState(() {
                        _addressListList = value;
                      });
                    } else {
                      Http.getInstance().addressList(page: 1, limit: 10).then(
                        (value) {
                          if (value.count == 0) {
                            _addressListList = null;
                          } else {
                            List<AddressListList> _thisAddressListList =
                                value.xList;
                            int addressId;
                            _thisAddressListList.map((e) {
                              if (e.id == _addressListList.id) {
                                addressId = e.id;
                              }
                              if (addressId == null) {
                                _addressListList = null;
                              }
                            });
                          }
                        },
                      );
                    }
                  },
                );
              },
              child: Container(
                width: 690.w,
                padding: EdgeInsets.all(30.w),
                decoration: comBoxDecoration(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 300.w,
                          child: Text(
                            '${_addressListList?.name}',
                            style: style,
                          ),
                        ),
                        Container(
                          width: 200.w,
                          child: Text(
                            '${_addressListList?.mobile}',
                            style: style,
                          ),
                        ),
                        Container(
                          width: 120.w,
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
                      child: _addressListList.city != null
                          ? Text(
                              '${_addressListList.city.replaceAll('/', ' ') + " " + _addressListList?.address}',
                              style: style,
                            )
                          : Text(''),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  //采购信息
  purchaseInfo() {
    return Column(
      children: [
        //添加数量
        for (int i = 0; i < _carPreOrderColors.length; i++)
          countContainer(_carPreOrderColors[i], i),
      ],
    );
  }

  //数量
  Container countContainer(CarPreOrderColors data, int index) {
    data.num = data.num != null ? data.num : 0;
    Key key = Key("$index");
    TextEditingController _thisController =
        new TextEditingController(text: data.num.toString());
    _thisController.selection = TextSelection(
        baseOffset: data.num.toString().length,
        extentOffset: data.num.toString().length);

    TextStyle listStyle({Color color}) {
      return TextStyle(
        color: color == null ? ColorConfig.themeColor : color,
        fontSize: 30.sp,
        fontWeight: FontWeight.bold,
      );
    }

    return Container(
      width: 690.w,
      margin: EdgeInsets.only(bottom: 20.w),
      padding: EdgeInsets.only(left: 18.w, right: 18.w, bottom: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.w),
        color: data.num > 0 ? ColorConfig.themeColor[100] : Colors.white,
        border: Border.all(color: Color(0xFFEFEFF4), width: 2.w),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.w),
          Row(
            children: [
              Container(
                width: 150.w,
                alignment: Alignment.center,
                child: Text(
                  '${data.name}',
                  style: listStyle(),
                ),
              ),
              Container(
                width: 300.w,
                alignment: Alignment.center,
                child: Text(
                  '单价',
                  style: listStyle(),
                ),
              ),
              Container(
                width: 200.w,
                alignment: Alignment.center,
                child: Text(
                  '采购数量',
                  style: listStyle(),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.w),
          Row(
            children: [
              Container(
                width: 150.w,
                alignment: Alignment.centerLeft,
                child: Text(
                  '剩余数量',
                  style: listStyle(color: Colors.black),
                ),
              ),

              ///单价
              Container(
                width: 300.w,
                alignment: Alignment.center,
                child: Text(
                  UserInfo.getUserVip()
                      ? '${data.perPprice}万'
                      : '${data.perNprice}万',
                  style: listStyle(color: Colors.red),
                ),
              ),

              ///数量选择
              Container(
                width: 200.w,
                alignment: Alignment.center,
                child: Container(
                  height: 60.w,
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  decoration: BoxDecoration(
                    color: data.num > 0 ? Colors.white : Colors.grey[300],
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (data.num > 0) {
                              data.num = data.num - 1;
                              _carPreOrderColors[index].num = data.num;
                            }
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: double.infinity,
                          child: Icon(
                            Icons.remove_circle,
                            size: 45.w,
                            color: data.num > 0
                                ? ColorConfig.themeColor
                                : ColorConfig.themeColor[100],
                          ),
                        ),
                      ),
                      Container(
                        width: 72.w,
                        height: 60.w,
                        alignment: Alignment.center,
                        child: TextField(
                          toolbarOptions: ToolbarOptions(
                            paste: false,
                            copy: false,
                            selectAll: false,
                            cut: false,
                          ),
                          key: key,
                          controller: _thisController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textInputAction:
                              index == _carPreOrderColors.length - 1
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                          onSubmitted: (value) {
                            setState(() {});
                          },
                          onChanged: (value) {
                            if (value.length > 0) {
                              int num = int.parse(value.toString());
                              if (num > data.count) {
                                data.num = data.count;
                              } else {
                                data.num = num;
                              }
                            } else {
                              data.num = 0;
                            }
                            _carPreOrderColors[index].num = data.num;
                          },
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32.sp,
                            color: ColorConfig.themeColor,
                          ),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 33.w,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (data.num < data.count) {
                              data.num = data.num + 1;
                              _carPreOrderColors[index].num = data.num;
                            }
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: double.infinity,
                          child: Icon(
                            Icons.add_circle,
                            color: data.num >= 0 && data.num < data.count
                                ? ColorConfig.themeColor
                                : ColorConfig.themeColor[100],
                            size: 45.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 200.w,
                alignment: Alignment.centerLeft,
                child: Text(
                  '${data.count.toString()}台',
                  style: listStyle(color: Colors.black),
                ),
              ),
              if (!UserInfo.getUserVip())
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '会员价:${data.perPprice}万',
                      style: listStyle(color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '小计:',
                    style: listStyle(),
                  ),
                  Text(
                    '${(data.perNprice * data.num).toStringAsFixed(2)}万',
                    style: listStyle(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
