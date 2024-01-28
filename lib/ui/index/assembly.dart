import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/main.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/ui/index/goods.dart';
import 'package:tob/ui/index/menu.dart';
import 'package:tob/ui/index/picture.dart';
import 'package:tob/widget/common_widget.dart';
import 'banner.dart';

inkwellTap() {}

///轮播图
carousel(List list) {
  List<HomeBanner> data = list.map((e) => HomeBanner.fromJson(e)).toList();
  return Container(
    color: Colors.white,
    child: Container(
      height: 220.w,
      margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 30.w),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              jump(
                  type: int.parse(data[index].type), link: data[index].linkurl);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.w),
              child: showImageNetwork(img: data[index].imgurl),
            ),
          );
        },
        autoplay: true,
        autoplayDelay: 5000,
        itemCount: data.length,
        scrollDirection: Axis.horizontal,
        pagination: new SwiperPagination(alignment: Alignment.bottomCenter),
      ),
    ),
  );
}

///按钮组
btnArr(List list) {
  List<HomeMenu> data = list.map((e) => HomeMenu.fromJson(e)).toList();
  return Container(
    color: Colors.white,
    child: Container(
      margin: EdgeInsets.only(left: 30.w, right: 30.w),
      alignment: Alignment.centerLeft,
      child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 100.w,
          children: data.map((e) {
            return Container(
              width: 97.w,
              child: InkWell(
                onTap: () {
                  jump(type: int.parse(e.type), link: e.linkurl);
                },
                child: Column(
                  children: [
                    Container(
                      width: 97.w,
                      height: 97.w,
                      child: showImageNetwork(img: e.imgurl),
                    ),
                    Container(
                      width: 97.w,
                      height: 50.w,
                      alignment: Alignment.center,
                      child: Text(e.text),
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
    ),
  );
}

///横排两个广告页面-row=2
row2(List list) {
  List<HomePicture> data = list.map((e) => HomePicture.fromJson(e)).toList();
  return Container(
    width: 690.w,
    margin: EdgeInsets.only(left: 30.w, right: 30.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            jump(type: int.parse(data[0].linktype), link: data[0].linkurl);
          },
          child: Container(
            width: 337.w,
            height: 160.w,
            child: showImageNetwork(img: data[0].imgurl),
          ),
        ),
        InkWell(
          onTap: () {
            jump(type: int.parse(data[1].linktype), link: data[1].linkurl);
          },
          child: Container(
            width: 337.w,
            height: 160.w,
            child: showImageNetwork(img: data[1].imgurl),
          ),
        )
      ],
    ),
  );
}

///横排两个广告页面,右边上下两个-row=1
row2col2(List list) {
  List<HomePicture> data = list.map((e) => HomePicture.fromJson(e)).toList();
  return Container(
    width: 690.w,
    margin: EdgeInsets.only(left: 30.w, right: 30.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            jump(type: int.parse(data[0].linktype), link: data[0].linkurl);
          },
          child: Container(
            width: 337.w,
            height: 510.w,
            child: showImageNetwork(img: data[0].imgurl),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                jump(type: int.parse(data[1].linktype), link: data[1].linkurl);
              },
              child: Container(
                width: 337.w,
                height: 250.w,
                child: showImageNetwork(img: data[1].imgurl),
              ),
            ),
            SizedBox(height: 10.w),
            GestureDetector(
              onTap: () {
                jump(type: int.parse(data[2].linktype), link: data[2].linkurl);
              },
              child: Container(
                width: 337.w,
                height: 250.w,
                child: showImageNetwork(img: data[2].imgurl),
              ),
            )
          ],
        ),
      ],
    ),
  );
}

