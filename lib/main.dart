import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:fluwx/fluwx.dart';
// import 'package:jmlink_flutter_plugin/jmlink_flutter_plugin.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sp_util/sp_util.dart';
import 'package:tob/bloc/address/address_bloc.dart';
import 'package:tob/bloc/purchase/num/purchase_num_bloc.dart';
import 'package:tob/bloc/purchase/purchase/purchase_detail_bloc.dart';
import 'package:tob/bloc/staff_apply/staff_apply_bloc.dart';
import 'package:tob/entity/user_info_entity.dart';
import 'package:tob/global/app.dart';
import 'package:tob/global/color_config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/route/my_navigator_observer.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/sdk/ji_guang.dart';
import 'package:tob/sdk/weixin.dart';
import 'package:tob/ui/login/login_phone.dart';
import 'package:tob/ui/tabbar/home_tabbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/notice/notice_bloc.dart';
import 'bloc/purchase/list/purchase_list_bloc.dart';
import 'bloc/tab/switch_tag_bloc.dart';
import 'bloc/tab_purchase/tab_purchase_detail_bloc.dart';
import 'bloc/tab_purchase/tab_purchase_list_bloc.dart';
import 'bloc/userInfo/user_info_bloc.dart';
import 'route/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  final router = FluroRouter();
  Routes.configureRoutes(router);
  MyRoute.router = router;

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
  runApp(
    RefreshConfiguration(
      headerBuilder: () => WaterDropHeader(complete: Text('加载完成')),
      footerBuilder: () => CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("上拉加载");
          } else if (mode == LoadStatus.loading) {
            if (Platform.isIOS) {
              body = CupertinoActivityIndicator();
            } else if (Platform.isAndroid) {
              body = CircularProgressIndicator();
            } else {
              body = CupertinoActivityIndicator();
            }
          } else if (mode == LoadStatus.failed) {
            body = Text("加载失败，点击重试");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("加载更多");
          } else {
            body = Text(
              "非常抱歉哦，已经到底啦!",
              style: TextStyle(color: Color(0x99696969), fontSize: 10),
            );
          }
          return Container(
            height: 110.w,
            child: Center(child: body),
          );
        },
      ),
      child: MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
final JPush jpush = JPush();
// final JMLConfig jmlConfig = JMLConfig();

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime pressTimeMills;

  @override
  void initState() {

    super.initState();
    if (App.hasAcceptLicense()) {
      ///极光推送注册
      // JiGuang.initPlatformState();

      ///微信sdk注册
      Weixin.initFluWx();

      ///极光魔链
      // JiGuang.initJml();
    }
  }








  @override
  Widget build(BuildContext context) {
    UserInfoEntity userInfo = UserInfo.getUserInfo();
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserInfoBloc>(
          create: (BuildContext context) => UserInfoBloc(),
        ),
        BlocProvider<AddressBloc>(
          create: (BuildContext context) => AddressBloc(),
        ),
        BlocProvider<PurchaseDetailBloc>(
          create: (BuildContext context) => PurchaseDetailBloc(),
        ),
        BlocProvider<PurchaseNumBloc>(
          create: (BuildContext context) => PurchaseNumBloc(),
        ),
        BlocProvider<PurchaseListBloc>(
          create: (BuildContext context) => PurchaseListBloc(),
        ),
        BlocProvider<NoticeBloc>(
          create: (BuildContext context) => NoticeBloc(),
        ),
        BlocProvider<SwitchTagBloc>(
          create: (BuildContext context) => SwitchTagBloc(),
        ),
        BlocProvider<TabPurchaseListBloc>(
          create: (BuildContext context) => TabPurchaseListBloc(),
        ),
        BlocProvider<TabPurchaseDetailBloc>(
          create: (BuildContext context) => TabPurchaseDetailBloc(),
        ),
        BlocProvider<StaffApplyBloc>(
          create: (BuildContext context) => StaffApplyBloc(),
        ),
      ],
      child: OKToast(
        position: ToastPosition.bottom,
        backgroundColor: Color(0x805C5C5C),
        child: ScreenUtilInit(
          designSize: Size(750, 1334),
          allowFontScaling: false,
          builder: () => MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: Locale('zh', 'CH'),
            navigatorKey: navigatorKey,
            navigatorObservers: [MyNavigatorObserver()],
            localizationsDelegates: [
              RefreshLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [const Locale('zh', 'CH')],
            title: "赶车科技TOB",
            theme: ThemeData(primarySwatch: ColorConfig.themeColor),
            home: WillPopScope(
              child: userInfo==null?LoginPhonePage():HomeTabBar(),
              onWillPop: () {
                if (pressTimeMills == null ||
                    DateTime.now().difference(pressTimeMills) >
                        Duration(seconds: 2)) {
                  pressTimeMills = DateTime.now();
                  showToast("再按一次退出");
                  return Future.value(false);
                }
                return Future.value(true);
              },
            ),
            builder: EasyLoading.init(),
          ),
        ),
      ),
    );
  }


}
