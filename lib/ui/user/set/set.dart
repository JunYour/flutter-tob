import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tob/bloc/userInfo/user_info_bloc.dart';
import 'package:tob/entity/base_data_entity.dart';
import 'package:tob/entity/user_info_entity.dart';
import 'package:tob/global/address.dart';
import 'package:tob/global/baseData.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/ui/user/set/set_version.dart';
import 'package:tob/util/common_util.dart';
import 'package:tob/widget/bloc/user.dart';
import 'package:tob/widget/common_widget.dart';
import 'package:tob/widget/content_webview_dart.dart';
import 'package:tob/widget/image_upload.dart';
import 'package:tob/widget/kl_alert.dart';
import 'package:tob/widget/loading.dart';

class SetPage extends StatefulWidget {
  @override
  _SetPageState createState() => _SetPageState();
}

class _SetPageState extends State<SetPage> {
  List infoList = [
    {
      'title': '用户协议',
      'leadContent': '',
      'showLead': false,
      'url': '',
      'key': 1
    },
    {
      'title': '隐私政策',
      'leadContent': '',
      'showLead': false,
      'url': '',
      'key': 2
    },
    {'title': '清除缓存', 'leadContent': "", 'showLead': true, 'url': ''},
  ];

  @override
  void initState() {
    _getCount();
    super.initState();
  }

  @override
  void dispose() {
    Loading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.bgColor,
      appBar: AppBar(
        title: Text(
          '个人设置',
        ),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            //第一层
            Container(
              margin: EdgeInsets.only(top: 26.w),
              width: double.infinity,
              padding: EdgeInsets.only(left: 30.w, right: 30.w),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    height: 107.w,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: Color(0xFFE2E2E2), width: 2.w),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildText("头像"),
                        InkWell(
                          onTap: () {
                            ImgUpload.upload(func: (value) {
                              Loading.show();
                              Http.getInstance()
                                  .imgUpload(value, Config.profile)
                                  .then((imgRes) {
                                Http.getInstance()
                                    .uploadHeaderImage(
                                        url: CommonUtil.imgDeal(
                                            imgStr: imgRes.fileUrl,
                                            type: Config.profile))
                                    .then((headImgRes) {
                                  UserInfoEntity userInfo =
                                      UserInfo.getUserInfo();
                                  userInfo.avatar = imgRes.fileUrl;
                                  UserInfo.setUserInfo(userInfo);
                                  BlocProvider.of<UserInfoBloc>(context)
                                      .add(UserStateEvent());
                                }).whenComplete(
                                  () => Loading.dismiss(),
                                );
                              }).whenComplete(() {
                                Loading.dismiss();
                              });
                            });
                          },
                          child: Container(
                            width: 76.w,
                            height: 76.w,
                            child: blocHeadImage(width: 76.w, height: 76.w),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 107.w,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: Color(0xFFE2E2E2), width: 2.w),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildText("用户名",),
                        blocNameText(color: Colors.grey),
                      ],
                    ),
                  ),
                  Container(
                    height: 107.w,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: Color(0xFFE2E2E2), width: 2.w),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        MyRoute.router.navigateTo(context, Routes.updPhone,transition: TransitionType.cupertino);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildText("手机号"),
                          Row(
                            children: [
                              blocPhone(colors: Colors.grey,size:30.sp,hide: true),
                              Icon(
                                Icons.chevron_right,
                                size: 42.w,
                                color: Color(0xFF666666),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 107.w,
                    child: InkWell(
                      onTap: () {
                        MyRoute.router.navigateTo(context, Routes.updPassword,transition: TransitionType.cupertino);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildText("修改密码"),
                          Row(
                            children: [
                              Icon(
                                Icons.chevron_right,
                                size: 42.w,
                                color: Color(0xFF666666),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //第二层
            Container(
              margin: EdgeInsets.only(top: 15.w),
              width: double.infinity,
              padding: EdgeInsets.only(left: 30.w, right: 30.w),
              color: Colors.white,
              child: Column(
                children: [
                  for (int i = 0; i < infoList.length; i++)
                    Container(
                      height: 107.w,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xFFE2E2E2), width: 2.w),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (i == 2) {
                            KlAlert.showAlert(
                                content: '确认清除缓存${infoList[i]['leadContent']}？',
                                sureFunc: () {
                                  _clearCache();
                                  MyRoute.router.pop(context);
                                },
                                cancelFunc: () {
                                  MyRoute.router.pop(context);
                                });
                          } else if (i == 0 || i == 1) {
                            BaseDataEntity baseDataEntity;
                            if (i == 0) {
                              baseDataEntity = BaseData.getUserAgreement();
                            } else {
                              baseDataEntity = BaseData.getPrivacyPolicy();
                            }
                            if (baseDataEntity == null ||
                                baseDataEntity.content == null) {
                              KlAlert.showAlert(
                                  content: '未获取到内容',
                                  sureFunc: () {
                                    MyRoute.router.pop(context);
                                  });
                              return false;
                            }
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) {
                                  return new ContentWebView(
                                      html: baseDataEntity.content,
                                      title: baseDataEntity.title);
                                },
                              ),
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildText( infoList[i]['title']),
                            Row(
                              children: [
                                infoList[i]['showLead']
                                    ? Text(
                                        infoList[i]['leadContent'],
                                        style: TextStyle(
                                          fontSize: 32.sp,
                                          color: Color(0xFF333333),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    : Text(''),
                                Icon(Icons.chevron_right)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  Container(
                    height: 107.w,
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildText("版本号"),
                          Row(
                            children: [
                              SetVersion(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //退出登录
            loginOut(context),
          ],
        ),
      ),
    );
  }
  Container loginOut(BuildContext context) {
    return Container(
            margin: EdgeInsets.only(top: 50.w),
            child: eleButton(
                width: 513.w,
                height: 80.w,
                color: ColorConfig.themeColor,
                circular: 40.w,
                con: "退出登录",
                func: () {
                  KlAlert.showAlert(
                      content: '确认退出登录？',
                      sureFunc: () {
                        UserInfo.clearUserInfo();
                        Address.clearAddress();
                        MyRoute.router.navigateTo(context, Routes.loginPhone,
                            replace: true, clearStack: true);
                      },
                      cancelFunc: () {
                        MyRoute.router.pop(context);
                      });
                }),
          );
  }

  //列表标题文字
  Text buildText(String text) {
    return Text(
      "$text",
      style: TextStyle(
        fontSize: 36.sp,
        height: 1,
        color: Color(0xff333333),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // 清理缓存
  void _clearCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      //删除缓存目录
      await _delDir(tempDir);
      await _loadCache();
      _getCount();
      showToast("清除缓存成功");
    } catch (e) {
      showToast("清除缓存成功");
      infoList[2]['leadContent'] = "0M";
      setState(() {});
    } finally {}
  }

  void _getCount() async {
    String cache = await _loadCache();
    print(cache);
    infoList[2]['leadContent'] = cache;
    setState(() {});
  }

  // 加载缓存
  Future<String> _loadCache() async {
    Directory tempDic = await getTemporaryDirectory();
    double value = await _getTotalSizeOfFilesInDir(tempDic);
    return _renderSize(value);
  }

  // 递归方式删除目录
  Future<Null> _delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await _delDir(child);
      }
    }
    await file.delete();
  }

  // 循环计算文件的大小（递归）
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  // 计算大小
  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List list = [];
    List unitArr = list..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    if (size == '0.00') {
      return '0M';
    }
    return size + unitArr[index];
  }
}
