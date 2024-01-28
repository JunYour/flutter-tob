import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tob/bloc/purchase/list/purchase_list_bloc.dart';
import 'package:tob/bloc/purchase/purchase/purchase_detail_bloc.dart';
import 'package:tob/entity/bank_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/config.dart';
import 'package:tob/global/order.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/util/common_util.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/image_show.dart';
import 'package:tob/widget/image_upload.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';

class PayInfoPage extends StatefulWidget {
  ///采购单id
  final int pid;

  ///图片
  final String image;

  ///类型-修改还是查看
  final String type;

  ///审核失败的内容
  final String error;

  PayInfoPage(
      {@required this.pid, this.image, @required this.type, this.error});

  @override
  _PayInfoPageState createState() => _PayInfoPageState();
}

class _PayInfoPageState extends State<PayInfoPage> {
  String _img;
  List _imgList = [];
  BankEntity _bankEntity = new BankEntity();

  @override
  void initState() {
    if (widget.image != null) {
      _img = Uri.decodeComponent(widget.image);
      _imgList = _img.split(',');
    }
    _bankEntity = Order.getBank();
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    Loading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbarTitle(title: '付款信息'),
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
              Offstage(
                offstage: widget.type == "sel" ? true : false,
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
                        _imgList[i] = CommonUtil.imgDeal(
                            imgStr: _imgList[i], type: Config.vouch);
                      }

                      KlAlert.showAlert(
                        content: '确认支付凭证无误并上传？',
                        sureFunc: () {
                          Loading.show();
                          String img = _imgList.join(',');
                          Http.getInstance()
                              .purchaseUpload(pid: widget.pid, url: img)
                              .then((value) {
                            MyRoute.router.pop(context); //关闭弹窗
                            MyRoute.router.pop(context, true); //回到采购单列表
                            BlocProvider.of<PurchaseListBloc>(context)
                                .add(PurchaseListRefreshEvent(true));
                            BlocProvider.of<PurchaseDetailBloc>(context)
                                .add(PurchaseDetailInitEvent(id: widget.pid));
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
              SizedBox(height: 100.w),
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
            width: 688.w,
            padding: EdgeInsets.all(30.w),
            decoration: comBoxDecoration(),
            child: Column(
              children: [
                Text(
                  '长按可复制以下内容',
                  style:
                      TextStyle(fontSize: 20.sp, color: ColorConfig.themeColor),
                ),
                conContainer('收款名称', '${_bankEntity?.receiveName}'),
                conContainer('收款账号', '${_bankEntity?.bankNum}'),
                conContainer('开户行', '${_bankEntity?.bankName}'),
                SizedBox(height: 20.w),
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
                            img: _imgList[i],
                            width: 300.w,
                            height: 200.w,
                            uploadInfo: null,
                            showReload: false,
                            function: () {
                              Navigator.push(
                                context,
                                GradualChangeRoute(
                                  PhotoPreview(
                                    galleryItems: _imgList,
                                    defaultImage: i,
                                  ),
                                ),
                              );
                            },
                            deleteFunc: widget.type == "upd"
                                ? () {
                                    setState(
                                      () {
                                        _imgList.removeAt(i);
                                      },
                                    );
                                  }
                                : null),
                      Offstage(
                        offstage: widget.type == "sel" ? true : false,
                        child: containerUploadImg(
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
            ),
          ),
        ],
      ),
    );
  }

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
                    '收款名称:  ${_bankEntity?.receiveName}\n收款账户:  ${_bankEntity?.bankNum}\n开户行:     ${_bankEntity?.bankName}'))
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
            Container(
              width: 400.w,
              alignment: Alignment.centerRight,
              child: Text(
                wid,
                style: style,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
