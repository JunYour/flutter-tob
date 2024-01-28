import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tob/bloc/tab/switch_tag_bloc.dart';
import 'package:tob/bloc/tab/switch_tag_event.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/entity/home_data_entity.dart';
import 'package:tob/widget/bloc/notice.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/load_status.dart';
import 'assembly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  LoadState _layoutState = LoadState.State_Loading;
  TextEditingController _searchController = new TextEditingController();
  List<Widget> widgets = [];
  int loadStatus = 1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getHomeData();
  }

  //获取首页数据
  void getHomeData() {
    //这里请求时的数据没用实体类了
    Http.getInstance().getHomeData().then((value) {
      if (mounted) {
        dealData(value);
        setLoadStatus(LoadState.State_Success);
      }
    }).catchError((error) {
      print(error);
      if (error == 0) {
        setLoadStatus(LoadState.State_No_Network);
      } else {
        setLoadStatus(LoadState.State_Error);
      }
    });
  }

  setLoadStatus(LoadState loadState) {
    _layoutState = loadState;
    setState(() {});
  }

  //处理数据
  void dealData(List<HomeDataEntity> data) {
    data.asMap().forEach((key, value) {
      if (value.type == "banner") {
        widgets.add(carousel(value.data));
      }
      if (value.type == "menu") {
        widgets.add(btnArr(value.data));
      }
      if (value.type == "picturew") {
        if (value.extra == "1") {
          widgets.add(row2col2(value.data));
        } else if (value.extra == "2") {
          widgets.add(row2(value.data));
        }
      }
      if (value.type == "goods") {
        if (value.extra == "block") {
          widgets.add(carRow2(value.data));
        } else if (value.extra == "block one" || value.extra == "block-one") {
          widgets.add(carRow1(value.data));
        }
      }
      widgets.add(Container(
        height: 30.w,
      ));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeBoard(context: context);
      },
      child: Scaffold(
        backgroundColor: Color(0xffF4F4F4),
        appBar: AppBar(
          title: Container(
            height: 60.w,
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 30.w),
                    child: TextFormField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      style: TextStyle(color: Colors.white, fontSize: 26.sp),
                      onFieldSubmitted: (value) {
                        //这里搜索后，需要跳转至采购页面
                        BlocProvider.of<SwitchTagBloc>(context).add(
                            JustSwitchTagEvent(1,
                                content: value, reFresh: true));
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 25.w),
                        counterText: "",
                        hintText: "请输入车型",
                        hintStyle:
                            TextStyle(fontSize: 26.sp, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                navTo(context, Routes.message);
              },
              child: Container(
                  padding: EdgeInsets.only(right: 20.w),
                  child: indexIconNotice()),
            ),
          ],
          backgroundColor: Colors.white,
        ),
        body: LoadStateLayout(
          state: _layoutState,
          errorRetry: () {
            setState(() {
              _layoutState = LoadState.State_Loading;
            });
            getHomeData();
          }, //错误按钮点击过后进行重新加载
          successWidget: SingleChildScrollView(
            child: Column(
              children: widgets,
            ),
          ),
        ),
      ),
    );
  }
}
