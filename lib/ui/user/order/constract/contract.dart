import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/entity/tab_purchase/contract_entity.dart';
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
import 'package:tob/widget/pdf_show.dart';

class UserOrderContract extends StatefulWidget {
  final int oid;
  final String type;

  const UserOrderContract({Key key, @required this.oid, this.type});

  @override
  _UserOrderContractState createState() => _UserOrderContractState();
}

class _UserOrderContractState extends State<UserOrderContract> {
  ContractEntity _contractEntity;
  List<String> imgList = [];
  int imgIndex = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  ///获取数据
  getData() {
    Future.delayed(Duration(milliseconds: 300)).then((value) {
      Http.getInstance().getContract(oid: widget.oid).then((value) {
        setState(() {
          _contractEntity = value;
          String listStr = _contractEntity.contract != null
              ? _contractEntity.contract.contract
              : "";
          if (listStr.length > 0) imgList.addAll(listStr?.split(','));
        });
      });
    });
  }

  @override
  void dispose() {
    Loading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("签合同"),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      body: _contractEntity != null
          ? SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(30.w),
                child: Column(
                  children: [
                    //  合同流程
                    process(),
                    //介绍
                    intro(),
                    //  上传图片
                    image(),

                    ///  提交按钮
                    if (widget.type == null) btn(),
                  ],
                ),
              ),
            )
          : loadingData(),
    );
  }

  process() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "合同流程:",
            style: TextStyle(
                fontSize: 20.w,
                color: Color(0xff999999),
                height: 1,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.w),
          Row(
            children: [
              processBtn("下载合同"),
              processBtn("签署合同"),
              processBtn("拍照上传"),
              processBtn("邮寄纸质合同", show: false),
            ],
          ),
        ],
      ),
    );
  }

  processBtn(String text, {bool show = true}) {
    return Container(
      child: Row(
        children: [
          Container(
            height: 49.w,
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            decoration: BoxDecoration(
              color: ColorConfig.themeColor,
              borderRadius: BorderRadius.circular(10.w),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              "$text",
              style: TextStyle(fontSize: 26.sp, height: 1, color: Colors.white),
            ),
          ),
          if (show == true)
            Icon(
              Icons.arrow_right_alt,
              color: ColorConfig.themeColor,
              size: 38.w,
            )
        ],
      ),
    );
  }

  intro() {
    richText(String text) {
      return Container(
        margin: EdgeInsets.only(top: 30.w),
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: "$text",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26.sp,
                color: Color(0xff333333),
              ),
            ),
          ]),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30.w),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '一.请先下载合同后，签字盖章，如合同存在多页，需要盖骑缝章。',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26.sp,
                  color: Color(0xff333333),
                ),
              ),
              WidgetSpan(
                child: SizedBox(width: 10.w),
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      GradualChangeRoute(
                        PdfShowPage(
                          url: _contractEntity.contractUrl,
                          title: _contractEntity.title,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    child: Text(
                      "点击下载合同",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: ColorConfig.themeColor,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        richText("二.用户签署后通过拍照上传合同（每一页都需要拍照并上传)"),
        richText("三.同时用户需要将纸质合同快递都赶车网。"),
        SizedBox(height: 20.w),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '邮寄信息',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26.sp,
                  color: Color(0xff333333),
                ),
              ),
              WidgetSpan(
                child: SizedBox(width: 30.w),
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                            text:
                                '${_contractEntity.main.name}\n${_contractEntity.main.phone}\n${_contractEntity.main.address}'))
                        .then((value) {
                      Loading.toast(msg: "复制成功");
                    }).catchError((err) {
                      Loading.toast(msg: "复制失败,请重新进入页面");
                    });
                  },
                  child: Container(
                    child: Text(
                      "点击复制邮寄信息",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: ColorConfig.themeColor,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        richText("收件人：${_contractEntity.main.name}"),
        richText("联系电话：${_contractEntity.main.phone}"),
        richText("收件地址：${_contractEntity.main.address}"),
        if (widget.type == null)
          Text(
            "可对图片进行拖拽排序哦！",
            style: TextStyle(fontSize: 26.sp, color: Colors.redAccent),
          )
      ],
    );
  }

  image() {
    double imgWidth = 220.w;
    double imgHeight = 150.w;
    return Container(
      alignment: Alignment.centerLeft,
      child: Wrap(
        runSpacing: 14.w,
        spacing: 14.w,
        children: [
          for (int i = 0; i < imgList.length; i++)
            DragTarget(
              builder: (BuildContext context, List candidateData,
                  List rejectedData) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      GradualChangeRoute(
                        PhotoPreview(
                          galleryItems: imgList,
                          defaultImage: i,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: imgWidth,
                    height: imgHeight,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: imgWidth,
                            height: imgHeight,
                            child: widget.type == null
                                ? Draggable(
                                    data: i,
                                    child: showImageNetwork(img: imgList[i]),
                                    feedback: Container(
                                      width: imgWidth,
                                      height: imgHeight,
                                      child: showImageNetwork(
                                        img: imgList[i],
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: imgWidth,
                                    height: imgHeight,
                                    child: showImageNetwork(
                                      img: imgList[i],
                                    ),
                                  ),
                          ),
                        ),
                        if (widget.type == null)
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                KlAlert.showAlert(
                                    content: "确认删除该图片？",
                                    sureFunc: () {
                                      imgList.removeAt(i);
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
                );
              },
              onWillAccept: (index) {
                return true;
              },
              onAccept: (index) {
                if (index != i) {
                  var indexTemp = imgList[index];
                  var iTemp = imgList[i];
                  imgList[index] = iTemp;
                  imgList[i] = indexTemp;
                  setState(() {});
                }
              },
              onLeave: (color) {},
            ),
          if (widget.type == null)
            Container(
              child: GestureDetector(
                onTap: () {
                  ImgUpload.upload(func: (value) {
                    print(value);
                    Loading.show();
                    Http.getInstance()
                        .imgUpload(value, Config.contract)
                        .then((imgRes) {
                      imgList.add(imgRes.fileUrl);
                      setState(() {});
                    }).whenComplete(() {
                      Loading.dismiss();
                    });
                  });
                },
                child: Container(
                  width: imgWidth,
                  height: imgHeight,
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
                          "上传合同图片",
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
        ],
      ),
    );
  }

  btn() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 50.w),
          child: Text(
            "${_contractEntity?.contract?.status == 2 ? _contractEntity?.contract?.remark : ''}",
            style: TextStyle(color: Colors.redAccent, fontSize: 26.sp),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 63.w),
          child: eleButton(
            width: 513.w,
            height: 72.w,
            con: "提交",
            circular: 36.w,
            color: ColorConfig.themeColor,
            func: () {
              if (imgList.length <= 0) {
                Loading.toast(msg: "请至少上传一张合同图片");
                return false;
              }
              List imgListTemp = imgList;
              imgListTemp.asMap().forEach((key, value) {
                imgListTemp[key] =
                    CommonUtil.imgDeal(imgStr: value, type: Config.contract);
              });
              KlAlert.showAlert(
                content: "确认上传合同?",
                sureFunc: () {
                  Loading.show();
                  Http.getInstance()
                      .uploadContract(
                          oid: widget.oid,
                          contractUrils: imgListTemp.join(','),
                          contractId: _contractEntity?.contract?.id)
                      .then((value) {
                    MyRoute.router.pop(context);

                    Loading.toast(
                        msg: '提交成功', maskType: EasyLoadingMaskType.clear);

                    //刷新上一个页面该订单的状态
                    //并且返回
                    Future.delayed(Duration(seconds: 2)).then((value) {
                      if (mounted) {
                        MyRoute.router
                            .pop(context, {"orderId": widget.oid, "status": 1});
                      }
                    });
                  }).whenComplete(() => Loading.dismiss());
                },
                cancelFunc: () {
                  MyRoute.router.pop(context);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
