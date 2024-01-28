import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tob/network/api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/loading.dart';

import 'model.dart';

class Brand extends StatefulWidget {
  final int type;

  Brand({this.type});

  @override
  _BrandState createState() => _BrandState();
}

class _BrandState extends State<Brand> {
  ///------------品牌-------------
  List _brand = []; //品牌列表
  List _zmList = []; //品牌字母列表
  ScrollController _scrollController = ScrollController(); //滚动监听
  String _zm = ""; //置顶字母
  double _zmHeight = 70.w; //字母高度
  double _brandHeight = 70.w; //品牌高度

  ///-------------车系-------------
  List _series = []; //车系列表
  bool _seriesShow = false;

  int _brandId = 0;
  String _brandName;

  @override
  void initState() {
    getBrand();
    _scrollController.addListener(() {
      double value = _scrollController.offset;
      double height = 0;
      for (int i = 0; i < _brand.length; i++) {
        height += _zmHeight;
        for (int k = 0; k < _brand[i]['list'].length; k++) {
          height += _brandHeight;
          if (value <= height) {
            setState(() {
              _zm = _brand[i]['zimu'];
            });
            break;
          }
        }
        if (value <= height) {
          setState(() {
            _zm = _brand[i]['zimu'];
          });
          break;
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    Loading.dismiss();
  }

  //获取品牌
  getBrand() {
    try {
      var dio = Dio();
      var url = Api.HOST + "/specChose/getBrand";
      dio.post(url).then((value) {
        var data = jsonDecode(value.toString());
        if (mounted) {
          if (data['code'] == 200) {
            setState(() {
              var tempList = data['data'];
              var brandList = [];

              for (int i = 0; i < tempList.length; i++) {
                if (!_zmList.contains(tempList[i]['p_shouzimu'])) {
                  _zmList.add(tempList[i]['p_shouzimu']);
                  brandList
                      .add({'zimu': tempList[i]['p_shouzimu'], 'list': []});
                }
              }
              _zmList.sort();
              brandList.sort((a, b) => a['zimu'].compareTo(b['zimu']));
              for (int i = 0; i < _zmList.length; i++) {
                for (int k = 0; k < tempList.length; k++) {
                  if (_zmList[i] == tempList[k]['p_shouzimu']) {
                    brandList[i]['list'].add(tempList[k]);
                  }
                }
              }
              _zm = _zmList[0];
              _brand = brandList;
            });
          } else {}
        }
      }).catchError((onError) {
        print(onError);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_brand.length <= 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text('品牌-车系'),
          centerTitle: true,
          brightness: Brightness.dark,
        ),
        body: loadingData(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('品牌-车系'),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      body: bodyS(),
    );
  }

  bodyS() {
    return Stack(children: [
      Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                MyRoute.router.pop(context);
              },
              child: Container(
                width: 750.w,
                height: 70.w,
                alignment: Alignment.centerLeft,
                color: Colors.transparent,
                padding: EdgeInsets.only(left: 30.w),
                child: Text("不限品牌"),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: brandWidget(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: brandZmWidget(),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: brandTopWidget(_zm),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Offstage(
        offstage: !_seriesShow,
        child: Align(
          alignment: Alignment.topRight,
          child: seriesWidget(),
        ),
      ),
    ]);
  }

  //品牌视图
  brandWidget() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _brand.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            brandTopWidget(_brand[index]['zimu']),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _brand[index]['list'].length,
              itemBuilder: (BuildContext contextChild, int indexChild) {
                return GestureDetector(
                  onTap: () {
                    int brandId = int.parse(
                        _brand[index]['list'][indexChild]['p_pinpai_id']);
                    //赋值
                    _brandId = brandId;
                    _brandName = _brand[index]['list'][indexChild]['p_pinpai'];
                    //打开车系
                    getSeries(brandId);
                  },
                  child: Container(
                    width: 750.w,
                    height: _brandHeight,
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    padding: EdgeInsets.only(left: 30.w),
                    child: Text(_brand[index]['list'][indexChild]['p_pinpai']),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  //品牌字母视图
  brandZmWidget() {
    double height = 35.w;
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      width: 100.w,
      height: _zmList.length * height,
      child: ListView.builder(
        itemCount: _zmList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              var toHeight = index * _zmHeight;
              var ziMu = "";
              for (int i = 0; i < index; i++) {
                toHeight += _brand[i]['list'].length * _brandHeight;
              }
              ziMu = _brand[index]['zimu'];
              toHeight += 1.w; //这里+1是为了滚动多1.w个像素，不然顶部不会显示对应的字母
              _scrollController.jumpTo(toHeight);
              //显示1s的字母-显示在屏幕中间
              EasyLoading.showToast(ziMu);
            },
            child: Container(
              width: 50.w,
              height: height,
              color: Colors.transparent,
              alignment: Alignment.center,
              child: Text(
                _zmList[index],
                style: TextStyle(fontSize: 30.sp),
              ),
            ),
          );
        },
      ),
    );
  }

  //字母置顶
  brandTopWidget(String zm) {
    return GestureDetector(
      onTap: () {
        //  阻断最外层点击事件
      },
      child: Container(
        width: 750.w,
        color: Colors.grey[300],
        height: _zmHeight,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 30.w),
        child: Text(zm),
      ),
    );
  }

  //获取车系
  getSeries(int bid) {
    var dio = Dio();

    try {
      EasyLoading.show();
      var url = Api.HOST + "/specChose/geSeries";
      Map params = {'brandId': bid};
      dio.post(url, data: params).then((value) {
        var data = jsonDecode(value.toString());
        if (mounted) {
          EasyLoading.dismiss();
          if (data['code'] == 200) {
            setState(() {
              List tempList = data['data'];
              List changShang = [];
              for (int i = 0; i < tempList.length; i++) {
                if(changShang.length<=0){
                  changShang.add(
                      {'changShang': tempList[i]['p_changshang'], 'list': []});
                }else{
                  for(int k=0;k<changShang.length;k++){
                    if (!(changShang[k]['changShang'] == tempList[i]['p_changshang'])) {
                      changShang.add(
                          {'changShang': tempList[i]['p_changshang'], 'list': []});
                    }
                  }
                }
              }
              for (int i = 0; i < changShang.length; i++) {
                for (int k = 0; k < tempList.length; k++) {
                  if (changShang[i]['changShang'] ==
                      tempList[k]['p_changshang']) {
                    changShang[i]['list'].add(tempList[k]);
                  }
                }
              }
              _series = changShang;
              _seriesShow = true;
            });
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  //车系视图
  seriesWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _seriesShow = false;
        });
      },
      child: Container(
        width: 750.w,
        height: ScreenUtil().screenHeight,
        color: Color.fromRGBO(0, 0, 0, 0.2),
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            return false;
          },
          child: Container(
            width: 500.w,
            height: ScreenUtil().screenHeight,
            color: Colors.white,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context,{
                      "brandId":_brandId,
                      "brand":_brandName,
                      "seriesId":0,
                      "series":"",
                      "type":"series"
                    });
                  },
                  child: Container(
                    width: 750.w,
                    height: 70.w,
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    padding: EdgeInsets.only(left: 30.w),
                    child: Text("不限车系"),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _series.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          brandTopWidget(_series[index]['changShang']),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _series[index]['list'].length,
                            itemBuilder:
                                (BuildContext contextChild, int indexChild) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) {
                                    return new CarModelPage(
                                      id: int.parse(_series[index]['list']
                                          [indexChild]['p_chexi_id']),
                                      choseType: widget.type,
                                    );
                                  })).then((value) {
                                    if (value != null) {
                                      if (value['back'] == true) {
                                        if(value["type"]=="spec"){
                                          Navigator.pop(context, {
                                            'specId': value['specId'],
                                            "spec": value['spec'],
                                            "seriesId": int.parse(_series[index]['list']
                                            [indexChild]['p_chexi_id']) ,
                                            "series": _series[index]['list']
                                            [indexChild]['p_chexi'],
                                            "brandId": int.parse(_series[index]['list']
                                            [indexChild]['p_pinpai_id'].toString()) ,
                                            "brand": value['brand'],
                                            "type":"spec"
                                          });
                                        }else if(value["type"]=="series"){
                                          Navigator.pop(context, {
                                            'specId': 0,
                                            "spec": "",
                                            "seriesId": int.parse(_series[index]['list']
                                            [indexChild]['p_chexi_id'].toString()),
                                            "series": _series[index]['list']
                                            [indexChild]['p_chexi'],
                                            "brandId": int.parse(_series[index]['list']
                                            [indexChild]['p_pinpai_id'].toString()) ,
                                            "brand": value['brand'],
                                            "type":"spec"
                                          });
                                        }
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                  width: 750.w,
                                  height: 50.w,
                                  alignment: Alignment.centerLeft,
                                  color: Colors.transparent,
                                  padding: EdgeInsets.only(left: 30.w),
                                  child: Text(_series[index]['list'][indexChild]
                                      ['p_chexi']),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
