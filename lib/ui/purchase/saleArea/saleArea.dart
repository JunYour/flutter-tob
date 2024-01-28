import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/network/api.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/widget/loading.dart';

class SaleArea extends StatefulWidget {
  const SaleArea({Key key}) : super(key: key);

  @override
  _SaleAreaState createState() => _SaleAreaState();
}

class _SaleAreaState extends State<SaleArea> {
  ///------------省份-------------
  List _province = []; //省份列表
  List _zmList = []; //省份字母列表
  ScrollController _scrollController = ScrollController(); //滚动监听
  String _zm = ""; //置顶字母
  double _zmHeight = 70.w; //字母高度
  double _provinceHeight = 70.w; //品牌高度

  @override
  void initState() {
    getProvince();
    _scrollController.addListener(() {
      double value = _scrollController.offset;
      double height = 0;
      for (int i = 0; i < _province.length; i++) {
        height += _zmHeight;
        for (int k = 0; k < _province[i]['list'].length; k++) {
          height += _provinceHeight;
          if (value <= height) {
            setState(() {
              _zm = _province[i]['zimu'];
            });
            break;
          }
        }
        if (value <= height) {
          setState(() {
            _zm = _province[i]['zimu'];
          });
          break;
        }
      }
    });
    super.initState();
  }

  //获取省份
  getProvince() {
    try {
      var dio = Dio();
      var url = Api.HOST + "/area/province";
      dio.post(url).then((value) {
        var data = jsonDecode(value.toString());
        if (mounted) {
          if (data['code'] == 200) {
            setState(() {
              var tempList = data['data'];
              var provinceList = [];
              for (int i = 0; i < tempList.length; i++) {
                if (!_zmList.contains(tempList[i]['first'])) {
                  _zmList.add(tempList[i]['first']);
                  provinceList.add({'zimu': tempList[i]['first'], 'list': []});
                }
              }
              _zmList.sort();
              provinceList.sort((a, b) => a['zimu'].compareTo(b['zimu']));
              for (int i = 0; i < _zmList.length; i++) {
                for (int k = 0; k < tempList.length; k++) {
                  if (_zmList[i] == tempList[k]['first']) {
                    provinceList[i]['list'].add(tempList[k]);
                  }
                }
              }
              _zm = _zmList[0];
              _province = provinceList;
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
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("销售区域"),
        brightness: Brightness.dark,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    MyRoute.router.pop(context);
                  },
                  child: Container(
                    height: 140.w,
                    color: Colors.grey,
                    padding:
                        EdgeInsets.only(left: 30.w, right: 30.w, top: 70.w),
                    alignment: Alignment.centerLeft,
                    child: Text("全国"),
                  ),
                ),
                Expanded(
                  child: provinceWidget(),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: provinceZmWidget(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: provinceTopWidget(_zm),
          ),
        ],
      ),
    );
  }

  //省份视图
  provinceWidget() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _province.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            provinceTopWidget(_province[index]['zimu']),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _province[index]['list'].length,
              itemBuilder: (BuildContext contextChild, int indexChild) {
                return GestureDetector(
                  onTap: () {
                    MyRoute.router.pop(context, {
                      "provinceId": _province[index]['list'][indexChild]['id'],
                      "provinceName": _province[index]['list'][indexChild]
                          ['name'],
                    });
                  },
                  child: Container(
                    width: 750.w,
                    height: _provinceHeight,
                    alignment: Alignment.centerLeft,
                    color: Colors.transparent,
                    padding: EdgeInsets.only(left: 30.w),
                    child: Text(_province[index]['list'][indexChild]['name']),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  //省份字母视图
  provinceZmWidget() {
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
                toHeight += _province[i]['list'].length * _provinceHeight;
              }
              ziMu = _province[index]['zimu'];
              toHeight += 1.w; //这里+1是为了滚动多1.w个像素，不然顶部不会显示对应的字母
              _scrollController.jumpTo(toHeight);
              //显示1s的字母-显示在屏幕中间
              Loading.toast(msg: ziMu);
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
  provinceTopWidget(String zm) {
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
        child: Text("$zm"),
      ),
    );
  }
}
