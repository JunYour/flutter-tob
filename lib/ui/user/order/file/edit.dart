import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tob/entity/tab_purchase/car_file_detail_entity.dart';
import 'package:tob/entity/tab_purchase/car_file_image_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/config.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/util/common_util.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/image_show.dart';
import 'package:tob/widget/image_upload.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';

import 'file_common.dart';

class CarFileEditPage extends StatefulWidget {
  final int vid;
  final String colorName;
  final String vin;
  final String pid;

  CarFileEditPage(
      {@required this.vid,
      @required this.colorName,
      @required this.vin,
      @required this.pid});

  @override
  _CarFileEditPageState createState() => _CarFileEditPageState();
}

class _CarFileEditPageState extends State<CarFileEditPage> {
  ///是否需要在加载状态
  bool _loading = true;
  CarFileDetailEntity _carFileDetailEntity;

  ///身份证正面
  String _idCardZImage;

  ///身份证反面
  String _idCardFImage;

  ///行驶证正面
  String _licenseZImage;

  ///行驶证反面
  String _licenseFImage;

  ///机动车出厂合格证
  String _certificateImage;

  ///机动车登记证书
  String _certImage;

  ///机动车统一销售发票
  String _invoiceImage;

  ///营业执照
  String _businessImage;

  ///姓名
  TextEditingController _nameController = TextEditingController();

  ///手机号
  TextEditingController _mobileController = TextEditingController();

  ///证件号
  TextEditingController _idCardController = TextEditingController();

  ///行驶证姓名-不做对比
  String _liName;

  ///类型.1代表个人,2代表公司
  int typeIndex = 1;

  double _imgW = 300.w;
  double _imgH = 200.w;

  bool _carProfile = false;
  bool _fileImage = false;

  List<CarFileImageEntity> _fileImageList = [];

  @override
  void dispose() {
    Loading.dismiss();
    _nameController.dispose();
    _mobileController.dispose();
    _idCardController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getData();
    getFileImage();
    super.initState();
  }

  //获取资料数据
  void getData() {
    Http.getInstance().carProfileDetail(vid: widget.vid).then(
      (value) {
        if (mounted) {
          _carFileDetailEntity = value;
          if (_carFileDetailEntity != null) {
            _idCardZImage = value.clientIdZImage;
            _idCardFImage = value.clientIdFImage;
            _licenseZImage = value.licenseZImage;
            _licenseFImage = value.licenseFImage;
            _certificateImage = value.certificateImage;
            _liName = value.clientName;
            _certImage = value.certImage;
            _invoiceImage = value.invoiceImage;
            if (value.registerType == 1) {
              _nameController.text = value.clientName;
              _mobileController.text = value.clientMobile;
              _idCardController.text = value.clientIdcode;
            } else {
              _nameController.text = value.businessName;
              _mobileController.text = value.businessMobile;
              _idCardController.text = value.businessCode;
            }
            _businessImage = value.businessImage??null;
            typeIndex = value.registerType;
          }
          _carProfile = true;
          checkApiEnd();
        }
      },
    );
  }

  //获取车源资料
  void getFileImage() {
    Http.getInstance()
        .getImageField(pid: int.parse(widget.pid), vinId: widget.vid)
        .then((value) {
      if (mounted) {
        _fileImageList = value;
        _fileImage = true;
        checkApiEnd();
      }
    });
  }

