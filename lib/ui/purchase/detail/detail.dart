import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:tob/channel/zc.dart';
import 'package:tob/entity/tab_purchase/tab_purchase_list_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/entity/user_info_entity.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/load_status.dart';
import 'package:flutter/scheduler.dart';

class PurchaseDetailTabPage extends StatefulWidget {
  final int id;

  PurchaseDetailTabPage({Key key, @required this.id});

  @override
  _PurchaseDetailTabPageState createState() => _PurchaseDetailTabPageState();
}

class _PurchaseDetailTabPageState extends State<PurchaseDetailTabPage> {
  TabPurchaseListList _tabPurchaseListList;
  LoadState _layoutState = LoadState.State_Loading;

  @override
  initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 300)).then((value) {
      if (mounted) {
        getData();
      }
    });
  }

  ///获取数据
  getData() {
    Http.getInstance().tabPurchaseDetail(id: widget.id).then((value) {
      if (mounted) {
        print(value);
        _tabPurchaseListList = value;
        setLoadStatus(LoadState.State_Success);
      }
    }).catchError((error) {
      if (error == 0) {
        setLoadStatus(LoadState.State_No_Network);
      } else {
        setLoadStatus(LoadState.State_Error);
      }
    });
  }

  //设置请求状态
  setLoadStatus(LoadState loadState) {
    _layoutState = loadState;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("车型详情",
            style: TextStyle(color: Colors.black, fontSize: 36.sp)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              ZcChannel.startKf();
            },
            child: Container(
              padding: EdgeInsets.only(left: 30.w, right: 30.w),
              alignment: Alignment.center,
              child: Image.asset("assets/icon-service.png",
                  width: 44.w, height: 44.h),
            ),
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        top: false,
        minimum: EdgeInsets.only(bottom: 30.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (_tabPurchaseListList != null) {
                  navTo(
                      context,
                      Routes.carArgument +
                          "?id=${_tabPurchaseListList?.carId}");
                }
              },
              child: Container(
                  width: 340.w,
                  height: 88.w,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF5EB5F8), Color(0xFFF58A4FF)],
                      ),
                      borderRadius: BorderRadius.circular(80.w)),
                  margin: EdgeInsets.only(right: 10.w),
                  padding: EdgeInsets.only(left: 100.w, top: 18.h),
                  child: Text(
                    "官方配置",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 32.sp,
                        color: Colors.white),
                  )),
            ),
            eleButton(
              width: 340.w,
              height: 88.w,
              con: "发起采购",
              circular: 80.w,
              color: ColorConfig.themeColor,
              func: () {
                toLaunch();
              },
            )
          ],
        ),
      ),
      body: LoadStateLayout(
        state: _layoutState,
        errorRetry: () {
          //错误按钮点击过后进行重新加载
          setState(() {
            _layoutState = LoadState.State_Loading;
          });
          getData();
        },
        successWidget: SingleChildScrollView(
          child: Column(
            children: [
              //顶部图片
              topPic(),
              //  基础信息
              baseInfo(),
              //  销售信息
              saleInfo(),
            ],
          ),
        ),
      ),
    );
  }

  //去采购
  void toLaunch() {
    if (_tabPurchaseListList == null) {
      return;
    }
    UserInfoEntity userInfoEntity = UserInfo.getUserInfo();
    if (userInfoEntity == null) {
      KlAlert.showAlert(
          content: "请先登录！",
          sureFunc: () {
            navTo(context, Routes.loginPhone + "?back=true").then((value) {
              getData();
            });
          },
          cancelFunc: () {
            MyRoute.router.pop(context);
          });
    }

    if (userInfoEntity.dealerId > 0 &&
        userInfoEntity.dealer.status == '2' &&
        userInfoEntity.auth == 2) {
      navTo(
        context,
        "${Routes.tabPurchaseLaunch}?oid=" +
            _tabPurchaseListList?.id.toString(),
      );
    } else {
      if (userInfoEntity.auth < 2) {
        KlAlert.showAlert(
            content: "请先完成实名认证！",
            sureFunc: () {
              navTo(context, Routes.verifyIndex);
            },
            cancelFunc: () {
              MyRoute.router.pop(context);
            });
      } else {
        KlAlert.showAlert(
            content: "请先完成企业认证！",
            sureFunc: () {
              navTo(context, Routes.verifyIndex);
            },
            cancelFunc: () {
              MyRoute.router.pop(context);
            });
      }
    }
  }

  //顶部图片
  topPic() {
    List list = _tabPurchaseListList?.images.toString().split(",");
    print(list);
    return Container(
      width: double.infinity,
      height: 332.w,
      child: list.length > 0
          ? Swiper(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    previewImages(list, index);
                  },
                  child: showImageNetwork(img: list[index]),
                );
              },
              autoplay: true,
              itemCount: list.length,
              scrollDirection: Axis.horizontal,
              pagination:
                  new SwiperPagination(alignment: Alignment.bottomCenter),
            )
          : Text(""),
    );
  }

  //基础信息
  baseInfo() {
    titleCount() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "${_tabPurchaseListList?.brandName.toString() + ' ' + _tabPurchaseListList?.seriesName.toString() + ' ' + _tabPurchaseListList?.carName.toString()}",
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xff333333),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Container(
          //     alignment: Alignment.bottomRight,
          //     child: Text(
          //       "指导价：${_tabPurchaseListList?.cars?.pChangshangzhidaojiaYuan}",
          //       style: TextStyle(
          //         fontSize: 24.sp,
          //         fontWeight: FontWeight.bold,
          //         height: 2,
          //         color: Color(0xff999999),
          //       ),
          //     ),
          //   ),
          // )
        ],
      );
    }

    priceContainer({String price, String con}) {
      return Container(
        width: 230.w,
        margin: EdgeInsets.only(top: 31.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   "¥",
                //   style: TextStyle(
                //       fontSize: 20.sp,
                //       fontWeight: FontWeight.bold,
                //       color: Color(0xffEE1313),
                //       height: 1),
                // ),
                Text(
                  "$price",
                  style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xffEE1313),
                      height: 0.7),
                ),
                Text(
                  "起",
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffEE1313),
                      height: 1),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "$con",
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Color(0xff808080),
                ),
              ),
            ),
          ],
        ),
      );
    }

    pri() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          priceContainer(
              price: "${_tabPurchaseListList?.cars?.pChangshangzhidaojiaYuan}",
              con: "指导价"),
          priceContainer(
              price: "${_tabPurchaseListList?.normalPrice}万", con: "采购价"),
          priceContainer(
              price: "${_tabPurchaseListList?.primePrice}万", con: "会员采购价"),
        ],
      );
    }

    tagsContainer(
        {String text, bool left = true, bool right = true, bool line = true}) {
      double leftSize = 12.w;
      double rightSize = 12.w;
      if (left == false) {
        leftSize = 0;
      }
      if (right == false) {
        rightSize = 0;
      }
      return Container(
        padding: EdgeInsets.only(left: leftSize, right: rightSize),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              width: 1.w,
              color: line ? Color(0xff999999) : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          "$text",
          style: TextStyle(
            fontSize: 20.sp,
            height: 1,
            fontWeight: FontWeight.bold,
            color: Color(0xff999999),
          ),
        ),
      );
    }

    ///标签
    tags() {
      List list =
          _tabPurchaseListList != null ? _tabPurchaseListList?.listLabels : [];
      return Container(
        margin: EdgeInsets.only(top: 26.w),
        width: double.infinity,
        child: Wrap(
          runSpacing: 10.w,
          children: [
            for (int i = 0; i < list.length; i++)
              tagsContainer(
                  text: "${list[i]}",
                  left: i == 0 ? false : true,
                  right: i == (list.length - 1) ? false : true,
                  line: i == (list.length - 1) ? false : true),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 40.w),
      padding: EdgeInsets.only(left: 30.w, right: 30.w),
      child: Column(
        children: [
          //名称+库存
          titleCount(),
          //  标签
          tags(),
          //  价格
          pri()
        ],
      ),
    );
  }

  saleInfo() {
    conContainer(
        {@required String title,
        @required String content,
        Widget widget,
        bool remark = false}) {
      if (remark == true) {
        return Container(
          margin: EdgeInsets.only(top: 12.w, left: 30.sp, right: 30.sp),
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // width: 140.w,
                child: Text(
                  "$title",
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: Color(0xff808080),
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (content.length > 0)
                Container(
                  // width: 520.w,
                  child: Text(
                    "$content",
                    style: TextStyle(
                      fontSize: 32.sp,
                      color: Color(0xff383838),
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      } else {
        return Container(
          padding: EdgeInsets.only(left: 33.w, right: 28.w),
          margin: EdgeInsets.only(top: 12.w),
          // width: double.infinity,
          height: 60.w,
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // width: 120.w,
                      child: Text(
                        "$title",
                        style: TextStyle(
                          fontSize: 28.sp,
                          color: Color(0xff808080),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "$content",
                        style: TextStyle(
                          fontSize: 32.sp,
                          color: Color(0xff383838),
                          // fontWeight: FontWeight.bold,
                        ),
                        maxLines: widget != null ? 1 : null,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              widget != null ? widget : Text(""),
            ],
          ),
        );
      }
    }

    //颜色处理
    List colors = [];
    if (_tabPurchaseListList != null) {
      _tabPurchaseListList.colors.forEach((element) {
        colors.add(element.name);
      });
    }
    return Column(
      children: [
        SizedBox(height: 12.w),
        conContainer(
            title: "库存数量:", content: "${_tabPurchaseListList?.total}台"),
        conContainer(
            title: "销售区域:",
            content: "${_tabPurchaseListList?.salecityName}",
            remark: true),
        conContainer(
            title: "车源所在地:",
            content: "${_tabPurchaseListList?.carcityName}",
            remark: true),
        conContainer(
            title: "颜色:",
            content: " ",
            widget: GestureDetector(
              onTap: () {
                toLaunch();
              },
              child: Container(
                  child: Row(children: [
                Text(
                  "${_tabPurchaseListList != null ? _tabPurchaseListList.colors.length : 0}种颜色可选",
                  style: TextStyle(
                    fontSize: 32.sp,
                    color: Color(0xff333333),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xff333333),
                      size: 16,
                    )),
                // Icon(
                //   Icons.arrow_forward_ios,
                //   color: Color(0xff333333),
                //   size: 16,
                // )
              ])
                  // child: Text(
                  //   "${_tabPurchaseListList != null ? _tabPurchaseListList.colors.length : 0}种颜色可选 >",
                  //   style: TextStyle(
                  //     fontSize: 32.sp,
                  //     color: Color(0xff333333),
                  //   ),
                  // ),
                  ),
            )),
        conContainer(
            title: "起采数量:", content: "${_tabPurchaseListList?.buycount}台"),
        conContainer(
            title: "备注说明:",
            remark: true,
            content: "${_tabPurchaseListList?.remark}"),
      ],
    );
  }
}
