import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tob/entity/purchase/purchase_receive_list_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/image_show.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';

class ReceivedCarPage extends StatefulWidget {
  final int pid;

  ReceivedCarPage({@required this.pid});

  @override
  _ReceivedCarPageState createState() => _ReceivedCarPageState();
}

class _ReceivedCarPageState extends State<ReceivedCarPage> {
  int _page = 1;
  int _limit = 5;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  PurchaseReceiveListEntity _purchaseReceiveListEntity;
  List<PurchaseReceiveListList> _purchaseReceiveListList = [];

  //加载
  void _onLoading() {
    Http.getInstance()
        .purchaseGetReceiveList(pid: widget.pid, page: _page, limit: _limit)
        .then((value) {
      _purchaseReceiveListEntity = value;
      if (mounted) {
        if (_purchaseReceiveListEntity.xList.length > 0) {
          _page++;
          setState(() {
            _purchaseReceiveListList.addAll(_purchaseReceiveListEntity.xList);
          });
          if (_purchaseReceiveListEntity.xList.length ==
              _purchaseReceiveListEntity.count) {
            _refreshController.loadNoData();
          } else {
            _refreshController.loadComplete();
          }
        } else {
          _refreshController.loadNoData();
        }
      }
    }).catchError((error) {});
  }

  //刷新
  void _onRefresh() {
    _page = 1;
    _refreshController.resetNoData();
    Http.getInstance()
        .purchaseGetReceiveList(pid: widget.pid, page: _page, limit: _limit)
        .then((value) {
      _purchaseReceiveListEntity = value;
      if (mounted) {
        _purchaseReceiveListList.clear();
        if (_purchaseReceiveListEntity.xList.length > 0) {
          _page++;
          _purchaseReceiveListList.addAll(_purchaseReceiveListEntity.xList);
          if (_purchaseReceiveListEntity.xList.length ==
              _purchaseReceiveListEntity.count) {
            _refreshController.loadNoData();
          }
        } else {
          _refreshController.loadNoData();
        }
        setState(() {});
        _refreshController.refreshCompleted();
      }
    }).catchError((error) {
      _refreshController.refreshCompleted();
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbarTitle(title: '确认收车'),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 88.w,
              decoration: BoxDecoration(
                color: ColorConfig.themeColor,
              ),
            ),
          ),
          Positioned(
            top: 32.w,
            left: 30.w,
            right: 30.w,
            child: Container(
              width: 690.w,
              padding: EdgeInsets.only(left: 30.w, right: 30.w, bottom: 10.w),
              decoration: comBoxDecoration(),
              child: Column(
                children: [
                  conContainer('应收车辆',
                      '${_purchaseReceiveListEntity != null ? _purchaseReceiveListEntity.shReceiv : 0}台'),
                  conContainer('已收车辆',
                      '${_purchaseReceiveListEntity != null ? _purchaseReceiveListEntity.alReceiv : 0}台'),
                  conContainer('未收车辆',
                      '${_purchaseReceiveListEntity != null ? _purchaseReceiveListEntity.canReceiv : 0}台'),
                ],
              ),
            ),
          ),
          //列表
          Positioned(
            top: 230.w,
            child: Container(
              width: 750.w,
              height: MediaQuery.of(context).size.height - 230.w - 240.w,
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: purchaseReceiveListData(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _purchaseReceiveListEntity != null &&
              _purchaseReceiveListEntity.canReceiv > 0
          ? SafeArea(
              bottom: true,
              top: false,
              minimum: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //提交
                  eleButton(
                      func: () {
                        MyRoute.router
                            .navigateTo(
                                context,
                                Routes.receivedEdit +
                                    "?pid=${widget.pid}&id=0&all=${_purchaseReceiveListEntity.alReceiv}&should=${_purchaseReceiveListEntity.shReceiv}&can=${_purchaseReceiveListEntity.canReceiv}")
                            .then((value) {
                          if (value != null && value == true) {
                            _refreshController.requestRefresh();
                          }
                        });
                      },
                      color: ColorConfig.themeColor,
                      circular: 16.w,
                      width: 300.w,
                      height: 70.w,
                      con: '上传收车单'),
                ],
              ),
            )
          : Text(''),
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

  purchaseReceiveListData() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _purchaseReceiveListList.length,
      itemBuilder: (BuildContext context, int index) {
        //处理图片数据，只要前面3张
        String img = _purchaseReceiveListList[index].images;
        List imgArr = img.split(',');
        // if (imgArr.length > 3) {
        //   imgArr.removeRange(2, imgArr.length - 1);
        // }
        return Container(
          width: 690.w,
          margin: EdgeInsets.only(top: 30.w, right: 30.w, left: 30.w),
          padding: EdgeInsets.all(30.w),
          decoration: comBoxDecoration(),
          child: Column(
            children: [
              //时间-状态
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_purchaseReceiveListList[index].createtime}'),
                  statusText(
                    int.parse(_purchaseReceiveListList[index].status),
                  ),
                ],
              ),
              //数量-按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('数量：${_purchaseReceiveListList[index].sum}'),
                  Offstage(
                    offstage: _purchaseReceiveListList[index].status != '2'
                        ? false
                        : true,
                    child: Row(
                      children: [
                        eleButton(
                            func: () {
                              MyRoute.router
                                  .navigateTo(
                                      context,
                                      Routes.receivedEdit +
                                          "?pid=${widget.pid}&id=${_purchaseReceiveListList[index].id}&all=${_purchaseReceiveListEntity.alReceiv}&should=${_purchaseReceiveListEntity.shReceiv}&can=${_purchaseReceiveListEntity.canReceiv}&num=${_purchaseReceiveListList[index].sum}")
                                  .then((value) {
                                if (value != null && value == true) {
                                  _refreshController.requestRefresh();
                                }
                              });
                            },
                            color: ColorConfig.themeColor,
                            circular: 10.w,
                            width: 100.w,
                            height: 50.w,
                            size: 24.sp,
                            con: _purchaseReceiveListList[index].status == '4'
                                ? '重新上传'
                                : '编辑'),
                        SizedBox(width: 20.w),
                        eleButton(
                            func: () {
                              KlAlert.showAlert(
                                  content: '是否删除?删除后不可恢复?',
                                  sureFunc: () {
                                    Loading.show();
                                    Http.getInstance()
                                        .purchaseDeleteReceive(
                                            rid: _purchaseReceiveListList[index]
                                                .id)
                                        .then((value) {
                                      showToast('删除成功');
                                      // _purchaseReceiveListList.removeAt(index);
                                      _refreshController.requestRefresh();
                                      setState(() {});
                                      MyRoute.router.pop(context);
                                    }).whenComplete(() {
                                      Loading.dismiss();
                                    });
                                  },
                                  cancelFunc: () {
                                    MyRoute.router.pop(context);
                                  });
                            },
                            color: Colors.grey[300],
                            circular: 10.w,
                            width: 100.w,
                            height: 50.w,
                            size: 24.sp,
                            con: '删除'),
                      ],
                    ),
                  ),
                ],
              ),
              //图片
              SizedBox(height: 20.w),
              Container(
                width: double.infinity,
                child: Wrap(
                  spacing: 9.w,
                  runSpacing: 9.w,
                  alignment: WrapAlignment.start,
                  children: [
                    for (int i = 0; i < imgArr.length; i++)
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            GradualChangeRoute(
                              PhotoPreview(
                                galleryItems: imgArr,
                                defaultImage: i,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          child:
                          ExtendedImage.network(
                            '${imgArr[i]}',
                            width: 150.w,
                            height: 150.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20.w),
              Text('点击图片可查看大图',style: TextStyle(
                fontSize: 20.sp,
                color: ColorConfig.themeColor
              ),),
            ],
          ),
        );
      },
    );
  }

  statusText(int status) {
    // 收车单凭证状态:,1=已上传,2=已确认,3=已删除,4=已打回
    Color color = ColorConfig.errColor;
    String text = "等待审批";
    switch (status) {
      case 1:
        text = "等待审批";
        color = ColorConfig.themeColor[300];
        break;
      case 2:
        text = "审核通过";
        color = ColorConfig.sureColor;
        break;
      case 4:
        text = "审核未通过";
        color = ColorConfig.errColor;
        break;
    }
    return Text(
      '$text',
      style: TextStyle(
        fontSize: 24.sp,
        color: color,
      ),
    );
  }
}
