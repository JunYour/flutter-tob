import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:tob/entity/purchase/purchase_list_entity.dart';
import 'package:tob/ui/login/login_phone.dart';
import 'package:tob/ui/login/pass_register.dart';
import 'package:tob/ui/order/detail/detail.dart';
import 'package:tob/ui/order/purchase/address/edit.dart';
import 'package:tob/ui/order/purchase/address/list.dart';
import 'package:tob/ui/order/purchase/detail/detail.dart';
import 'package:tob/ui/order/purchase/file/edit.dart';
import 'package:tob/ui/order/purchase/file/list.dart';
import 'package:tob/ui/order/purchase/launch/launch.dart';
import 'package:tob/ui/order/purchase/list.dart';
import 'package:tob/ui/order/purchase/pay/pay_info.dart';
import 'package:tob/ui/order/purchase/received/edit.dart';
import 'package:tob/ui/order/purchase/received/received.dart';
import 'package:tob/ui/purchase/detail/argument.dart';
import 'package:tob/ui/purchase/detail/detail.dart';
import 'package:tob/ui/purchase/launch/index.dart';
import 'package:tob/ui/purchase/launch/success.dart';
import 'package:tob/ui/purchase/saleArea/saleArea.dart';
import 'package:tob/ui/tabbar/home_tabbar.dart';
import 'package:tob/ui/user/company/information.dart';
import 'package:tob/ui/user/member/member.dart';
import 'package:tob/ui/user/message/message.dart';
import 'package:tob/ui/user/order/constract/contract.dart';
import 'package:tob/ui/user/order/file/edit.dart';
import 'package:tob/ui/user/order/file/list.dart';
import 'package:tob/ui/user/order/order_detail.dart';
import 'package:tob/ui/user/order/order_manager.dart';
import 'package:tob/ui/user/order/pay/pay_info.dart';
import 'package:tob/ui/user/order/received/edit.dart';
import 'package:tob/ui/user/order/received/received.dart';
import 'package:tob/ui/user/set/set.dart';
import 'package:tob/ui/user/set/upd_password/upd_password.dart';
import 'package:tob/ui/user/set/upd_phone/upd_phone.dart';
import 'package:tob/ui/user/staff/examine.dart';
import 'package:tob/ui/user/staff/list.dart';
import 'package:tob/ui/user/staff/manage.dart';
import 'package:tob/ui/user/staff/pre_transfer.dart';
import 'package:tob/ui/user/staff/transfer.dart';
import 'package:tob/ui/user/vertify/company/company_verify.dart';
import 'package:tob/ui/user/vertify/company/company_verify_info.dart';
import 'package:tob/ui/user/vertify/company/reverify.dart';
import 'package:tob/ui/user/vertify/index.dart';
import 'package:tob/ui/user/vertify/user/user_verify.dart';
import 'package:tob/ui/user/vertify/user/user_verify_info.dart';
import 'package:tob/ui/user/vertify/verify_success.dart';
import 'package:tob/widget/image_show.dart';
import 'package:tob/widget/webview/view.dart';

//其他
///通用WebView
var webViewHandler = Handler(handlerFunc: (context, params) {
  return WebViewPage(
    title: params["title"]?.first,
    url: params["url"]?.first,
  );
});

//首页
var homeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return HomeTabBar();
});

/*
 * -------------------------------------------登录
 */
var loginPhoneHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      var tempData = params['back']?.first;
      bool back = false;
      if(tempData=="true"){
        back = true;
      }
  return LoginPhonePage(back:back,);
});



var passRegisterHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return PassRegisterPage(
    type: int.parse(params['type']?.first),
  );
});

/*
 * -------------------------------------------个人中心
 */
//公告-通知
var messageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MessagePage(
    type:
        params['type']?.first != null ? int.parse(params['type']?.first) : null,
  );
});
//设置
var setHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SetPage();
});
//企业信息
var informationHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return InformationPage();
});



//修改密码
var updPasswordHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return UpdPasswordPage();
});
//更换手机号
var updPhoneHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return UpdPhonePage();
});
var memberHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MemberPage();
});
/*
 * -------------------------------------------订单
 */
