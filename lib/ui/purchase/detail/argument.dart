import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tob/network/http.dart';
import 'package:tob/widget/common_widget.dart';

///配置详情页面
class CarArgumentPage extends StatefulWidget {
  final int id;
  CarArgumentPage({this.id});

  @override
  _CarArgumentPageState createState() => _CarArgumentPageState();
}

class _CarArgumentPageState extends State<CarArgumentPage> {
  Widget _buildArgumentWidget(Map<String, dynamic> inner) {
    if (inner == null) {
      return Container();
    }
    //本来map也能实现的，但是就怕key相同了
    List<Map<String, String>> list = [];
    inner.forEach((key, value) {
      //add外层
      Map<String, String> flatMap = {};
      flatMap[key] = null;
      list.add(flatMap);
      if (value is Map) {
        Map<String, String> flatMap = {};
        Map<String, dynamic> temp = value;
        temp.forEach((key, value) {
          flatMap = {};
          flatMap[key] = value;
          list.add(flatMap);
        });
      }
    });
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: false,
        itemBuilder: (context, index) {
          if (index == list.length * 2) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 35, 0, 27),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Color(0x99696969),
                      height: 0.5,
                      width: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "非常抱歉哦，已经到底啦!",
                        style: TextStyle(color: Color(0x99696969), fontSize: 10),
                      ),
                    ),
                    Container(
                      color: Color(0x99696969),
                      height: 0.5,
                      width: 30,
                    ),
                  ],
                ),
              ),
            );
          }
          if (index % 2 == 1) {
            return Container(
              color: Color(0xffe6e6e6),
              height: 1.w,
            );
          }
          if (list[index ~/ 2].values.elementAt(0) == null) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(30.w),
              color: Color(0xfff2f3fb),
              child: Text(
                list[index ~/ 2].keys.elementAt(0) ?? "-",
                style: TextStyle(
                  color: Color(0xff999999),
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          return Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(30.0.w),
                  child: Text(
                    list[index ~/ 2].keys.elementAt(0) ?? "-",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 28.sp,
                      color: Color(0xff333333),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 30.0.w, 30.0.w, 30.0.w),
                  child: Text(
                    list[index ~/ 2].values.elementAt(0).toString().length>0 ?list[index ~/ 2].values.elementAt(0).toString(): "-",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 28.sp,
                      color: Color(0xff999999),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        itemCount: inner == null ? 0 : list.length * 2 + 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("配置详情"),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      body: Column(
        children: <Widget>[
          //内容
          FutureBuilder(
            future: Http.getInstance().getCarArgumentByIdNew(id:widget.id),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done && !snap.hasError) {
                return _buildArgumentWidget(snap.data);
              } else if (snap.connectionState == ConnectionState.done && snap.hasError) {
                return Expanded(child: Center(child: Text("${snap.error.toString()}")));
              }
              return Expanded(child: Center(child: loadingData()));
            },
          ),
        ],
      ),
    );
  }
}
