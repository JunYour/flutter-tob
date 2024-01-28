import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/network/api.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';

import 'api.dart';

class CarModelPage extends StatefulWidget {
  final int id;
  final String type;
  final int choseType;

  CarModelPage({@required this.id, this.type, this.choseType});

  @override
  _CarModelPageState createState() => _CarModelPageState();
}

class _CarModelPageState extends State<CarModelPage> {
  List _models = [];
  String type;

  @override
  void initState() {
    getModel();
    super.initState();
  }



  //获取车型
  getModel() {
    try {
      if (widget.id == null || widget.id <= 0) {
        EasyLoading.showError('请传入参数');
        return false;
      }

      if (widget.type == null) {
        type = 'car';
      }

      var dio = Dio();
      EasyLoading.show();
      var url = Api.HOST + "/specChose/geSpec";
      Map data = {
        "seriesId": widget.id,
      };
      if (widget.choseType == 1) {
        url = CarApi.url + "/userCar/getModel";
        data = {
          "trainers_id": widget.id,
          "type": type,
        };
      }
      dio.post(url, data: data).then((value) {
        print(value);
        var data = jsonDecode(value.toString());
        if (mounted) {
          EasyLoading.dismiss();
          if (data['code'] == 200) {
            setState(() {
              _models = data['data'];
            });
          } else {
            EasyLoading.showToast(data['msg']);
          }
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
    Loading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择车型'),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      body: _models.length > 0
          ? Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, {
                    "back": true,
                    "type":"series"
                  });
                },
                child: Container(
                  width: 750.w,
                  height: 70.w,
                  alignment: Alignment.centerLeft,
                  color: Colors.transparent,
                  padding: EdgeInsets.only(left: 30.w),
                  child: Text("不限车型"),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _models.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          KlAlert.showAlert(
                              content: '您选择了“' +
                                  _models[index]['p_chexingmingcheng'] +
                                  '”,是否确认？',
                              sureFunc: () {
                                Navigator.pop(context);
                                Navigator.pop(context, {
                                  'specId': int.parse(_models[index]['p_chexing_id'].toString()) ,
                                  "spec": _models[index]['p_chexingmingcheng'],
                                  "brand":_models[index]['p_pinpai'],
                                  "back": true,
                                  "type":"spec"
                                });
                              },
                              cancelFunc: () {
                                Navigator.pop(context);
                              });
                        },
                        child:  Column(
                          children: [
                            Divider(),
                            Container(
                              padding: EdgeInsets.only(left: 30.w,right: 30.w),
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(_models[index]['p_chexi']+" "+_models[index]['p_chexingmingcheng']),
                                    ),
                                  ),
                                  Text("${_models[index]['p_changshangzhidaojia_yuan']}",style: TextStyle(
                                    color: Colors.red
                                  ),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ),
            ],
          )
          : Container(
              alignment: Alignment.center,
              child: Text('暂无该车型数据'),
            ),
    );
  }

// brandTopWidget(String zm) {
//   return GestureDetector(
//     onTap: () {
//       //  阻断最外层点击事件
//     },
//     child: Container(
//       width: 750.w,
//       color: Colors.grey[300],
//       height: 50.w,
//       alignment: Alignment.centerLeft,
//       padding: EdgeInsets.only(left: 30.w),
//       child: Text(zm + "年款"),
//     ),
//   );
// }
}