///一排只有一辆车
carRow1(List list) {
  List<HomeGoods> data = list.map((e) => HomeGoods.fromJson(e)).toList();

  ///价格
  priceRow(HomeGoods homeGoods) {
    TextStyle styleGrey = TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: Color(0xff666666),
    );

    TextStyle styleRedMin = TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: Color(0xffEC1414),
    );

    TextStyle styleRedMax = TextStyle(
      fontSize: 30.sp,
      fontWeight: FontWeight.bold,
      color: Color(0xffEC1414),
    );

    return Container(
      width: 630.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!UserInfo.getUserVip())
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("采购价：", style: styleGrey),
                  Text("${homeGoods.normalPrice}", style: styleRedMax),
                  Text("万起", style: styleRedMin),
                ],
              ),
            ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("会员采购价：", style: styleGrey),
                Text("${homeGoods.primePrice}", style: styleRedMax),
                Text("万起", style: styleRedMin),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///图片和车型名称
  imageTitle(HomeGoods homeGoods) {
    return Row(
      children: [
        ///图片
        Container(
          width: 200.w,
          margin: EdgeInsets.only(right: 30.w),
          height: 160.w,
          child: showImageNetwork(img: homeGoods.indexImage, h: 150.w),
        ),
        Container(
          padding: EdgeInsets.only(top: 20.w),
          height: 180.w,
          child: Column(
            children: [
              Container(
                height: 70.w,
                width: 400.w,
                child: Text(
                  "${homeGoods.brandName + ' ' + homeGoods.seriesName + " " + homeGoods.carName}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff333333),
                      height: 1.4),
                ),
              ),
              Container(
                width: 400.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "库存数量：${homeGoods.total}",
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff999999)),
                    ),
                    if (!UserInfo.getUserVip())
                      Text(
                        "会员价：${homeGoods.primePrice}万起",
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff999999)),
                      ),
                  ],
                ),
              ),

              ///采购价or会员价
              Container(
                margin: EdgeInsets.only(top: 10.w),
                width: 400.w,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      UserInfo.getUserVip() ? "会员价：" : "采购价：",
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${UserInfo.getUserVip() ? homeGoods.primePrice : homeGoods.normalPrice}",
                      style: TextStyle(
                          height: 1.1,
                          fontSize: 30.sp,
                          color: Color(0xffE41F1F)),
                    ),
                    Text(
                      "万起",
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///标签
  tags(List listLabels) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 630.w,
      child: Wrap(
        runSpacing: 10.w,
        spacing: 22.w,
        children: listLabels.map((e) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: ColorConfig.themeColor),
              borderRadius: BorderRadius.circular(5.w),
            ),
            padding:
                EdgeInsets.only(left: 6.w, top: 3.w, bottom: 3.w, right: 6.w),
            child: Text(
              "$e",
              style: TextStyle(
                fontSize: 20.sp,
                color: Color(0xff0D6AF5),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  ///销售城市
  city(HomeGoods homeGoods) {
    return Container(
      width: 630.w,
      margin: EdgeInsets.only(top: 10.w),
      alignment: Alignment.centerLeft,
      child: Text(
        "${homeGoods.salecityName}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  return Row(
    children: data.map((e) {
      return InkWell(
        onTap: () {
          jump(
              type: 1,
              link: Routes.tabPurchaseTabDetail + "?id=" + e.id.toString());
        },
        child: Container(
          margin: EdgeInsets.only(left: 30.w, right: 30.w),
          color: Colors.white,
          padding: EdgeInsets.only(left: 30.w, right: 30.w, bottom: 20.w),
          child: Column(
            children: [
              ///图片-标题-指导价
              imageTitle(e),

              ///  价格
              // priceRow(e),

              ///  标签
              tags(e.detailLabels),

              ///城市
              city(e)
            ],
          ),
        ),
      );
    }).toList(),
  );
}

/// 一排有两辆车
carRow2(List list) {
  List<HomeGoods> data = list.map((e) => HomeGoods.fromJson(e)).toList();

  ///车型图片
  pic(String pic) {
    return Container(
      height: 200.w,
      child: showImageNetwork(img: pic),
    );
  }

  ///车型名称
  title(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.w),
      height: 70.w,
      child: Text(
        "$title",
        style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Color(0xff333333),
            height: 1.5),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  ///指导价
  priZd(String price) {
    return Container(
      margin: EdgeInsets.only(top: 25.w),
      child: Text(
        "指导价：$price",
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          height: 1,
          color: Color(0xff666666),
        ),
      ),
    );
  }

  ///价格
  priOth(HomeGoods homeGoods) {
    TextStyle styleMax = TextStyle(
      fontSize: 30.sp,
      fontWeight: FontWeight.bold,
      height: 1,
      // color: Color(0xFFF12615),
      color: Color(0xFF666666),
    );

    TextStyle styleMin = TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      height: 1,
      color: Color(0xFF666666),
    );

    if (!UserInfo.getUserVip()) {
      return Column(
        children: [
          Container(
            child: Row(
              children: [
                Text(
                  "会员价：",
                  style: TextStyle(fontSize: 20.sp, color: Color(0xff999999)),
                ),
                Text(
                  "${homeGoods.primePrice}",
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Color(0xff999999),
                  ),
                ),
                Text(
                  "万起",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                text: "采购价：",
                children: [
                  TextSpan(
                    text: "${homeGoods.normalPrice}",
                    style: TextStyle(
                      fontSize: 30.sp,
                      color: Color(0xffEB1818),
                    ),
                  ),
                  TextSpan(text: "万起"),
                ],
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Color(0xFF666666),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Text(
            "会员价：",
            style: TextStyle(
              fontSize: 20.sp,
              color: Color(0xFF666666),
            ),
          ),
          Text(
            "${homeGoods.primePrice}",
            style: TextStyle(
              fontSize: 30.sp,
              height: 1.1,
              color: Color(0xffEB1818),
            ),
          ),
          Text(
            "万起",
            style: TextStyle(
              fontSize: 20.sp,
              color: Color(0xFF666666),
            ),
          ),
        ],
      );
    }
  }

  ///标签
  tags(List list) {
    return Container(
      margin: EdgeInsets.only(top: 5.w),
      alignment: Alignment.centerLeft,
      child: Wrap(
          runSpacing: 10.w,
          spacing: 20.w,
          children: list.map((e) {
            return Container(
              decoration: BoxDecoration(
                // color: ColorConfig.themeColor,
                border: Border.all(color: ColorConfig.themeColor),
                borderRadius: BorderRadius.circular(5.w),
              ),
              padding:
                  EdgeInsets.only(left: 6.w, top: 3.w, bottom: 3.w, right: 6.w),
              child: Text(
                "$e",
                style: TextStyle(
                  fontSize: 20.sp,
                  color: ColorConfig.themeColor,
                ),
              ),
            );
          }).toList()),
    );
  }

  ///销售地区
  city(HomeGoods homeGoods) {
    return Container(
      // margin: EdgeInsets.only(top: 10.w),
      alignment: Alignment.bottomLeft,
      child: Text(
        "${homeGoods.salecityName}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  return Container(
    margin: EdgeInsets.only(left: 30.w, right: 30.w),
    child: IntrinsicHeight(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // spacing: 15.w,
          // runSpacing: 15.w,
          children: data.map((e) {
            return InkWell(
              onTap: () {
                jump(
                    type: 1,
                    link:
                        Routes.tabPurchaseTabDetail + "?id=" + e.id.toString());
              },
              child: Container(
                width: 337.w,
                color: Colors.white,
                child: Column(
                  children: [
                    Column(
                      children: [
                        //  图片
                        pic(e.indexImage),
                        Container(
                          padding: EdgeInsets.only(
                              left: 13.w, right: 13.w, bottom: 13.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///  标题
                              title(e.brandName +
                                  ' ' +
                                  e.seriesName +
                                  ' ' +
                                  e.carName),

                              ///  指导价
                              // priZd(e.cars.),

                              ///  其他价
                              priOth(e),

                              ///标签
                              tags(e.listLabels),
                            ],
                          ),
                        ),
                      ],
                    ),

                    ///城市
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10.w, bottom: 10.w),
                        child: city(e),
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList()),
    ),
  );
}

/// 跳转
void jump({@required int type, @required String link}) {
  if (type == null || link == "") {
    return;
  }
  BuildContext _thisContext = navigatorKey.currentState.overlay.context;
  if (type == 1) {
    navTo(_thisContext, link);
  } else if (type == 0) {
    navTo(
        _thisContext, Routes.webViewPage + "?url=${Uri.encodeComponent(link)}");
  }
}
