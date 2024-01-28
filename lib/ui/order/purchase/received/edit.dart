import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tob/entity/purchase/purchase_receive_entity.dart';
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

class ReceivedEditPage extends StatefulWidget {
  final int id;
  final int pid;
  final int all;
  final int should;
  final int can;

  ReceivedEditPage(
      {@required this.id,
      @required this.all,
      @required this.should,
      @required this.can,
      this.pid});

  @override
  _ReceivedEditPageState createState() => _ReceivedEditPageState();
}

class _ReceivedEditPageState extends State<ReceivedEditPage> {
  TextEditingController _numController = new TextEditingController();
  PurchaseReceiveEntity _purchaseReceiveEntity = new PurchaseReceiveEntity();
  List imgArr = [];
  bool _sub = true;

  @override
  void initState() {
    if (widget.id != null && widget.id > 0) {
      getData();
    }
    super.initState();
  }

  @override
  void dispose() {
    Loading.dismiss();
    _numController.dispose();
    super.dispose();
  }

  //获取数据
  getData() {
    Loading.show();
    Http.getInstance().purchaseGetReceive(rid: widget.id).then((value) {
      setState(() {
        _purchaseReceiveEntity = value;
        imgArr = value.images.split(',');
        _numController.text = value.sum;
      });
    }).whenComplete(() {
      Loading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        closeBoard(context: context);
      },
      child: Scaffold(
        appBar: commonAppbarTitle(title: '上传收车单'),
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
                //信息
                info(),
                //提交
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
                  func: _sub == false
                      ? null
                      : () {
                          if (_sub == false) {
                            return false;
                          }
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (_numController.text.isEmpty) {
                            KlAlert.showAlert(
                              content: '请填写数量',
                              sureFunc: () {
                                MyRoute.router.pop(context);
                              },
                            );
                            return false;
                          } else if (int.parse(_numController.text) == 0) {
                            KlAlert.showAlert(
                              content: '数量必须大于0',
                              sureFunc: () {
                                MyRoute.router.pop(context);
                              },
                            );
                            return false;
                          } else if (int.parse(_numController.text) >
                              widget.can) {
                            if (widget.id == 0) {
                              KlAlert.showAlert(
                                content: '数量不能超过未收车辆',
                                sureFunc: () {
                                  MyRoute.router.pop(context);
                                },
                              );
                              return false;
                            } else {
                              if (int.parse(_numController.text) >
                                  (widget.can +
                                      int.parse(_purchaseReceiveEntity.sum))) {
                                KlAlert.showAlert(
                                  content:
                                      '数量只能小于等于${(widget.can + int.parse(_purchaseReceiveEntity.sum))}',
                                  sureFunc: () {
                                    MyRoute.router.pop(context);
                                  },
                                );
                                return false;
                              }
                            }
                          }

                          if (imgArr.length <= 0) {
                            KlAlert.showAlert(
                              content: '至少上传一张收车凭证',
                              sureFunc: () {
                                MyRoute.router.pop(context);
                              },
                            );
                            return false;
                          }

                          //处理图片
                          List img = [];
                          for (int i = 0; i < imgArr.length; i++) {
                            String imgStr = imgArr[i];
                            String newImgStr = CommonUtil.imgDeal(
                                imgStr: imgStr, type: Config.receive);
                            img.add(newImgStr);
                          }
                          KlAlert.showAlert(
                            content: '已确认图片并提交？',
                            sureFunc: () {
                              _sub = false;
                              if (widget.id > 0) {
                                Loading.show();
                                Http.getInstance()
                                    .purchaseUploadReceive(
                                        rid: widget.id,
                                        count: int.parse(_numController.text),
                                        pid: widget.pid,
                                        url: img.join(','))
                                    .then((value) {
                                  showToast('提交成功');
                                  MyRoute.router.pop(context);
                                  MyRoute.router.pop(context, true);
                                }).whenComplete(() {
                                  Loading.dismiss();
                                  _sub = true;
                                });
                              } else {
                                Loading.show();
                                Http.getInstance()
                                    .purchaseUploadReceive(
                                        count: int.parse(_numController.text),
                                        pid: widget.pid,
                                        url: img.join(','))
                                    .then((value) {
                                      Loading.toast(msg: "提交成功",maskType: EasyLoadingMaskType.clear);
                                      Future.delayed(Duration(seconds: 2)).then((value){
                                        if(mounted){
                                          MyRoute.router.pop(context);
                                          MyRoute.router.pop(context, true);
                                        }
                                      });
                                }).whenComplete(() {
                                  Loading.dismiss();
                                  _sub = true;
                                });
                              }
                            },
                            cancelFunc: () {
                              MyRoute.router.pop(context);
                            },
                          );
                        },
                  color: _sub == false
                      ? ColorConfig.themeColor[100]
                      : ColorConfig.themeColor,
                  circular: 48.w,
                  width: 484.w,
                  height: 96.w,
                  con: '提交')
            ],
          ),
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
            padding: EdgeInsets.all(30.w),
            decoration: comBoxDecoration(),
            child: Column(
              children: [
                conContainer('应收车辆', '${widget.should}台'),
                conContainer('已收车辆', '${widget.all}台'),
                conContainer('未收车辆', '${widget.can}台'),
              ],
            ),
          ),
          Container(
            width: 690.w,
            margin: EdgeInsets.only(top: 30.w),
            padding: EdgeInsets.all(30.w),
            decoration: comBoxDecoration(),
            child: Column(
              children: [
                //数量
                Container(
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
                        child: Text(
                          '数量',
                          style: TextStyle(
                            color: ColorConfig.fontColorBlack,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        width: 400.w,
                        height: 90.w,
                        alignment: Alignment.centerRight,
                        child: TextField(
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text:
                                  '${_numController.text == null ? "" : _numController.text}', //判断keyword是否为空
                              // 保持光标在最后
                              selection: TextSelection.fromPosition(
                                TextPosition(
                                    affinity: TextAffinity.downstream,
                                    offset: '${_numController.text}'.length),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            _numController.text = value;
                          },
                          textAlign: TextAlign.right,
                          scrollPadding: EdgeInsets.zero,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.phone,
                          onSubmitted: (value) {
                            if (value.length > 0) {
                              int num = int.parse(value.toString());
                              if (widget.id > 0) {
                                if (num >
                                    (widget.can +
                                        int.parse(
                                            _purchaseReceiveEntity.sum))) {
                                  _numController.text =
                                      (int.parse(_purchaseReceiveEntity.sum) +
                                              widget.can)
                                          .toString();
                                }
                              } else {
                                if (num > widget.can) {
                                  _numController.text = widget.can.toString();
                                }
                              }
                            }
                          },
                          decoration: InputDecoration(
                            hintText: '不能超过未收车数量',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 15.w),
                            hintStyle: TextStyle(
                              fontSize: 28.sp,
                            ),
                            labelStyle: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorConfig.fontColorBlack,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Wrap(
                  spacing: 20.w,
                  children: [
                    //图片
                    for (int i = 0; i < imgArr.length; i++)
                      uploadImgTouch2(img: imgArr[i],width: 300.w,height: 200.w, uploadInfo: null, showReload: false, function: (){
                        Navigator.push(
                          context,
                          GradualChangeRoute(
                            PhotoPreview(
                              galleryItems: imgArr,
                              defaultImage: i,
                            ),
                          ),
                        );
                      },deleteFunc: (){
                        setState(() {
                          imgArr.removeAt(i);
                        });
                      }),
                    Offstage(
                      offstage:
                          widget.id > 0 && _purchaseReceiveEntity.status == '2'
                              ? true
                              : false,
                      child: containerUploadImg(
                        width: imgArr.length == 0 ? null : 300.w,
                        height: imgArr.length == 0 ? null : 200.w,
                        fontSize: 24.sp,
                        margin: EdgeInsets.only(top: 20.w),
                        img: null,
                        uploadInfo: '上传收车单',
                        showReload: false,
                        function: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          ImgUpload.upload(func: (value) {
                            Loading.show();
                            Http.getInstance()
                                .imgUpload(value, Config.receive)
                                .then((imgRes) {
                              setState(() {
                                imgArr.add(imgRes.fileUrl);
                              });
                            }).whenComplete(() {
                              Loading.dismiss();
                            });
                          });
                        },
                      ),
                    ),
                  ],
                ),
                //打回说明
                Offstage(
                  offstage: _purchaseReceiveEntity.status == '4' &&
                          _purchaseReceiveEntity.remark.length > 0
                      ? false
                      : true,
                  child: Container(
                    width: 502.w,
                    child: Text(
                      '${_purchaseReceiveEntity?.remark}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 28.sp,
                        color: ColorConfig.themeColor[100],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container conContainer(String title, String wid) {
    TextStyle style = TextStyle(
      color: ColorConfig.fontColorBlack,
      fontSize: 24.sp,
      fontWeight: FontWeight.w500,
    );
    return Container(
      width: double.infinity,
      height: 60.w,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.w,
            color: ColorConfig.themeColor[100],
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 150.w,
            alignment: Alignment.centerLeft,
            child: Text(
              '$title',
              style: style,
            ),
          ),
          Container(
            width: 440.w,
            alignment: Alignment.centerRight,
            child: Text(
              wid,
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}
