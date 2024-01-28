import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tob/entity/purchase/purchase_file_list_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/widget/common_widget.dart';

class FileListPage extends StatefulWidget {
  final int pid;
  FileListPage({@required this.pid});

  @override
  _FileListPageState createState() => _FileListPageState();
}

class _FileListPageState extends State<FileListPage> {
  TextEditingController _searchController = new TextEditingController();
  List<PurchaseFileListEntity> _purchaseFileListEntity = [];
  TextStyle vinStyle = TextStyle(
    color: Colors.white,
    fontSize: 28.sp,
  );
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  //刷新
  void _onRefresh() {
    _refreshController.resetNoData();
    Http.getInstance()
        .purchaseFileList(pid: widget.pid, vin: _searchController.text)
        .then((value) {
      if (mounted) {
        _purchaseFileListEntity = value;
        _refreshController.loadNoData();
        _refreshController.refreshCompleted();
        setState(() {});
      }
    }).catchError((error) {
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbarTitle(title: '回传资料'),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
            setState(() {});
          }
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                color: ColorConfig.themeColor,
                height: 88.w,
              ),
            ),
            Positioned(
              top: 160.w,
              child: Container(
                width: 750.w,
                height: MediaQuery.of(context).size.height - 300.w,
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: fileListData(),
                ),
              ),
            ),
            //搜索
            Positioned(
              top: 64.w,
              left: 40.w,
              right: 40.w,
              child: Container(
                width: 670.w,
                height: 84.w,
                decoration: comBoxDecoration(),
                padding: EdgeInsets.only(
                  left: 42.w,
                  right: 42.w,
                ),
                child: TextField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text:
                          '${_searchController.text == null ? "" : _searchController.text}', //判断keyword是否为空
                      // 保持光标在最后
                      selection: TextSelection.fromPosition(
                        TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: '${_searchController.text}'.length),
                      ),
                    ),
                  ),
                  onSubmitted: (value) {


                    _refreshController.requestRefresh();
                  },
                  onChanged: (value){
                    _searchController.text = value.toUpperCase();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.search_outlined,
                      color: ColorConfig.themeColor,
                      size: 48.w,
                    ),
                    hintText: '请输入车架号后6位查询',
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  maxLength: 6,
                  textInputAction: TextInputAction.search,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  fileListData() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _purchaseFileListEntity.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width: 690.w,
          decoration: comBoxDecoration(),
          padding: EdgeInsets.all(30.w),
          margin: EdgeInsets.only(
            left: 30.w,
            right: 30.w,
            bottom: 30.w,
          ),
          child: Column(
            children: [
              //颜色
              Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 8.w,
                        color: ColorConfig.themeColor[100],
                      ),
                    ),
                  ),
                  child: Text(
                    '${_purchaseFileListEntity[index].colorName}',
                    style: TextStyle(
                      color: ColorConfig.themeColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 32.sp,
                    ),
                  ),
                ),
              ),
              //车架号列表
              Container(
                margin: EdgeInsets.only(top: 30.w),
                padding: EdgeInsets.all(30.w),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorConfig.themeColor,
                  borderRadius: BorderRadius.circular(16.w),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 6.w),
                      blurRadius: 20.w,
                      spreadRadius: 0,
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    //标题
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          width: 80.w,
                          child: Text(
                            '序号',
                            style: vinStyle,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 300.w,
                          child: Text(
                            '车架号',
                            style: vinStyle,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w),
                          alignment: Alignment.center,
                          width: 120.w,
                          child: Text(
                            '状态',
                            style: vinStyle,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: 60.w,
                          child: Text(
                            '操作',
                            style: vinStyle,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 2.w,
                      margin: EdgeInsets.only(
                        top: 24.w,
                        bottom: 38.w,
                      ),
                      color: ColorConfig.themeColor[100],
                    ),
                    //颜色列表
                    for (int i = 0;
                        i < _purchaseFileListEntity[index].vin.length;
                        i++)
                      GestureDetector(
                        onTap: () {
                          MyRoute.router
                              .navigateTo(
                                  context,
                                  Routes.fileEdit +
                                      '?pid=${widget.pid}&vid=${_purchaseFileListEntity[index].vin[i].id}&colorName=${Uri.encodeComponent(_purchaseFileListEntity[index].vin[i].colorName)}&vin=${_purchaseFileListEntity[index].vin[i].vin}',
                                  transition: TransitionType.fadeIn)
                              .then((value) {
                            if (value != null && value == true) {
                              _refreshController.requestRefresh();
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 32.w),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 80.w,
                                child: Text(
                                  '${i + 1}',
                                  style: vinStyle,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 300.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.w),
                                ),
                                padding: EdgeInsets.only(
                                    top: 10.w,
                                    bottom: 10.w,
                                    right: 10.w,
                                    left: 10.w),
                                child: Text(
                                  '${_purchaseFileListEntity[index].vin[i].vin}',
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    color: ColorConfig.themeColor,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10.w),
                                alignment: Alignment.center,
                                width: 120.w,
                                child: stateText(_purchaseFileListEntity[index]
                                    .vin[i]
                                    .state),
                              ),
                              opGestureDetector(context, index, i),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Container opGestureDetector(BuildContext context, int index, int i) {
    int state = _purchaseFileListEntity[index].vin[i].state;
    String text = "";
    switch (state) {
      case 1:
        text = "上传";
        break;
      case 2:
        text = "查看";
        break;
      case 3:
        text = "查看";
        break;
      case 4:
        text = "更新";
        break;
    }

    return Container(
      alignment: Alignment.centerRight,
      width: 60.w,
      child: Text(
        '$text',
        style: vinStyle,
      ),
    );
  }

  Text stateText(int state) {
    String text = "";
    Color color = Colors.red[300];
    switch (state) {
      case 1:
        text = "未上传";
        color = Colors.red[300];
        break;
      case 2:
        text = "审核中";
        color = Colors.blue[300];
        break;
      case 3:
        text = "已通过";
        color = Colors.green[300];
        break;
      case 4:
        text = "未通过";
        color = Colors.red[300];
        break;
    }
    return Text(
      '$text',
      style: TextStyle(fontSize: vinStyle.fontSize, color: color),
    );
  }
}