//订单详情
var orderDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return OrderDetailPage(
    id: int.parse(params['id']?.first),
  );
});
//采购管理
var purchaseListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return PurchaseListPage(
    oid: int.parse(params['oid']?.first),
    countSum: int.parse(params['countSum']?.first),
    count: int.parse(params['count']?.first),
    status: int.parse(params['status']?.first),
  );
});
//采购详情
var purchaseDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return PurchaseDetailPage(
    pid: int.parse(params['pid']?.first),
    oid: int.parse(params['oid']?.first),
  );
});
//发起采购
var launchPurchaseHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String purchaseListListStr = params['purchaseListList']?.first;
  PurchaseListList purchaseListList;
  print(purchaseListListStr);
  if (purchaseListListStr != null) {
    purchaseListList =
        PurchaseListList().fromJson(jsonDecode(purchaseListListStr));
  }
  return LaunchPurchasePage(
    oid: int.parse(params['oid']?.first),
    purchaseListList: purchaseListList,
  );
});
//合同预览
var photoPreviewHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return PhotoPreview(
    galleryItems: params['list']?.toList(),
    defaultImage: 0,
  );
});
//付款信息
var payInfoPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return PayInfoPage(
    pid: int.parse(params['pid']?.first),
    image: params['img']?.first,
    type: params['type']?.first,
    error: params['error']?.first,
  );
});
//确认收车
var receivedCarHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ReceivedCarPage(
    pid: int.parse(params['pid']?.first),
  );
});
//确认收车-上传-重新上传
var receivedEditHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ReceivedEditPage(
    id: int.parse(params['id']?.first),
    can: int.parse(params['can']?.first),
    should: int.parse(params['should']?.first),
    all: int.parse(params['all']?.first),
    pid: int.parse(params['pid']?.first),
  );
});
//资料列表
var fileListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return FileListPage(
    pid: int.parse(params['pid']?.first),
  );
});
//资料-上传-编辑
var fileEditHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return FileEditPage(
    vid: int.parse(params['vid']?.first),
    colorName: params['colorName']?.first,
    vin: params['vin']?.first,
    pid:params['pid']?.first
  );
});

/*
 *---------------------------------------------------------地址
 */
//地址列表
var addressListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AddressListPage(type:params['type']?.first);
});
//地址新增-编辑
var addressEditHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String idStr = params['id']?.first;
    int id = 0;
    if (idStr != null && idStr != "") {
      id = int.parse(idStr);
    }
    return AddressEditPage(
      id: id,
    );
  },
);

/*
 *----------------------------------------员工
 */
//员工列表
var staffListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return StaffListPage();
});
//员工管理
var staffManageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return StaffManagePage();
});
//员工审核
var staffExamineHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return StaffExaminePage();
});
var staffTransferHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return StaffTransferPage(
    id: int.parse(params['id']?.first),
  );
});
var staffPreTransferHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return StaffPreTransfer();
});

/*
 *----------------------------------------认证
 */
//认证页面
var verifyIndexHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return VerifyIndexPage();
});
//实名-未认证
var userVerifyHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return UserVerifyPage();
});
//实名-已认证
var userVerifyInfoHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return UserVerifyInfoPage();
});
//企业-未认证
var companyVerifyHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CompanyVerifyPage();
});
//企业-已认证
var companyVerifyInfoHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CompanyVerifyInfoPage(
    bid: int.parse(params["bid"]?.first),
  );
});
//认证成功
var verifySuccessInfoHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return VerifySuccess(
    type: int.parse(params["type"]?.first),
  );
});
//重新认证
var reVerifyHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ReVerifyPage();
});

/*
 * --------------------------------用户订单
 */
//订单管理
var userOrderManagerHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return UserOrderManagerPage();
});
//订单详情
var userOrderDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return UserOrderDetail(
    oid: int.parse(params['oid']?.first),
  );
});
//订单合同
var userOrderContractHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return UserOrderContract(
    oid: int.parse(params['id']?.first),
    type:params["type"]?.first
  );
});

/*
 * -=----------------------------采购tabBar
 */
//车源详情
var purchaseTabDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return PurchaseDetailTabPage(
    id: int.parse(params['id']?.first),
  );
});
//发起采购
var purchaseLaunchHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return PurchaseLaunchPage(
    oid: int.parse(params["oid"]?.first),
  );
});
//发起采购成功
var purchaseSuccessHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return PurchaseSuccess();
});
//销售区域
var saleAreaHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SaleArea();
});
//上传支付凭证
var tabPurchasePayInfoHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return TabPurchasePayInfoPage(
    pid: int.parse(params['pid']?.first),
    image: params['image']?.first,
    type: params['type']?.first,
    error: params['error']?.first,
  );
});

//确认收车
var tabPurchaseReceivedCarHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CarReceivedCarPage(
    pid: int.parse(params['pid']?.first),
  );
});
//确认收车-上传-重新上传
var tabPurchaseReceivedCarEditHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CarReceivedEditPage(
    id: int.parse(params['id']?.first),
    can: int.parse(params['can']?.first),
    should: int.parse(params['should']?.first),
    all: int.parse(params['all']?.first),
    pid: int.parse(params['pid']?.first),
  );
});

//资料列表
var tabPurchaseCarFileListHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CarFileListPage(
    pid: int.parse(params['pid']?.first),
  );
});

//车源配置详情
var carArgumentHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CarArgumentPage(
    id: int.parse(params['id']?.first),
  );
});

//资料-上传-重新上传
var tabPurchaseCarFileEditHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CarFileEditPage(
    pid:params['pid']?.first,
    vid: int.parse(params['vid']?.first),
    colorName: params['colorName']?.first,
    vin: params['vin']?.first,
  );
});
