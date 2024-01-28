import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:tob/route/route_handlers.dart';
import 'package:tob/ui/tabbar/home_tabbar.dart';

class Routes {

  static String root = "/";

  //首页
  static String home = "home"; //首页

  //其他
  static String webViewPage = "webViewPage"; //html页面

  //登录
  static String loginPhone = "loginPhone"; //手机号登录
  static String passRegister = "passRegister"; //注册和找回密码

  //个人中心
  static String message = "message"; // 公告-通知
  static String set = "set"; //设置
  static String information = "information"; //企业信息
  static String updPassword = "updPassword"; //修改密码
  static String updPhone = "updPhone"; //更换手机号
  static String member = "member";

  //订单
  static String orderDetail = "orderDetail"; //详情
  static String purchaseList = "purchaseList"; //采购列表管理
  static String purchaseDetail = "purchaseDetail"; //采购详情
  static String launchPurchase = "launchPurchase"; //发起采购
  static String photoPreview = "photoPreview"; //合同查看
  static String payInfoPage = "payInfoPage"; //付款信息
  static String receivedCar = "receivedCar"; //确认收车
  static String receivedEdit = "receivedEdit"; //确认收车-上传-重新上传
  static String fileList = "fileList"; //资料列表
  static String fileEdit = "fileEdit"; //资料-上传-编辑
  //地址
  static String addressList = "addressList"; //地址列表
  static String addressEdit = "addressEdit"; //地址新增-编辑
  //员工管理
  static String staffList = "staffList"; //员工列表
  static String staffManage = "staffManage"; //员工管理
  static String staffExamine = "staffExamine"; //审核
  static String staffTransfer = "staffTransfer"; //权限转让
  static String staffPreTransfer = "staffPreTransfer"; //权限转让-选择转让人
  //认证
  static String verifyIndex = "verifyIndex"; //认证
  static String userVerify = "userVerify"; //实名认证(未认证页面)
  static String userVerifyInfo = "userVerifyInfo"; //实名认证(已认证页面)
  static String companyVerify = "companyVerify"; //企业认证(未认证页面)
  static String companyVerifyInfo = "companyVerifyInfo"; //企业认证(已认证页面)
  static String verifySuccess = "verifySuccess"; //认证成功
  static String reVerify = "reVerify"; //重新认证

  //用户订单
  static String userOrderManager = "userOrderManager"; //订单管理
  static String userOrderDetail = "userOrderDetail"; //订单详情
  static String userOrderContract = "userOrderContract"; //订单合同

  //采购-tabBar
  static String tabPurchaseTabDetail = "purchaseTabDetail"; //采购-车型详情
  static String tabPurchaseLaunch = "purchaseLaunch"; //采购-发起采购
  static String tabPurchaseSuccess = "purchaseSuccess"; //采购-发起采购成功
  static String saleArea = "saleArea"; //销售区域
  static String tabPurchasePayInfo = "TabPurchasePayInfo"; //上传支付凭证
  static String tabPurchaseReceivedCar = "tabPurchaseReceivedCar"; //收车单列表
  static String tabPurchaseReceivedCarEdit = "tabPurchaseReceivedCarEdit"; //收车单上传与修改
  static String tabPurchaseCarFileList = "tabPurchaseCarFileList"; //资料列表
  static String tabPurchaseCarFileEdit = "tabPurchaseCarFileEdit"; //资料上传与修改
  static String carArgument = "carArgument"; //车源配置详情

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          print("ROUTE WAS NOT FOUND !!!");
          return HomeTabBar();
        });

    router.define(home, handler: homeHandler);
    //登录
    router.define(loginPhone, handler: loginPhoneHandler);
    router.define(passRegister, handler: passRegisterHandler);

    //个人中心
    router.define(message, handler: messageHandler);
    router.define(set, handler: setHandler);
    router.define(information, handler: informationHandler);
    router.define(updPassword, handler: updPasswordHandler);
    router.define(updPhone, handler: updPhoneHandler);
    router.define(member, handler: memberHandler);


    //订单
    router.define(orderDetail, handler: orderDetailHandler);
    router.define(purchaseList, handler: purchaseListHandler);
    router.define(purchaseDetail, handler: purchaseDetailHandler);
    router.define(launchPurchase, handler: launchPurchaseHandler);
    router.define(photoPreview, handler: photoPreviewHandler);
    router.define(payInfoPage, handler: payInfoPageHandler);
    router.define(receivedCar, handler: receivedCarHandler);
    router.define(receivedEdit, handler: receivedEditHandler);
    router.define(fileList, handler: fileListHandler);
    router.define(fileEdit, handler: fileEditHandler);

    //地址
    router.define(addressList, handler: addressListHandler);
    router.define(addressEdit, handler: addressEditHandler);
    router.define(webViewPage, handler: webViewHandler);
    //员工管理
    router.define(staffList, handler: staffListHandler);
    router.define(staffManage, handler: staffManageHandler);
    router.define(staffExamine, handler: staffExamineHandler);
    router.define(staffTransfer, handler: staffTransferHandler);
    router.define(staffPreTransfer, handler: staffPreTransferHandler);
    //  认证
    router.define(verifyIndex, handler: verifyIndexHandler);
    router.define(userVerify, handler: userVerifyHandler);
    router.define(userVerifyInfo, handler: userVerifyInfoHandler);
    router.define(companyVerify, handler: companyVerifyHandler);
    router.define(companyVerifyInfo, handler: companyVerifyInfoHandler);
    router.define(verifySuccess, handler: verifySuccessInfoHandler);
    router.define(reVerify, handler: reVerifyHandler);

    //用户订单
    router.define(userOrderManager, handler: userOrderManagerHandler);
    router.define(userOrderDetail, handler: userOrderDetailHandler);
    router.define(userOrderContract, handler: userOrderContractHandler);

    // 采购-tabBar
    router.define(tabPurchaseTabDetail, handler: purchaseTabDetailHandler);
    router.define(tabPurchaseLaunch, handler: purchaseLaunchHandler);
    router.define(tabPurchaseSuccess, handler: purchaseSuccessHandler);
    router.define(saleArea, handler: saleAreaHandler);
    router.define(tabPurchasePayInfo, handler: tabPurchasePayInfoHandler);
    router.define(tabPurchaseReceivedCarEdit, handler: tabPurchaseReceivedCarEditHandler);
    router.define(tabPurchaseReceivedCar, handler: tabPurchaseReceivedCarHandler);
    router.define(tabPurchaseCarFileEdit, handler: tabPurchaseCarFileEditHandler);
    router.define(tabPurchaseCarFileList, handler: tabPurchaseCarFileListHandler);
    router.define(carArgument, handler: carArgumentHandler);
  }
}
