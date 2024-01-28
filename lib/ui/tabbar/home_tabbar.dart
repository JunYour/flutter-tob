import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:jmlink_flutter_plugin/jmlink_flutter_plugin.dart';
import 'package:tob/bloc/tab/switch_tag_bloc.dart';
import 'package:tob/bloc/tab/switch_tag_event.dart';
import 'package:tob/bloc/tab/switch_tag_state.dart';
import 'package:tob/bloc/userInfo/user_info_bloc.dart';
import 'package:tob/entity/base_data_entity.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/main.dart';
import 'package:tob/network/http.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'package:tob/ui/index/index.dart';
import 'package:tob/ui/order/order.dart';
import 'package:tob/ui/purchase/list.dart';
import 'package:tob/ui/user/user.dart';
import 'package:tob/util/common_util.dart';
import 'package:tob/widget/update_overlay_util.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeTabBar extends StatefulWidget {
  @override
  _HomeTabBarState createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> {
  int _selectedIndex = 0;

  var pageList = [
    IndexPage(),
    PurchaseListTabPage(),
    OrderPage(),
    UserPage(),
  ];

  PageController _pageController = PageController();

  Widget getTitle(String title, int index) {
    return _selectedIndex == index
        ? Text(
            title,
            style: TextStyle(
              color: ColorConfig.themeColor,
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
            ),
          )
        : Text(
            title,
            style: TextStyle(
              color: ColorConfig.themeColor[100],
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
            ),
          );
  }

  @override
  void initState() {
    Http.getInstance().update().then((value) {
       print(value);
      if (value != null) {
        UpdateOverlayUtil.show(context: context, updateEntity: value);
      } else {
        // JmlinkFlutterPlugin.instance.registerJMLinkDefaultHandler();
        // JmlinkFlutterPlugin.instance.addDefaultHandlerListener((jsonMap) {
        //   Map map = jsonMap;
        //   if (map["page"] != null) {
        //     BuildContext context = navigatorKey.currentState.context;
        //     navTo(context, map["page"]);
        //   }
        // });
      }
    }).catchError((val) {
      print(val);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwitchTagBloc, SwitchTagState>(
        builder: (context, state) {
      if (state is JustSwitchTagState) {
        Future.delayed(Duration.zero).then((value) {
          if (state != null) {
            _selectedIndex = state.index;
            _pageController.jumpToPage(state.index);
            if(state.index==3){
              Http.getInstance().getUserInfo().then((value) {
                UserInfo.setUserInfo(value);
                BlocProvider.of<UserInfoBloc>(context).add(UserStateEvent());
              });
            }
            if (state.toOrder == true && CommonUtil.checkClick(needTime: 1)==true) {
              navTo(context, Routes.userOrderManager).then((value) {
                BlocProvider.of<SwitchTagBloc>(context).add(
                  JustSwitchTagEvent(3, toOrder: false),
                );
              });
            }
          }
        });
      }
      return Scaffold(
        body: PageView.builder(
          itemBuilder: (context, index) => pageList[index],
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: _pageChanged,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/index_no.png",
                  width: 50.w,
                  height: 50.w,
                ),
                activeIcon: Image.asset(
                  "assets/index_sel.png",
                  width: 50.w,
                  height: 50.w,
                ),
                // ignore: deprecated_member_use
                title: getTitle("首页", 0)),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/purchase_no.png",
                  width: 50.w,
                  height: 50.w,
                ),
                activeIcon: Image.asset(
                  "assets/purchase_sel.png",
                  width: 50.w,
                  height: 50.w,
                ),
                // ignore: deprecated_member_use
                title: getTitle("采购", 1)),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/pro_no.png",
                  width: 50.w,
                  height: 50.w,
                ),
                activeIcon: Image.asset(
                  "assets/pro_sel.png",
                  width: 50.w,
                  height: 50.w,
                ),
                // ignore: deprecated_member_use
                title: getTitle("项目管理", 2)),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/my_no.png",
                  width: 50.w,
                  height: 50.w,
                ),
                activeIcon: Image.asset(
                  "assets/my_sel.png",
                  width: 50.w,
                  height: 50.w,
                ),
                // ignore: deprecated_member_use
                title: getTitle("我的", 3)),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.red,
          onTap: (index) {
            //点击底部导航栏按钮就重置从'首页page'的选择项
            // _pageController.jumpToPage(index);
            BlocProvider.of<SwitchTagBloc>(context)
                .add(JustSwitchTagEvent(index, toOrder: false));
          },
        ),
      );
    });
  }

  void _pageChanged(int index) {
    setState(() {
      if (_selectedIndex != index) _selectedIndex = index;
    });
  }
}

class HomeWebView extends StatefulWidget {
  final BaseDataEntity _newTermEntity;

  HomeWebView(this._newTermEntity);

  @override
  _HomeWebViewState createState() => _HomeWebViewState();
}

class _HomeWebViewState extends State<HomeWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    String base64Content = base64Encode(
        const Utf8Encoder().convert(widget._newTermEntity.content));
    return Container(
      padding: EdgeInsets.only(top: 18.0.w),
      height: 500.w,
      child: WebView(
        initialUrl: 'data:text/html;charset=utf-8;base64,$base64Content',
        javascriptMode: JavascriptMode.unrestricted,
        onWebResourceError: (WebResourceError error) {
          print("error=" + error.toString());
        },
        debuggingEnabled: false,
        onWebViewCreated: (controller) {
          controller
              .loadUrl('data:text/html;charset=utf-8;base64,$base64Content');
          _controller.complete(controller);
        },
      ),
    );
  }
}
