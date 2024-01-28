import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tob/entity/bank/bank_account_entity.dart';
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

class TabPurchasePayInfoPage extends StatefulWidget {
  ///采购订单id
  final int pid;

  ///图片
  final String image;

  ///类型-修改还是查看
  final String type;

  ///审核失败的内容
  final String error;

  TabPurchasePayInfoPage(
      {@required this.pid, this.image, @required this.type, this.error});

  @override
  _PayInfoPageState createState() => _PayInfoPageState();
}

class _PayInfoPageState extends State<TabPurchasePayInfoPage> {
  String _img;
  List _imgList = [];
  BankAccountEntity _bankAccountEntity;

  @override
  void initState() {
    if (widget.image != null && widget.image.length > 0) {
      _img = Uri.decodeComponent(widget.image);
      _imgList = _img.split(',');
    }
    getPayInfo();
    setState(() {});
    super.initState();
  }

  //获取付款信息
  getPayInfo() {
    Loading.show(status: "获取付款信息");
    Http.getInstance().carGetPayInfo(id: widget.pid).then((value) {
      _bankAccountEntity = value;
      setState(() {});
    }).whenComplete(() => Loading.dismiss());
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
        title: Text("付款信息"),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //收款信息
              info(),
              //提交
              sub(context),
              SizedBox(height: 100.w),
            ],
          ),
        ),
      ),
    );
  }

  //提交
  Offstage sub(BuildContext context) {
    return Offstage(
      offstage: widget.type == "sel" ? true : false,
      child: Container(
        margin: EdgeInsets.only(top: 30.w),
        child: eleButton(
            func: () {
              if (_imgList == null || _imgList.length == 0) {
                KlAlert.showAlert(
                    content: '请上传付款凭证',
                    sureFunc: () {
                      MyRoute.router.pop(context);
                    });
                return false;
              }

              for (int i = 0; i < _imgList.length; i++) {
                _imgList[i] =
                    CommonUtil.imgDeal(imgStr: _imgList[i], type: Config.vouch);
              }
              KlAlert.showAlert(
                content: '确认支付凭证无误并上传？',
                sureFunc: () {
                  Loading.show();
                  String img = _imgList.join(',');
                  Http.getInstance()
                      .uploadVouch(oid: widget.pid, url: img)
                      .then((value) {
                    MyRoute.router.pop(context); //关闭弹窗
                    Loading.toast(msg: "上传成功",maskType: EasyLoadingMaskType.clear);
                    Future.delayed(Duration(seconds: 2)).then((value) {
                      if(mounted){
                        MyRoute.router.pop(context, {"status": 1}); //关闭页面
                      }
                    });
                  }).whenComplete(() {
                  Loading.dismiss();
                  });
                },
                cancelFunc: () {
                  MyRoute.router.pop(context);
                },
              );
            },
            color: ColorConfig.themeColor,
            circular: 48.w,
            width: 484.w,
            height: 96.w,
            con: '提交'),
      ),
    );
  }

  //收款信息
  info() {
    conContainer(String title, String wid) {
      TextStyle style = TextStyle(
        color: ColorConfig.fontColorBlack,
        fontSize: 32.sp,
        fontWeight: FontWeight.w500,
      );
      return GestureDetector(
        onLongPress: () {
          Clipboard.setData(ClipboardData(
                  text:
                      '收款名称:  ${_bankAccountEntity?.name}\n收款账户:  ${_bankAccountEntity?.account}\n开户行:     ${_bankAccountEntity?.bank}'))
              .then((value) {
            showToast('复制成功');
          }).catchError((error) {
            showToast('复制失败！');
          });
        },
        child: Container(
          width: double.infinity,
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
                width: 150.w,
                alignment: Alignment.centerLeft,
                child: Text(
                  '$title',
                  style: style,
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child: Text(
                    wid,
                    style: style,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: 688.w,
          margin: EdgeInsets.only(top: 30.w),
          padding: EdgeInsets.all(30.w),
          decoration: comBoxDecoration(),
          child: Column(
            children: [
              Text(
                '长按可复制以下内容',
                style:
                    TextStyle(fontSize: 20.sp, color: ColorConfig.themeColor),
              ),
              conContainer('收款名称',
                  "${_bankAccountEntity != null ? _bankAccountEntity?.name : ''}"),
              conContainer('收款账号',
                  "${_bankAccountEntity != null ? _bankAccountEntity?.account : ''}"),
              conContainer('开户行',
                  "${_bankAccountEntity != null ? _bankAccountEntity?.bank : ''}"),
              SizedBox(height: 20.w),
              //支付凭证
              vouch(),
            ],
          ),
        ),
      ],
    );
  }

  //支付凭证
  vouch() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          alignment: (widget.type == "sel" && _imgList.length == 1) ||
                  (widget.type == "upd" && _imgList.length == 0)
              ? Alignment.center
              : Alignment.topLeft,
          child: Wrap(
            spacing: 20.w,
            runSpacing: 20.w,
            children: [
              for (int i = 0; i < _imgList.length; i++)
                uploadImgTouch2(
                  width: widget.type == "sel" && _imgList.length == 1
                      ? null
                      : 300.w,
                  height: widget.type == "sel" && _imgList.length == 1
                      ? null
                      : 200.w,
                  img: _imgList[i],
                  fontSize: widget.type == "sel" && _imgList.length == 1
                      ? null
                      : 24.sp,
                  uploadInfo: '上传支付凭证',
                  showReload: widget.type == "upd" ? true : false,
                  function: () {
                    // if (widget.type == "upd") {
                    //   ImgUpload.upload(func: (value) {
                    //     Loading.show();
                    //     Http.getInstance()
                    //         .imgUpload(value, Config.vouch)
                    //         .then((value) {
                    //       setState(() {
                    //         _imgList[i] = value.fileUrl;
                    //       });
                    //     }).whenComplete(() {
                    //       Loading.dismiss();
                    //     });
                    //   });
                    // } else {
                    Navigator.push(
                      context,
                      GradualChangeRoute(
                        PhotoPreview(
                          galleryItems: _imgList,
                          defaultImage: i,
                        ),
                      ),
                    );
                    // }
                  },
                  deleteFunc:widget.type=="upd"? () {
                    KlAlert.showAlert(
                        content: '确认移除该图片？',
                        sureFunc: () {
                          setState(() {
                            _imgList.removeAt(i);
                          });
                          MyRoute.router.pop(context);
                        },
                        cancelFunc: () {
                          MyRoute.router.pop(context);
                        });
                  }:null,
                ),
              Offstage(
                offstage: widget.type == "sel" ? true : false,
                child: uploadImgTouch2(
                  width: widget.type == "upd" && _imgList.length == 0
                      ? null
                      : 300.w,
                  height: widget.type == "upd" && _imgList.length == 0
                      ? null
                      : 200.w,
                  fontSize: 24.sp,
                  img: null,
                  uploadInfo: '上传支付凭证',
                  showReload: false,
                  function: () {
                    if (widget.type == "upd") {
                      ImgUpload.upload(func: (value) {
                        Loading.show();
                        Http.getInstance()
                            .imgUpload(value, Config.vouch)
                            .then((value) {
                          setState(() {
                            _imgList.add(value.fileUrl);
                          });
                        }).whenComplete(() {
                          Loading.dismiss();
                        });
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        //审核不通过提示
        Offstage(
          offstage: widget.error == null ? true : false,
          child: Container(
            margin: EdgeInsets.only(top: 20.w),
            child: Text(
              '${widget.error}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 28.sp,
                color: ColorConfig.errColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
