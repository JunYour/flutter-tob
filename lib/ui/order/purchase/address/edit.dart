import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/config.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/util/common_util.dart';
import 'package:tob/widget/city.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/image_upload.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';

class AddressEditPage extends StatefulWidget {
  final int id;

  AddressEditPage({this.id});

  @override
  _AddressEditPageState createState() => _AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {
  TextEditingController _userController = TextEditingController(); //收车人
  TextEditingController _idCardController = TextEditingController(); //身份证
  TextEditingController _phoneController = TextEditingController(); //手机号
  TextEditingController _addressController = TextEditingController(); //详细地址
  String _img;
  String _area;
  String _areaCode;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    if (widget.id != null && widget.id > 0) {
      Http.getInstance().singleAddress(rid: widget.id).then((value) {
        setState(() {
          _img = value.idcardImage;
          _area = value.city;
          _userController.text = value.name;
          _idCardController.text = value.idcardNum;
          _phoneController.text = value.mobile;
          _addressController.text = value.address;
        });
      });
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _idCardController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
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
          title: Text("编辑物流地址"),
          brightness: Brightness.dark,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                //信息
                info(),
                //提交
                buildEleButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //提交
  Widget buildEleButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h, bottom: 50.h),
      child: eleButton(
          func: () {
            FocusScope.of(context).requestFocus(FocusNode());
            //验证是否上传了身份证
            // if (_img == null) {
            //   KlAlert.showAlert(
            //       content: '请上传身份证',
            //       sureFunc: () {
            //         MyRoute.router.pop(context);
            //       });
            //   return false;
            // }
            //验证收车人
            if (_userController.text.isEmpty) {
              KlAlert.showAlert(
                  content: '请填写收车人',
                  sureFunc: () {
                    MyRoute.router.pop(context);
                  });
              return false;
            }
            //验证身份证号
            if (_idCardController.text.isEmpty) {
              KlAlert.showAlert(
                  content: '请填写身份证号',
                  sureFunc: () {
                    MyRoute.router.pop(context);
                  });
              return false;
            } else if (CommonUtil.isIdCard(_idCardController.text) == false) {
              KlAlert.showAlert(
                  content: '请填写正确的身份证号',
                  sureFunc: () {
                    MyRoute.router.pop(context);
                  });
              return false;
            }
            //验证手机号
            if (_phoneController.text.isEmpty) {
              KlAlert.showAlert(
                  content: '请填写手机号',
                  sureFunc: () {
                    MyRoute.router.pop(context);
                  });
              return false;
            } else if (CommonUtil.isChinaPhoneLegal(_phoneController.text) ==
                false) {
              KlAlert.showAlert(
                  content: '请填写正确的手机号',
                  sureFunc: () {
                    MyRoute.router.pop(context);
                  });
              return false;
            }
            //验证地址
            if (_area == null) {
              KlAlert.showAlert(
                  content: '请填写选择地址',
                  sureFunc: () {
                    MyRoute.router.pop(context);
                  });
              return false;
            }
            if (_addressController.text == null ||
                _addressController.text
                        .replaceAll(new RegExp(r"\s+\b|\b\s"), "")
                        .length <=
                    0) {
              KlAlert.showAlert(
                  content: '请填写详细地址',
                  sureFunc: () {
                    MyRoute.router.pop(context);
                  });
              return false;
            }

            KlAlert.showAlert(
                content: '确认已填写完资料并提交？',
                sureFunc: () {
                  if (widget.id != null && widget.id > 0) {
                    Loading.show();
                    Http.getInstance()
                        .modifyAddress(
                      rid: widget.id,
                      idNum: _idCardController.text,
                      name: _userController.text,
                      mobile: _phoneController.text,
                      city: _area,
                      address: _addressController.text,
                      // imageUrl:
                      //     CommonUtil.imgDeal(imgStr: _img, type: Config.idCard),
                    )
                        .then((value) {
                      showToast('提交成功');
                      MyRoute.router.pop(context);
                      MyRoute.router.pop(context, true);
                    }).whenComplete(() => Loading.dismiss());
                  } else {
                    Loading.show();
                    Http.getInstance()
                        .addAddress(
                      idNum: _idCardController.text,
                      name: _userController.text,
                      mobile: _phoneController.text,
                      city: _area,
                      address: _addressController.text,
                      // imageUrl:
                      //     CommonUtil.imgDeal(imgStr: _img, type: Config.idCard),
                    )
                        .then((value) {
                      showToast('提交成功');
                      MyRoute.router.pop(context);
                      MyRoute.router.pop(context, true);
                    }).whenComplete(() => Loading.dismiss());
                  }
                },
                cancelFunc: () {
                  MyRoute.router.pop(context);
                });
          },
          color: ColorConfig.themeColor,
          circular: 48.w,
          width: 484.w,
          height: 96.w,
          con: '确认'),
    );
  }

  info() {
    return Container(
      width: 688.w,
      margin: EdgeInsets.only(top: 30.h),
      padding: EdgeInsets.all(30.w),
      decoration: comBoxDecoration(),
      child: Column(
        children: [
          //身份证照片
          // Container(
          //   width: 502.w,
          //   height: 308.w,
          //   margin: EdgeInsets.only(top: 10.w, bottom: 20.w),
          //   decoration: BoxDecoration(
          //     color: Color(0xffD2E5F9),
          //     borderRadius: BorderRadius.circular(20.w),
          //   ),
          //   child: InkWell(
          //       onTap: () {
          //         FocusScope.of(context).requestFocus(FocusNode());
          //         ImgUpload.upload(func: (value) {
          //           Loading.show();
          //           Http.getInstance()
          //               .imgUpload(value, Config.idCard)
          //               .then((value) {
          //             String img = value.fileUrl;
          //             Loading.show(status: '正在识别中...');
          //             Http.getInstance()
          //                 .ocr(
          //                     image: img, imgType: Config.idCard, type: 'front')
          //                 .then((idCardRes) {
          //               setState(() {
          //                 _img = img;
          //                 _userController.text = idCardRes.data['name'];
          //                 _idCardController.text = idCardRes.data['num'];
          //               });
          //             }).whenComplete(() {
          //               Loading.dismiss();
          //             });
          //           }).whenComplete(() {
          //             Loading.dismiss();
          //           });
          //         });
          //       },
          //       child: _img == null
          //           ? Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Icon(
          //                   Icons.add,
          //                   color: Colors.white,
          //                   size: 120.w,
          //                 ),
          //                 Text(
          //                   '上传身份证正面照片',
          //                   style: TextStyle(
          //                     fontSize: 28.sp,
          //                     fontWeight: FontWeight.w400,
          //                     color: Colors.white,
          //                   ),
          //                 ),
          //               ],
          //             )
          //           : stackImg(_img, '更新身份证正面照片', true,
          //               fit: BoxFit.fill,
          //               width: 502.w,
          //               height: 308.w,
          //               size: 28.sp)),
          // ),

          conContainer(
            '收车人',
            TextField(
              textAlign: TextAlign.right,
              scrollPadding: EdgeInsets.zero,
              controller: _userController,
              decoration: InputDecoration(
                hintText: '请填写',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 15.w),
                labelStyle: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConfig.fontColorBlack,
                ),
              ),
            ),
          ),

          conContainer(
            '身份证号',
            TextField(
              controller: _idCardController,
              maxLength: 18,
              textAlign: TextAlign.right,
              scrollPadding: EdgeInsets.zero,
              decoration: InputDecoration(
                hintText: '请填写',
                counterText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 15.w),
                labelStyle: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConfig.fontColorBlack,
                ),
              ),
            ),
          ),

          conContainer(
            '手机号码',
            TextField(
              controller: _phoneController,
              textAlign: TextAlign.right,
              scrollPadding: EdgeInsets.zero,
              maxLength: 11,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                counterText: '',
                hintText: '请填写',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 15.w),
                labelStyle: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConfig.fontColorBlack,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              cityChose(
                  context: context,
                  func: (area) {
                    setState(() {
                      _area = area;
                    });
                  });
            },
            child: Container(
              width: double.infinity,
              height: 110.w,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2.w,
                    color: ColorConfig.themeColor[100],
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 90.w,
                    width: 100.w,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text('地址'),
                      ],
                    ),
                  ),
                  Container(
                    width: 430.w,
                    height: 90.w,
                    alignment: Alignment.centerRight,
                    child: Text(
                      _area == null ? '请选择' : '$_area',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24.sp,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.location_on_outlined,
                    color: ColorConfig.themeColor,
                    size: 50.w,
                  ),
                ],
              ),
            ),
          ),

          conContainer(
            '详细地址',
            TextField(
              controller: _addressController,
              textAlign: TextAlign.right,
              scrollPadding: EdgeInsets.zero,
              decoration: InputDecoration(
                hintText: '请填写详细地址及门牌号',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 15.w),
                labelStyle: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConfig.fontColorBlack,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container conContainer(String title, Widget wid) {
    return Container(
      width: double.infinity,
      height: 110.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2.w,
            color: ColorConfig.themeColor[100],
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 90.w,
            width: 150.w,
            alignment: Alignment.centerLeft,
            child: Text('$title'),
          ),
          Container(width: 430.w, height: 90.w, child: wid),
        ],
      ),
    );
  }
}
