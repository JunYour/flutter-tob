import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tob/bloc/purchase/list/purchase_list_bloc.dart';
import 'package:tob/bloc/purchase/num/purchase_num_bloc.dart';
import 'package:tob/entity/address/address_list_entity.dart';
import 'package:tob/entity/purchase/purchase_list_entity.dart';
import 'package:tob/entity/purchase/purchase_pre_entity.dart';
import 'package:tob/global/address.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';

class LaunchPurchasePage extends StatefulWidget {
  final int oid;
  final AddressListList addressListList;
  final PurchaseListList purchaseListList;

  LaunchPurchasePage(
      {@required this.oid, this.addressListList, this.purchaseListList});

  @override
  _LaunchPurchasePageState createState() => _LaunchPurchasePageState();
}

class _LaunchPurchasePageState extends State<LaunchPurchasePage> {
  List<PurchasePreEntity> _purchasePreEntity = [];

  AddressListList _addressListList = new AddressListList();
  TextEditingController _remarksController = new TextEditingController();
  List<PurchaseListListSpecs> _purchaseListListSpecs = [];
  PurchaseListList _purchaseListList;

  @override
  void initState() {
    getData();
    super.initState();
  }

  //获取预采购数据
  getData() {
    Http.getInstance().purchasePre(oid: widget.oid).then((value) {
      setState(() {
        _purchasePreEntity = value;
        if (widget.purchaseListList != null) {
          _purchaseListList = widget.purchaseListList;
          _addressListList.address = _purchaseListList.address;
          _addressListList.id = _purchaseListList.addressId;
          _addressListList.city = _purchaseListList.city;
          _addressListList.name = _purchaseListList.receiveName;
          _addressListList.mobile = _purchaseListList.receiveMobile;
          _purchaseListListSpecs = _purchaseListList.specs;
          _remarksController.text = _purchaseListList.remarks;
          if (_purchaseListListSpecs.length > 0) {
            for (int i = 0; i < _purchaseListListSpecs.length; i++) {
              for (int k = 0; k < _purchasePreEntity.length; k++) {
                if (_purchaseListListSpecs[i].colorId ==
                    _purchasePreEntity[k].colorId) {
                  _purchasePreEntity[k].num =
                      int.parse(_purchaseListListSpecs[i].count);
                  _purchasePreEntity[k].sum =
                      _purchasePreEntity[k].sum + _purchasePreEntity[k].num;
                }
              }
            }
          }
        } else {
          //获取之前选中的地址
          AddressListList addressListList = Address.getAddress();
          if (addressListList != null) {
            _addressListList = addressListList;
          } else {
            _addressListList = null;
          }
        }
      });
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
    if (_purchasePreEntity.length == 0) {
      return Scaffold(
        appBar: commonAppbarTitle(title: '发起采购'),
        body: loadingData(),
      );
    }
    return GestureDetector(
      onTap: () {
        closeBoard(context: context);
      },
      child: Scaffold(
        appBar: commonAppbarTitle(title: '发起采购'),
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
                con: _purchaseListList == null ? '提交采购' : '确认修改',
                func: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_addressListList == null) {
                    KlAlert.showAlert(
                        content: '请选择地址',
                        sureFunc: () {
                          MyRoute.router.pop(context);
                        });
                    return false;
                  }
                  int count = 0;
                  double price = 0;
                  List data = [];
                  for (int i = 0; i < _purchasePreEntity.length; i++) {
                    int num = _purchasePreEntity[i].num == null
                        ? 0
                        : _purchasePreEntity[i].num;
                    count = count + num;
                    double _thisPrice = _purchasePreEntity[i].perprice * num;
                    price += _thisPrice;
                    // if (num > 0) {
                    data.add({
                      "color_id": _purchasePreEntity[i].colorId,
                      "num": num,
                      "price": _thisPrice
                    });
                    // }
                  }
                  if (count <= 0) {
                    KlAlert.showAlert(
                        content: '请选择采购的规格与数量',
                        sureFunc: () {
                          MyRoute.router.pop(context);
                        });
                    return false;
                  }
                  if (_purchaseListList != null) {
                    KlAlert.showAlert(
                        content: '确认修改采购信息？',
                        sureFunc: () {
                          Loading.show();
                          Http.getInstance()
                              .purchaseEdit(
                            pid: _purchaseListList.id,
                            count: count,
                            price: price,
                            rid: _addressListList.id,
                            data: jsonEncode(data),
                            remarks: _remarksController.text,
                          )
                              .then(
                            (value) {
                              showToast('修改成功');
                              BlocProvider.of<PurchaseListBloc>(context)
                                  .add(PurchaseListRefreshEvent(true));
                              BlocProvider.of<PurchaseNumBloc>(context)
                                  .add(PurchaseNumInitEvent(oid: widget.oid));
                              MyRoute.router.pop(context);
                              MyRoute.router.navigateTo(
                                  context,
                                  Routes.payInfoPage +
                                      "?pid=${value.id}&type=upd",
                                  replace: true);
                            },
                          ).whenComplete(
                            () {
                              Loading.dismiss();
                            },
                          );
                        },
                        cancelFunc: () {
                          MyRoute.router.pop(context);
                        });
                  } else {
                    KlAlert.showAlert(
                      content: '确认发起采购？',
                      sureFunc: () {
                        Loading.show();
                        Http.getInstance()
                            .purchaseDo(
                          oid: widget.oid,
                          count: count,
                          price: price,
                          rid: _addressListList?.id,
                          data: jsonEncode(data),
                          remarks: _remarksController.text,
                        )
                            .then(
                          (value) {
                            showToast('提交成功');
                            BlocProvider.of<PurchaseListBloc>(context)
                                .add(PurchaseListRefreshEvent(true));
                            BlocProvider.of<PurchaseNumBloc>(context)
                                .add(PurchaseNumInitEvent(oid: widget.oid));
                            MyRoute.router.pop(context);
                            MyRoute.router
                                .navigateTo(
                                    context,
                                    Routes.payInfoPage +
                                        "?pid=${value.id}&type=upd",
                                    replace: true)
                                .then((value) {});
                          },
                        ).whenComplete(() {
                          Loading.dismiss();
                        });
                      },
                      cancelFunc: () {
                        MyRoute.router.pop(context);
                      },
                    );
                  }
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
    return Transform.translate(
      offset: Offset(0, -56.w),
      child: Column(
        children: [
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
      ),
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
    for (int i = 0; i < _purchasePreEntity.length; i++) {
      int num =
          _purchasePreEntity[i].num != null ? _purchasePreEntity[i].num : 0;
      count += num;
      price += _purchasePreEntity[i].perprice * num;
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
        for (int i = 0; i < _purchasePreEntity.length; i++)
          countContainer(_purchasePreEntity[i], i),
      ],
    );
  }

  //数量
  Container countContainer(PurchasePreEntity data, int index) {
    data.num = data.num != null ? data.num : 0;
    Key key = Key("$index");
    // TextEditingController _thisController = new TextEditingController(
    //     text: data.num > 0 ? data.num.toString() : '');
    TextEditingController _thisController =
        new TextEditingController(text: data.num.toString());
    _thisController.selection = TextSelection(
        baseOffset: data.num.toString().length,
        extentOffset: data.num.toString().length);
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
        color:
            data.num > 0 ? ColorConfig.themeColor : ColorConfig.themeColor[100],
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
                  '${data.colorName}',
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
                    color: data.num > 0 ? Colors.white : Colors.grey[300],
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (data.num > 0) {
                              data.num = data.num - 1;
                              _purchasePreEntity[index].num = data.num;
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
                        height: 100.w,
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
                              index == _purchasePreEntity.length - 1
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                          onSubmitted: (value) {
                            setState(() {});
                          },
                          onChanged: (value) {
                            if (value.length > 0) {
                              int num = int.parse(value.toString());
                              if (num > data.sum) {
                                data.num = data.sum;
                              } else {
                                data.num = num;
                              }
                            } else {
                              data.num = 0;
                            }
                            _purchasePreEntity[index].num = data.num;
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
                              bottom: (100.w - 32.sp) / 2,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (data.num < data.sum) {
                              data.num = data.num + 1;
                              _purchasePreEntity[index].num = data.num;
                            }
                          });
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: double.infinity,
                          child: Icon(
                            Icons.add_circle,
                            color: data.num >= 0 && data.num < data.sum
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
              Container(
                width: 152.w,
                height: 100.w,
                alignment: Alignment.center,
                child: Text(
                  '${data.perprice}万',
                  style: listStyle,
                ),
              ),
              Container(
                width: 152.w,
                height: 100.w,
                alignment: Alignment.centerRight,
                child: Text(
                  '${(data.perprice * data.num).toStringAsFixed(2)}万',
                  style: listStyle,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '剩余数量',
                style: listStyle,
              ),
              Text(
                '${data.sum}台',
                style: listStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
