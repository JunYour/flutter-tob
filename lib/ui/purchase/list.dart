import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tob/bloc/tab/switch_tag_bloc.dart';
import 'package:tob/bloc/tab/switch_tag_event.dart';
import 'package:tob/bloc/tab/switch_tag_state.dart';
import 'package:tob/entity/tab_purchase/tab_purchase_list_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/car_picker/brand.dart';
import 'package:tob/widget/common_widget.dart';

class PurchaseListTabPage extends StatefulWidget {
  const PurchaseListTabPage({Key key}) : super(key: key);

  @override
  _PurchaseListTabPageState createState() => _PurchaseListTabPageState();
}

class _PurchaseListTabPageState extends State<PurchaseListTabPage>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  TextEditingController _searchController = new TextEditingController();
  int _page = 1;
  int _limit = 10;
  TabPurchaseListEntity _tabPurchaseListEntity;
  List<TabPurchaseListList> _tabPurchaseListList = [];
  int saleAreaId = 0;
  String saleAreaName = "销售区域";
  bool orderShow = false; //默认排序选择是否显示
  List orderList = [
    {"name": "默认排序", "chose": true, "id": 0},
    {"name": "不包物流", "chose": false, "id": 1},
    {"name": "承包物流", "chose": false, "id": 2},
    {"name": "价格从低到高", "chose": false, "id": 3},
    {"name": "价格从高到低", "chose": false, "id": 4},
  ];
  String orderText = "默认排序";
  String specText = "车型品牌";
  int brandId = 0;
  int seriesId = 0;
  int specId = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _searchController.dispose();
  }

  //加载
  void _onLoading() {
    int orderId = 0;
    orderList.asMap().forEach((key, value) {
      if (value["chose"] == true) {
        orderId = value["id"];
      }
    });

    Http.getInstance()
        .tabPurchaseList(
      page: _page,
      limit: _limit,
      carName: _searchController.text,
      defaultOrder: orderId,
      saleArea: saleAreaId,
      brandId: brandId,
      seriesId: seriesId,
      specId: specId,
    )
        .then((value) {
      _tabPurchaseListEntity = value;
      if (mounted) {
        if (_tabPurchaseListEntity.xList.length > 0) {
          _page++;
          setState(() {
            _tabPurchaseListList.addAll(_tabPurchaseListEntity.xList);
          });
          if (_tabPurchaseListEntity.xList.length ==
              _tabPurchaseListEntity.count) {
            _refreshController.loadNoData();
          } else {
            _refreshController.loadComplete();
          }
        } else {
          _refreshController.loadNoData();
        }
      }
    }).catchError((error) {});
    _refreshController.loadComplete();
    _refreshController.loadNoData();
  }

  //刷新
  void _onRefresh() {
    _page = 1;
    _tabPurchaseListList = [];
    setState(() {});
    int orderId = 0;
    orderList.asMap().forEach((key, value) {
      if (value["chose"] == true) {
        orderId = value["id"];
      }
    });

    _refreshController.resetNoData();
    Http.getInstance()
        .tabPurchaseList(
      page: _page,
      limit: _limit,
      carName: _searchController.text,
      defaultOrder: orderId,
      saleArea: saleAreaId,
      brandId: brandId,
      seriesId: seriesId,
      specId: specId,
    )
        .then((value) {
      _tabPurchaseListEntity = value;
      if (mounted) {
        _tabPurchaseListList.clear();
        if (_tabPurchaseListEntity.xList.length > 0) {
          _page++;
          _tabPurchaseListList.addAll(_tabPurchaseListEntity.xList);
          if (_tabPurchaseListEntity.xList.length ==
              _tabPurchaseListEntity.count) {
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

  void onSub() {
    //父组件创建完成的回调通知方法
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
      BlocProvider.of<SwitchTagBloc>(context).add(JustSwitchTagEvent(1,
          content: _searchController.text, reFresh: false));
      _tabPurchaseListList.clear();
      _refreshController.requestRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: () {
        closeBoard(context: context);
      },
      child: Scaffold(
        backgroundColor: ColorConfig.bgColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Container(
            height: 68.h,
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE3F4FD), Color(0xFFF6E6E5)],
                ),
                borderRadius: BorderRadius.circular(64.w)),
            child: Row(
              children: [
                Image.asset("assets/icon-search.png",
                    width: 40.w, height: 40.h),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8.w),
                    padding: EdgeInsets.only(right: 30.w),
                    child: BlocBuilder<SwitchTagBloc, SwitchTagState>(
                      builder: (context, state) {
                        if (state is JustSwitchTagState) {
                          if (state.index == 1) {
                            if (state.reFresh == true) {
                              _searchController.text = state.content;
                              onSub();
                            }
                          }
                        }
                        return TextFormField(
                          controller: _searchController,
                          textInputAction: TextInputAction.search,
                          style:
                              TextStyle(color: Colors.white, fontSize: 26.sp),
                          onFieldSubmitted: (value) {
                            brandId = null;
                            seriesId = null;
                            specId = null;
                            specText = "全部";
                            BlocProvider.of<SwitchTagBloc>(context).add(
                                JustSwitchTagEvent(1,
                                    content: value, reFresh: true));
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 25.w),
                              counterText: "",
                              hintText: "请输入车型",
                              hintStyle: TextStyle(
                                  fontSize: 26.sp, color: Color(0xFF808080)),
                              border: InputBorder.none),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
        body: GestureDetector(
          onTap: () {
            closeBoard(context: context);
          },
          child: Column(
            children: [
              //排序方式
              order(),
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      child: Column(
                        children: [
                          SizedBox(height: 20.w),
                          //数据列表
                          Expanded(
                            child: SmartRefresher(
                              enablePullDown: true,
                              enablePullUp: true,
                              controller: _refreshController,
                              onRefresh: _onRefresh,
                              onLoading: _onLoading,
                              child: listData(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //默认排序选择
                    orderDefault(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //数据列表
  listData() {
    //标题
    title(TabPurchaseListList _tabPurchaseListList) {
      double width = 385.w;
      return Row(children: [
        ///图片
        Container(
          margin: EdgeInsets.only(right: 15.w),
          width: 300.w,
          height: 180.h,
          child: showImageNetwork(img: _tabPurchaseListList.indexImage),
        ),

        ///价格
        Container(
            child: Column(children: [
          ///名称
          Container(
            height: 80.h,
            width: width,
            child: Text(
              "${_tabPurchaseListList.brandName + " " + _tabPurchaseListList.seriesName + " " + _tabPurchaseListList.carName}",
              style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff333333),
                  height: 1.2),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 8.h),
            width: width,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "会员采购价:",
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Color(0xff808080),
                    ),
                  ),
                  Text(
                    "${_tabPurchaseListList.primePrice}万起",
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: Color(0xffFA6E48),
                    ),
                  )
                ]),
          ),

          Container(
            width: width,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "采购价：",
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Color(0xff808080),
                    ),
                  ),
                  Text(
                    "${_tabPurchaseListList.normalPrice}万起",
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: Color(0xffFA6E48),
                    ),
                  )
                ]),
          ),
          if (_tabPurchaseListList.listLabels.length > 0)
            Container(
              width: width,
              margin: EdgeInsets.only(top: 20.w),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 20.w,
                runSpacing: 10.w,
                children: [
                  for (int i = 0;
                      i < _tabPurchaseListList.listLabels.length;
                      i++)
                    tags("${_tabPurchaseListList.listLabels[i]}"),
                ],
              ),
            )
        ]))
      ]);
    }

    ///备注
    // remark(String remark) {
    //   return Column(
    //     children: [
    //       Container(
    //         margin: EdgeInsets.only(top: 10.w),
    //         child: Opacity(
    //           opacity: 0.1,
    //           child: Divider(
    //             height: 2.w,
    //             color: Colors.black,
    //           ),
    //         ),
    //       ),
    //       Container(
    //         margin: EdgeInsets.only(top: 14.w, bottom: 10.w),
    //         width: double.infinity,
    //         child: RichText(
    //           maxLines: 2,
    //           overflow: TextOverflow.ellipsis,
    //           text: TextSpan(
    //             children: [
    //               TextSpan(
    //                   text: "备注：",
    //                   style: TextStyle(
    //                       fontSize: 20.sp, color: ColorConfig.themeColor[400])),
    //               TextSpan(
    //                 text: "$remark",
    //                 style: TextStyle(
    //                   fontSize: 20.sp,
    //                   color: Color(0xff999999),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   );
    // }

    return ListView.builder(
      itemCount: _tabPurchaseListList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            navTo(
                context,
                Routes.tabPurchaseTabDetail +
                    "?id=${_tabPurchaseListList[index].id.toString()}");
            closeBoard(context: context);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 20.w),
            padding: EdgeInsets.only(
                left: 24.w, right: 24.w, top: 16.w, bottom: 16.w),
            color: Colors.white,
            child: Column(
              children: [
                //  图片+名称+价格+库存
                title(_tabPurchaseListList[index]),

                ///采购价和会员采购价
                // buyPrice(_tabPurchaseListList[index]),
                //  标签
                // Offstage(
                //   offstage: _tabPurchaseListList[index].listLabels.length > 0
                //       ? false
                //       : true,
                //   child: tagsList(_tabPurchaseListList[index]),
                // ),

                // ///  备注
                // Offstage(
                //   offstage: _tabPurchaseListList[index].remark.length > 0
                //       ? false
                //       : true,
                //   child: remark(_tabPurchaseListList[index].remark),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///标签
  tags(String text) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8AA5FF), Color(0xFFF2F5EFB)],
          ),
          borderRadius: BorderRadius.circular(8.w)),
      padding: EdgeInsets.only(left: 8.w, top: 3.w, bottom: 3.w, right: 8.w),
      child: Text(
        "$text",
        style: TextStyle(fontSize: 20.sp, color: Colors.white),
      ),
    );
  }

  ///标签列表
  tagsList(TabPurchaseListList tabPurchaseListList) {
    List list = tabPurchaseListList.listLabels;
    return Container(
      margin: EdgeInsets.only(top: 30.w),
      // width: double.infinity,
      decoration:
          BoxDecoration(border: new Border.all(width: 1, color: Colors.red)),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 20.w,
        runSpacing: 10.w,
        children: [
          for (int i = 0; i < list.length; i++) tags("${list[i]}"),
        ],
      ),
    );
  }

  //排序
  order() {
    return Container(
      color: Colors.white,
      height: 74.w,
      // padding: EdgeInsets.only(left: 30.w, right: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              closeBoard(context: context);
              orderShow = !orderShow;
              setState(() {});
            },
            child: Container(
              width: 220.w,
              child: Row(
                children: [
                  Expanded(
                      child: Text("$orderText",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          // 文本样式
                          style: TextStyle(
                            color: Color(0xff808080),
                            fontSize: 28.sp,
                          ))),
                  Icon(Icons.arrow_drop_down, color: Color(0xff808080))
                ],
              ),
            ),
          ),
          //省份
          GestureDetector(
            onTap: () {
              closeBoard(context: context);
              orderShow = false;

              navTo(context, Routes.saleArea).then((value) {
                if (value != null) {
                  if (saleAreaId == value['provinceId']) {
                    return false;
                  }
                  saleAreaName = value["provinceName"];
                  saleAreaId = value['provinceId'];
                  setState(() {});
                  _tabPurchaseListList.clear();
                  _refreshController.requestRefresh();
                } else {
                  if (saleAreaId == 0) {
                    return false;
                  }
                  saleAreaName = "销售区域";
                  saleAreaId = 0;
                  setState(() {});
                  _tabPurchaseListList.clear();
                  _refreshController.requestRefresh();
                }
              });
            },
            child: Container(
              width: 220.w,
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: Text("$saleAreaName",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff808080), fontSize: 28.sp)),
                  ),
                  Icon(Icons.arrow_drop_down, color: Color(0xff808080))
                ],
              ),
            ),
          ),
          //车型选择
          gestureDetector(),
        ],
      ),
    );
  }

  //车型选择
  GestureDetector gestureDetector() {
    return GestureDetector(
      onTap: () {
        closeBoard(context: context);
        orderShow = false;
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => Brand(),
            settings: RouteSettings(arguments: {"type": 0}),
          ),
        ).then((value) {
          print(value);
          if (value != null) {
            //只有品牌
            if (value["type"] == "brand") {
              if (brandId == value["brandId"] && specText == value['brand']) {
                return false;
              } else {
                specText = value["brand"];
                brandId = value["brandId"];
                seriesId = 0;
                specId = 0;
                BlocProvider.of<SwitchTagBloc>(context)
                    .add(JustSwitchTagEvent(1, content: "", reFresh: true));
              }
            } else if (value["type"] == "series") {
              if (brandId == value["brandId"] &&
                  seriesId == value["seriesId"] &&
                  (specText == value["brand"] + value["series"])) {
                return false;
              } else {
                specText = value["brand"] + value["series"];
                brandId = value["brandId"];
                seriesId = value["seriesId"];
                specId = 0;
                BlocProvider.of<SwitchTagBloc>(context)
                    .add(JustSwitchTagEvent(1, content: "", reFresh: true));
              }
            } else if (value["type"] == "spec") {
              if (brandId == value["brandId"] &&
                  seriesId == value["seriesId"] &&
                  specId == value["specId"] &&
                  (specText == value["series"] + value["spec"])) {
                return false;
              } else {
                specText = value["series"] + value["spec"];
                brandId = value["brandId"];
                seriesId = value["seriesId"];
                specId = value["specId"];
                BlocProvider.of<SwitchTagBloc>(context)
                    .add(JustSwitchTagEvent(1, content: "", reFresh: true));
              }
            }
          } else {
            if (brandId == 0 && seriesId == 0 && specId == 0) {
              return false;
            }
            specText = "车型品牌";
            brandId = 0;
            seriesId = 0;
            specId = 0;
            BlocProvider.of<SwitchTagBloc>(context)
                .add(JustSwitchTagEvent(1, content: "", reFresh: true));
          }
        });
      },
      child: Container(
        width: 220.w,
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: Text("$specText",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xff808080), fontSize: 28.sp)),
            ),
            Icon(Icons.arrow_drop_down, color: Color(0xff808080))
          ],
        ),
      ),
    );
  }

  //排序方式选择
  orderDefault() {
    return Offstage(
      offstage: !orderShow,
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Expanded(
              child: Stack(children: [
                Align(
                  child: Opacity(
                    opacity: 0.4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(1.r, 1.r),
                            spreadRadius: 1.r,
                            blurRadius: 1.r,
                            color: Colors.grey[300],
                          )
                        ],
                      ),
                    ),
                  ),
                  alignment: Alignment.topCenter,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: orderList.length * 75.sp,
                    child: ListView.builder(
                      itemCount: orderList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            int i = 0;
                            orderList.asMap().forEach((key, value) {
                              if (value["chose"] == true) {
                                i = key;
                              }
                            });
                            if (i != index) {
                              orderList.asMap().forEach((key, value) {
                                orderList[key]['chose'] = false;
                              });
                              orderList[index]["chose"] = true;
                            }
                            orderText = orderList[index]["name"];
                            orderShow = !orderShow;
                            setState(() {});
                            _tabPurchaseListList.clear();
                            _refreshController.requestRefresh();
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 30.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: BorderSide(
                                  width: index == 0 ? 0 : 2.w,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text("${orderList[index]["name"]}",
                                style: TextStyle(
                                    color: Color(0xff808080), fontSize: 28.sp)),
                            height: 75.sp,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  buyPrice(TabPurchaseListList tabPurchaseListList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!UserInfo.getUserVip())
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Row(
              children: [
                Text(
                  "采购价：",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff333333),
                  ),
                ),
                Text(
                  "${tabPurchaseListList.normalPrice}",
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffEE1313),
                  ),
                ),
                Text(
                  "万起",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffEE1313),
                  ),
                ),
              ],
            ),
          ),
        SizedBox(
          width: 30.w,
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 5.w, right: 5.w),
          child: Row(
            children: [
              Text(
                "会员采购价：",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff333333),
                ),
              ),
              Text(
                "${tabPurchaseListList.primePrice}",
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffEE1313),
                ),
              ),
              Text(
                "万起",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffEE1313),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