  //检查api是否已经请求完
  void checkApiEnd() {
    print(_carProfile);
    print(_fileImage);
    if (_carProfile == true && _fileImage == true) {
      _loading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeBoard(context: context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('回传资料'),
          centerTitle: true,
          brightness: Brightness.dark,
        ),
        body: _loading == false
            ? SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      //信息
                      info(),
                      //用户信息
                      userInfo(),
                      //提交按钮
                      sub(),
                    ],
                  ),
                ),
              )
            : loadingData(),
      ),
    );
  }

  //信息
  info() {
    return Column(
      children: [
        Container(
          width: 690.w,
          margin: EdgeInsets.only(top: 30.w),
          padding: EdgeInsets.all(30.w),
          decoration: comBoxDecoration(),
          child: Wrap(
            spacing: 30.w,
            children: [
              //顶部内容
              top(),
              //---------------------------证件上传
              placeColumn(widgets: [
                //行驶证正面
                licenseZ(),
                //行驶证反面
                licenseF(),
              ], text: "行驶证"),
              placeColumn(
                widgets: [
                  if (typeIndex == 1)

                    ///身份证正面
                    idCardZ(),
                  if (typeIndex == 1)

                    ///身份证反面
                    idCardF(),
                  if (typeIndex == 2)

                    ///营业执照
                    business(),
                ],
                text: "客户资料",
              ),
              placeColumn(
                widget: cert(), //机动车证书
                text: "机动车登记证书",
              ),
              placeColumn(
                widgets: [
                  //机动车合格证书
                  certificateImage(),
                ],
                text: "机动车出厂合格证书",
              ),
              placeColumn(
                widgets: [
                  //机动车发票
                  invoice(),
                ],
                text: "机动车销售统一发票",
              ),
              fileImageWidget(),
            ],
          ),
        ),
      ],
    );
  }

  //顶部内容
  top() {
    return Column(
      children: [
        conFileContainer(
          title: '车架号',
          wid: '${widget.vin}',
          widget: false,
        ),
        conFileContainer(
          title: '颜色',
          wid: '${Uri.decodeComponent(widget.colorName)}',
          widget: false,
        ),
        if (_carFileDetailEntity?.state != 2 &&
            _carFileDetailEntity?.state != 3)
          conFileContainer(
              title: '客户类型',
              wid: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (typeIndex != 1) {
                        typeIndex = 1;
                        _nameController.text = "";
                        _mobileController.text = "";
                        _idCardController.text = "";
                        setState(() {});
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Icon(
                            typeIndex == 1
                                ? Icons.check_circle
                                : Icons.panorama_fish_eye,
                            size: 40.sp,
                            color: ColorConfig.themeColor,
                          ),
                          Text(
                            "个人",
                            style: TextStyle(
                              fontSize: 30.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  GestureDetector(
                    onTap: () {
                      if (typeIndex != 2) {
                        typeIndex = 2;
                        _nameController.text = "";
                        _mobileController.text = "";
                        _idCardController.text = "";
                        setState(() {});
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Icon(
                            typeIndex == 2
                                ? Icons.check_circle
                                : Icons.panorama_fish_eye,
                            size: 40.sp,
                            color: ColorConfig.themeColor,
                          ),
                          Text(
                            "公司",
                            style: TextStyle(
                              fontSize: 30.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              widget: true),
        if (_carFileDetailEntity?.state == 2 ||
            _carFileDetailEntity?.state == 3)
          conFileContainer(
              title: '客户类型', wid: typeIndex == 1 ? '个人' : '公司', widget: false),
      ],
    );
  }

  //客户信息
  userInfo() {
    return Container(
      width: 690.w,
      margin: EdgeInsets.only(top: 30.w, bottom: 30.w),
      padding: EdgeInsets.all(30.w),
      decoration: comBoxDecoration(),
      child: Column(
        children: [
          conFileContainer(
            title: typeIndex == 1 ? '客户姓名' : '企业名称',
            wid: comTextField(
              controller: _nameController,
              readOnly: isShState(),
              textInputAction: TextInputAction.next,
            ),
            widget: true,
          ),
          conFileContainer(
            title: typeIndex == 1 ? '客户手机号' : '企业联系电话',
            wid: comTextField(
              controller: _mobileController,
              readOnly: isShState(),
              textInputType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              maxLength: 11,
            ),
            widget: true,
          ),
          Offstage(
            offstage: _carFileDetailEntity != null &&
                    _carFileDetailEntity.clientMobileState == '3'
                ? false
                : true,
            child: Container(
              width: 690.w,
              child: Text(
                '${_carFileDetailEntity?.clientMobileRemarks}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 28.sp,
                  color: Colors.red[300],
                ),
              ),
            ),
          ),
          conFileContainer(
            title: typeIndex == 1 ? '客户身份证号' : '营业执照证件号',
            wid: comTextField(
                controller: _idCardController,
                readOnly: isShState(),
                textInputType: TextInputType.text),
            widget: true,
          ),
        ],
      ),
    );
  }

  //行驶证正面
  Container licenseZ() {
    return Container(
      width: 300.w,
      height: 200.w,
      decoration: BoxDecoration(
        color: _licenseZImage == null
            ? ColorConfig.themeColor[50]
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: InkWell(
        onTap: () {
          apiUploadImg(
              type: Config.vehicle,
              func: (img) {
                Loading.show(status: '行驶证认证中...');
                Http.getInstance()
                    .ocr(
                        image: img, type: 'front', imgType: 'vehicle')
                    .then((ocrRes) {
                  if (widget.vin != ocrRes.data['vin'] ||
                      ocrRes.data['owner'] == null ||
                      ocrRes.data['owner'] == "") {
                    KlAlert.showAlert(
                        content: '行驶证不清晰或有错误(保证行驶证的车架号和上面的车架号一致,且姓名清晰)，请重新上传',
                        sureFunc: () {
                          MyRoute.router.pop(context);
                        });
                    return false;
                  }
                  setState(() {
                    _licenseZImage = img;
                    _liName = ocrRes.data['owner'];
                  });
                }).whenComplete(() {
                  Loading.dismiss();
                });
              });
        },
        child: _licenseZImage == null
            ? imgUp("请上传行驶证正面")
            : uploadImgTouch2(
                img: _licenseZImage,
                uploadInfo: "行驶证",
                showReload: true,
                deleteFunc: isShState()
                    ? null
                    : () {
                        _licenseZImage = null;
                        setState(() {});
                      },
                function: () {
                  List imgS = [_licenseZImage];
                  int index = 0;
                  if (isShState()) {
                    imgS = [_licenseZImage, _licenseZImage];
                    index = 0;
                  }
                  imgPreview(imgS, index, title: "行驶证");
                },
              ),
      ),
    );
  }

  //行驶证反面
  licenseF() {
    return Column(
      children: [
        Container(
          width: 300.w,
          height: 200.w,
          decoration: BoxDecoration(
            color: _licenseFImage == null
                ? ColorConfig.themeColor[50]
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20.w),
          ),
          child: InkWell(
            onTap: () {
              apiUploadImg(
                type: Config.vehicle,
                func: (img) {
                  Loading.show(status: '行驶证认证中...');
                  Http.getInstance()
                      .ocr(
                          image: img,
                          type: 'back',
                          imgType: 'vehicle')
                      .then((ocrRes) {
                    setState(() {
                      _licenseFImage = img;
                    });
                  }).whenComplete(() {
                    Loading.dismiss();
                  });
                },
              );
            },
            child: _licenseFImage == null
                ? imgUp("请上传行驶证反面")
                : uploadImgTouch2(
                    img: _licenseFImage,
                    uploadInfo: "行驶证反面",
                    showReload: true,
                    deleteFunc: isShState()
                        ? null
                        : () {
                            _licenseFImage = null;
                            setState(() {});
                          },
                    function: () {
                      List imgS = [_licenseFImage];
                      int index = 0;
                      if (isShState()) {
                        imgS = [_licenseZImage, _licenseFImage];
                        index = 1;
                      }
                      imgPreview(imgS, index, title: "行驶证");
                    },
                  ),
          ),
        ),
        //行驶证反面信息
        comOffstage(
            offstage: _carFileDetailEntity != null &&
                    _carFileDetailEntity.licenseFState == 3
                ? false
                : true,
            errorText: _carFileDetailEntity?.licenseFRemarks),
      ],
    );
  }

  //机动车出厂合格证
  certificateImage() {
    return Column(
      children: [
        Container(
          width: _imgW,
          height: _imgH,
          decoration: BoxDecoration(
            color: _certificateImage == null
                ? ColorConfig.themeColor[50]
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20.w),
          ),
          child: InkWell(
            onTap: () {
              apiUploadImg(
                  type: Config.carCert,
                  func: (img) {
                    setState(() {
                      _certificateImage = img;
                    });
                  });
            },
            child: _certificateImage == null
                ? imgUp('请上传机动车出厂合格证')
                : uploadImgTouch2(
                    img: _certificateImage,
                    uploadInfo: "机动车出厂合格证",
                    showReload: true,
                    deleteFunc: isShState()
                        ? null
                        : () {
                            _certificateImage = null;
                            setState(() {});
                          },
                    function: () {
                      imgPreview([_certificateImage], 0, title: "机动车出厂合格证");
                    },
                  ),
          ),
        ),
        comOffstage(
            offstage: _carFileDetailEntity != null &&
                    _carFileDetailEntity.certificateImageState == '3'
                ? false
                : true,
            errorText: _carFileDetailEntity?.certificateImageRemarks),
      ],
    );
  }

  //机动车
  cert() {
    return Column(
      children: [
        Wrap(
          runSpacing: 15.w,
          spacing: 30.w,
          children: [
            for (int i = 0;
                i < (_certImage != null ? _certImage.split(',').length : 0);
                i++)
              GestureDetector(
                onTap: () {
                  imgPreview(_certImage.split(','), i, title: "机动车登记证书");
                },
                child: Container(
                  width: _imgW,
                  height: _imgH,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            width: _imgW,
                            height: _imgH,
                            child: showImageNetwork(
                                img: _certImage.split(',')[i])),
                      ),
                      if (!isShState())
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              KlAlert.showAlert(
                                  content: "确认删除该图片？",
                                  sureFunc: () {
                                    List imgArr = _certImage.split(',');
                                    imgArr.removeAt(i);
                                    _certImage = imgArr.join(',');
                                    setState(() {});
                                    MyRoute.router.pop(context);
                                  },
                                  cancelFunc: () {
                                    MyRoute.router.pop(context);
                                  });
                            },
                            child: Icon(
                              Icons.cancel_outlined,
                              size: 50.sp,
                              color: ColorConfig.cancelColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            if (!isShState())
              GestureDetector(
                onTap: () {
                  apiUploadImg(
                      type: Config.carCert,
                      func: (value) {
                        List _certImageArr =
                            _certImage != null ? _certImage.split(',') : [];
                        _certImageArr.add(value);
                        _certImage = _certImageArr.join(',');
                        setState(() {});
                      });
                },
                child: Container(
                  width: _imgW,
                  height: _imgH,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 1.w, color: ColorConfig.themeColor),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: ColorConfig.themeColor,
                        size: 60.sp,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.w),
                        alignment: Alignment.center,
                        child: Text(
                          "上传图片",
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xff333333),
                            height: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        comOffstage(
            offstage: _carFileDetailEntity != null &&
                    _carFileDetailEntity.certState == '3'
                ? false
                : true,
            errorText: _carFileDetailEntity?.certRemarks),
      ],
    );
  }

  //发票
  invoice() {
    return Column(
      children: [
        Container(
          width: 300.w,
          height: 200.w,
          decoration: BoxDecoration(
            color: _invoiceImage == null
                ? ColorConfig.themeColor[50]
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20.w),
          ),
          child: InkWell(
            onTap: () {
              apiUploadImg(
                  type: Config.carInvoice,
                  func: (img) {
                    setState(() {
                      _invoiceImage = img;
                    });
                  });
            },
            child: _invoiceImage == null
                ? imgUp('请上传机动车销售统一发票')
                : uploadImgTouch2(
                    img: _invoiceImage,
                    uploadInfo: "机动车销售统一发票",
                    showReload: true,
                    deleteFunc: isShState()
                        ? null
                        : () {
                            _invoiceImage = null;
                            setState(() {});
                          },
                    function: () {
                      imgPreview([_invoiceImage], 0, title: "机动车发票");
                    },
                  ),
          ),
        ),
        comOffstage(
            offstage: _carFileDetailEntity != null &&
                    _carFileDetailEntity.invoiceState == '3'
                ? false
                : true,
            errorText: _carFileDetailEntity?.invoiceRemarks),
      ],
    );
  }

  //身份证正面
  idCardZ() {
    return Column(
      children: [
        Container(
          width: 300.w,
          height: 200.w,
          decoration: BoxDecoration(
            color: _idCardZImage == null
                ? ColorConfig.themeColor[50]
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20.w),
          ),
          child: InkWell(
            onTap: () {
              if (_licenseZImage == null) {
                KlAlert.showAlert(
                    content: '请先上传行驶证',
                    sureFunc: () {
                      MyRoute.router.pop(context);
                    });
                return false;
              }

              ImgUpload.upload(func: (image) {
                Loading.show();
                Http.getInstance()
                    .imgUpload(image, Config.idCard)
                    .then((value) {
                  Loading.show(status: '身份证认证中...');
                  Http.getInstance()
                      .ocr(
                          image: value.fileUrl,
                          type: 'front',
                          imgType: 'idcard')
                      .then((ocrRes) {
                    setState(() {
                      if (ocrRes.data['name'] != _liName) {
                        KlAlert.showAlert(
                            content: '身份证和行驶证的信息不匹配,请重新上传，请确保行驶证与身份证绝对清晰，无反光、模糊等情况',
                            sureFunc: () {
                              MyRoute.router.pop(context);
                            });
                        return false;
                      }
                      _idCardZImage = value.fileUrl;
                      _nameController.text = ocrRes.data['name'];
                      _idCardController.text = ocrRes.data['num'];
                      setState(() {});
                    });
                  }).whenComplete(() {
                    Loading.dismiss();
                  });

                }).whenComplete(() {
                  Loading.dismiss();
                });
              });
            },
            child: _idCardZImage == null
                ? imgUp('请上传客户身份证正面')
                : uploadImgTouch2(
                    img: _idCardZImage,
                    uploadInfo: "客户身份证正面",
                    showReload: true,
                    deleteFunc: isShState()
                        ? null
                        : () {
                            _idCardZImage = null;
                            setState(() {});
                          },
                    function: () {
                      List imgS = [_idCardZImage];
                      int index = 0;
                      if (isShState()) {
                        imgS = [_idCardZImage, _idCardFImage];
                      }
                      imgPreview(imgS, index, title: "身份证");
                    },
                  ),
          ),
        ),
        comOffstage(
            offstage: _carFileDetailEntity != null &&
                    _carFileDetailEntity.clientIdZImageState == '3'
                ? false
                : true,
            errorText: _carFileDetailEntity?.clientIdZImageRemarks),
      ],
    );
  }

  //身份证反面
  idCardF() {
    return Column(
      children: [
        Container(
          width: 300.w,
          height: 200.w,
          decoration: BoxDecoration(
            color: _idCardFImage == null
                ? ColorConfig.themeColor[50]
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20.w),
          ),
          child: InkWell(
            onTap: () {
              if (_licenseZImage == null) {
                KlAlert.showAlert(
                    content: '请先上传行驶证',
                    sureFunc: () {
                      MyRoute.router.pop(context);
                    });
                return false;
              }



              apiUploadImg(
                  type: Config.idCard,
                  func: (img) {
                    Loading.show(status: '身份证认证中...');
                    Http.getInstance()
                        .ocr(
                            image: img,
                            type: 'back',
                            imgType: 'idcard')
                        .then((ocrRes) {
                      setState(() {
                        _idCardFImage = img;
                      });
                    }).whenComplete(() {
                      Loading.dismiss();
                    });

                  });
            },
            child: _idCardFImage == null
                ? imgUp('请上传客户身份证反面')
                : uploadImgTouch2(
                    img: _idCardFImage,
                    uploadInfo: "客户身份证反面",
                    showReload: true,
                    deleteFunc: isShState()
                        ? null
                        : () {
                            _idCardFImage = null;
                            setState(() {});
                          },
                    function: () {
                      List imgS = [_idCardFImage];
                      int index = 0;
                      if (isShState()) {
                        imgS = [_idCardZImage, _idCardFImage];
                        index = 1;
                      }
                      imgPreview(imgS, index, title: "身份证");
                    },
                  ),
          ),
        ),
        comOffstage(
            offstage: _carFileDetailEntity != null &&
                    _carFileDetailEntity.clientIdFImageState == '3'
                ? false
                : true,
            errorText: _carFileDetailEntity?.clientIdFImageRemarks),
      ],
    );
  }

  //营业执照
  business() {
    return Column(
      children: [
        Container(
          width: 300.w,
          height: 200.w,
          decoration: BoxDecoration(
            color: _businessImage == null || _businessImage.length<=0
                ? ColorConfig.themeColor[50]
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20.w),
          ),
          child: InkWell(
            onTap: () {
              if (_licenseZImage == null) {
                KlAlert.showAlert(
                    content: '请先上传行驶证',
                    sureFunc: () {
                      MyRoute.router.pop(context);
                    });
                return false;
              }


              apiUploadImg(
                  type: Config.business,
                  func: (img) {
                    Loading.show(status: "正在识别...");
                    Http.getInstance()
                        .ocr(
                        image: img,
                        imgType: Config.business,
                        type: 'front')
                        .then((idCardRes) {

                      if (idCardRes.data['name'] != _liName) {
                        KlAlert.showAlert(
                            content: '营业执照和行驶证的信息不匹配，请重新上传。请确保行驶证与营业执照绝对清晰，无反光、模糊等情况。',
                            sureFunc: () {
                              MyRoute.router.pop(context);
                            });
                        return false;
                      }
                      _businessImage = img;
                      _idCardController.text = idCardRes.data["reg_num"];
                      _nameController.text = idCardRes.data["name"];
                      setState(() {

                      });
                    }).whenComplete(() {
                      Loading.dismiss();
                    });
                  });
            },
            child: _businessImage == null || _businessImage.length<=0
                ? imgUp('请上传企业营业执照')
                : uploadImgTouch2(
                    img: _businessImage,
                    uploadInfo: "企业营业执照",
                    showReload: true,
                    deleteFunc: isShState()
                        ? null
                        : () {
                            _businessImage = null;
                            setState(() {});
                          },
                    function: () {
                      imgPreview([_businessImage], 0, title: "营业执照");
                    },
                  ),
          ),
        ),
        comOffstage(
            offstage: _carFileDetailEntity != null &&
                    _carFileDetailEntity.businessImageState == '3'
                ? false
                : true,
            errorText: _carFileDetailEntity?.businessImageRemarks),
      ],
    );
  }

  //是不是审核中或者已通过状态
  bool isShState() {
    if (_carFileDetailEntity?.state == 2 || _carFileDetailEntity?.state == 3) {
      return true;
    } else {
      return false;
    }
  }

  //资料图片视图
  fileImageWidget() {
    comThisContainer(CarFileImageChild carFileImageChild, int index) {
      List imgArr = _fileImageList[index].imgs != null &&
              _fileImageList[index].imgs.length > 0
          ? _fileImageList[index].imgs.split(',')
          : [];
      return Column(
        children: [
          Wrap(
            runAlignment: WrapAlignment.end,
            runSpacing: 15.w,
            spacing: 30.w,
            children: [
              for (int i = 0; i < imgArr.length; i++)
                GestureDetector(
                  onTap: () {
                    imgPreview(imgArr,i,title: _fileImageList[index].fieldName);
                  },
                  child: Container(
                    width: _imgW,
                    height: _imgH,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              width: _imgW,
                              height: _imgH,
                              child: showImageNetwork(img: imgArr[i])),
                        ),
                        if (!isShState())
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                KlAlert.showAlert(
                                    content: "确认删除该图片？",
                                    sureFunc: () {
                                      imgArr.removeAt(i);
                                      _fileImageList[index].imgs =
                                          imgArr.join(',');
                                      setState(() {});
                                      MyRoute.router.pop(context);
                                    },
                                    cancelFunc: () {
                                      MyRoute.router.pop(context);
                                    });
                              },
                              child: Icon(
                                Icons.cancel_outlined,
                                size: 50.sp,
                                color: ColorConfig.cancelColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              Offstage(
                offstage: imgArr.length >= _fileImageList[index].uploadCount ||
                        isShState()
                    ? true
                    : false,
                child: GestureDetector(
                  onTap: () {
                    apiUploadImg(
                        type: Config.dynamic,
                        func: (value) {
                          imgArr.add(value);
                          _fileImageList[index].imgs = imgArr.join(',');
                          setState(() {});
                        });
                  },
                  child: Container(
                    width: _imgW,
                    height: _imgH,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 1.w, color: ColorConfig.themeColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: ColorConfig.themeColor,
                          size: 60.sp,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.w),
                          alignment: Alignment.center,
                          child: Text(
                            "上传图片",
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Color(0xff333333),
                              height: 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.w),
                child: Text(
                  "${carFileImageChild != null && carFileImageChild.status == '2' ? carFileImageChild.cause : ''}",
                  style: TextStyle(
                    fontSize: 32.sp,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        for (int i = 0; i < _fileImageList.length; i++)
          placeColumn(
            widget: comThisContainer(
              _fileImageList[i].child,
              i,
            ),
            text: _fileImageList[i].fieldName,
          ),
      ],
    );
  }

  //提交
  sub() {
    return Offstage(
      offstage: _carFileDetailEntity == null ||
              (_carFileDetailEntity.state != 2 &&
                  _carFileDetailEntity.state != 3)
          ? false
          : true,
      child: Container(
        margin: EdgeInsets.only(bottom: 50.w),
        child: eleButton(
            func: () {
              //关闭键盘
              closeBoard(context: context);
              //防止重复提交
              if (CommonUtil.checkClick(needTime: 1) == false) {
                return false;
              }
              //检查自定义资料图片是否上传完整-start
              bool havingImg = true;
              for (int i = 0; i < _fileImageList.length; i++) {
                CarFileImageEntity value = _fileImageList[i];
                if (value.imgs == "") {
                  Loading.toast(msg: value.fieldName + "：至少传一张图片");
                  havingImg = false;
                  break;
                }
              }

              if (!havingImg) {
                return false;
              }
              //检查自定义资料图片是否上传完整-end
              //验证行驶证正面
              if (_licenseZImage == null || _licenseZImage.length <= 0) {
                KlAlert.showAlert(
                    content: '请上传行驶证正面',
                    sureFunc: () {
                      MyRoute.router.pop(context);
                    });
                return false;
              }
              //验证行驶证反面
              if (_licenseFImage == null || _licenseFImage.length <= 0) {
                KlAlert.showAlert(
                    content: '请上传行驶证反面',
                    sureFunc: () {
                      MyRoute.router.pop(context);
                    });
                return false;
              }
              if(typeIndex==1){
                //身份证正面
                if (_idCardZImage == null || _idCardZImage.length <= 0) {
                  KlAlert.showAlert(
                      content: '请上传客户身份证正面',
                      sureFunc: () {
                        MyRoute.router.pop(context);
                      });
                  return false;
                }
                //身份证正面
                if (_idCardFImage == null || _idCardFImage.length <= 0) {
                  KlAlert.showAlert(
                      content: '请上传客户身份证反面面',
                      sureFunc: () {
                        MyRoute.router.pop(context);
                      });
                  return false;
                }
              }

              if(typeIndex==2){
                if(_businessImage == null || _businessImage.length<=0){
                  KlAlert.showAlert(
                      content: '请上传营业执照',
                      sureFunc: () {
                        MyRoute.router.pop(context);
                      });
                  return false;
                }
              }

              //验证机动车登记证书
              if (_certificateImage == null || _certificateImage.length <= 0) {
                KlAlert.showAlert(
                    content: '请上传机动车出厂合格证',
                    sureFunc: () {
                      MyRoute.router.pop(context);
                    });
                return false;
              }
              //验证机动车登记证书
              if (_certImage == null || _certImage.length <= 0) {
                KlAlert.showAlert(
                    content: '请上传机动车登记证书',
                    sureFunc: () {
                      MyRoute.router.pop(context);
                    });
                return false;
              }
              //验证机动车发票
              if (_invoiceImage == null || _invoiceImage.length <= 0) {
                KlAlert.showAlert(
                    content: '请上传机动车发票',
                    sureFunc: () {
                      MyRoute.router.pop(context);
                    });
                return false;
              }

              //验证姓名
              if (_nameController.text.length <= 0) {
                KlAlert.showAlert(
                    content: typeIndex == 1 ? '请填写客户姓名!' : "请填写企业名称",
                    sureFunc: () {
                      MyRoute.router.pop(context);
                    });
                return false;
              }
              if (typeIndex == 1) {
                //验证手机号
                if (CommonUtil.isChinaPhoneLegal(_mobileController.text) ==
                    false) {
                  KlAlert.showAlert(
                      content: '请填写正确的手机号',
                      sureFunc: () {
                        MyRoute.router.pop(context);
                      });
                  return false;
                }
              } else {
                if (_mobileController.text.length == 0) {
                  KlAlert.showAlert(
                      content: '请填写企业联系电话',
                      sureFunc: () {
                        MyRoute.router.pop(context);
                      });
                  return false;
                }
              }

              if (typeIndex == 1) {
                //验证身份证
                if (CommonUtil.isIdCard(_idCardController.text) == false) {
                  KlAlert.showAlert(
                      content: '请填写正确的身份证号',
                      sureFunc: () {
                        MyRoute.router.pop(context);
                      });
                  return false;
                }
              } else {
                //验证身份证
                if (_idCardController.text.length == 0) {
                  KlAlert.showAlert(
                      content: '请填写营业执照证件号',
                      sureFunc: () {
                        MyRoute.router.pop(context);
                      });
                  return false;
                }
              }

              KlAlert.showAlert(
                  content: '确认资料并提交？',
                  sureFunc: () {
                    //在这里处理自定义的资料图片
                    List<CarFileImageEntity> carFileImageList = [];
                    carFileImageList = _fileImageList;
                    carFileImageList.asMap().forEach((key, value) {
                      carFileImageList[key].imgs = CommonUtil.imgDeal(
                          imgStr: value.imgs, type: Config.dynamic);
                    });

                    Loading.show();
                    Http.getInstance()
                        .carProfileUpload(
                            vid: widget.vid,
                            type: typeIndex,
                            vFurl: CommonUtil.imgDeal(
                                imgStr: _licenseZImage, type: Config.vehicle),
                            vBUrl: CommonUtil.imgDeal(
                                imgStr: _licenseFImage, type: Config.vehicle),
                            cUrl: CommonUtil.imgDeal(
                                imgStr: _certImage, type: Config.carCert),
                            iUrl: CommonUtil.imgDeal(
                                imgStr: _invoiceImage, type: Config.carInvoice),
                            aid: _carFileDetailEntity?.id,
                            certUrl: CommonUtil.imgDeal(
                                imgStr: _certificateImage,
                                type: Config.carCert),
                            idCardFUrl: _idCardZImage != null
                                ? CommonUtil.imgDeal(
                                    imgStr: _idCardZImage, type: Config.idCard)
                                : '',
                            idCardBUrl: _idCardFImage != null
                                ? CommonUtil.imgDeal(
                                    imgStr: _idCardFImage, type: Config.idCard)
                                : "",
                            idCardCode: _idCardController.text,
                            clientName: _nameController.text,
                            clientMobile: _mobileController.text,
                            businessCode: _idCardController.text,
                            businessName: _nameController.text,
                            businessMobile: _mobileController.text,
                            businessImage: _businessImage != null
                                ? CommonUtil.imgDeal(
                                    imgStr: _businessImage,
                                    type: Config.business)
                                : "",
                            fileImage: jsonEncode(carFileImageList))
                        .then((value) {
                      MyRoute.router.pop(context);
                      Loading.toast(msg: "上传成功",maskType:EasyLoadingMaskType.clear);
                      Future.delayed(Duration(seconds: 2)).then((value){
                        if(mounted){
                          MyRoute.router.pop(context, true);
                        }
                      });
                    }).whenComplete(() {
                      Loading.dismiss();
                    });
                  },
                  cancelFunc: () {
                    MyRoute.router.pop(context);
                  });
            },
            color: ColorConfig.themeColor,
            circular: 48.w,
            width: 484.w,
            height: 96.w,
            con: '提交'),
      ),
    );
  }
}
