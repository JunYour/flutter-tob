import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:tob/entity/address/address_list_entity.dart';
import 'package:tob/entity/address/address_single_entity.dart';
import 'package:tob/entity/bank/bank_account_entity.dart';
import 'package:tob/entity/base_data_entity.dart';
import 'package:tob/entity/base_entity.dart';
import 'package:tob/entity/base_info_entity.dart';
import 'package:tob/entity/business/dealer_type_list_entity.dart';
import 'package:tob/entity/city/city_chose_entity.dart';
import 'package:tob/entity/company_entity.dart';
import 'package:tob/entity/img_entity.dart';
import 'package:tob/entity/notice/notice_count_entity.dart';
import 'package:tob/entity/notice/notice_detail_entity.dart';
import 'package:tob/entity/notice/notice_list_entity.dart';
import 'package:tob/entity/order/order_detail_entity.dart';
import 'package:tob/entity/order/order_list_entity.dart';
import 'package:tob/entity/purchase/purchase_detail_entity.dart';
import 'package:tob/entity/purchase/purchase_file_entity.dart';
import 'package:tob/entity/purchase/purchase_file_image_entity.dart';
import 'package:tob/entity/purchase/purchase_file_list_entity.dart';
import 'package:tob/entity/purchase/purchase_list_entity.dart';
import 'package:tob/entity/purchase/purchase_num_entity.dart';
import 'package:tob/entity/purchase/purchase_pre_entity.dart';
import 'package:tob/entity/purchase/purchase_receive_entity.dart';
import 'package:tob/entity/purchase/purchase_receive_list_entity.dart';
import 'package:tob/entity/purchase/purchase_submit_entity.dart';
import 'package:tob/entity/sms_entity.dart';
import 'package:tob/entity/home_data_entity.dart';
import 'package:tob/entity/staff/apply_list_entity.dart';
import 'package:tob/entity/staff/staff_list_entity.dart';
import 'package:tob/entity/tab_purchase/car_file_detail_entity.dart';
import 'package:tob/entity/tab_purchase/car_file_list_entity.dart';
import 'package:tob/entity/tab_purchase/car_order_detail_entity.dart';
import 'package:tob/entity/tab_purchase/car_order_list_entity.dart';
import 'package:tob/entity/tab_purchase/car_pre_order_entity.dart';
import 'package:tob/entity/tab_purchase/car_receive_detail_entity.dart';
import 'package:tob/entity/tab_purchase/car_receive_list_entity.dart';
import 'package:tob/entity/tab_purchase/contract_entity.dart';
import 'package:tob/entity/tab_purchase/tab_purchase_list_entity.dart';
import 'package:tob/entity/tab_purchase/car_file_image_entity.dart';
import 'package:tob/entity/update/update_entity.dart';
import 'package:tob/entity/user_info_entity.dart';
import 'package:tob/entity/vip/legal_right_entity.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/network/dio_file.dart';

import 'api.dart';
import 'dio_manager.dart';

class Http {
  static Http _instance;

  static Http getInstance() {
    if (_instance == null) {
      _instance = Http();
    }
    return _instance;
  }

  Future<List<BaseDataEntity>> baseData() {
    return DioManager.getInstance().postList<BaseDataEntity>(Api.getBaseData);
  }

  ///获取首页数据
  Future<List<HomeDataEntity>> getHomeData() {
    return DioManager.getInstance()
        .postList<HomeDataEntity>(Api.HOST + "/home/getHome");
  }

  //更新
  Future<UpdateEntity> update() {
    String type = '1'; //ios
    if (Platform.isAndroid) {
      type = '2'; //android
    }
    return DioManager.getInstance()
        .post<UpdateEntity>(Api.update, params: {"type": type});
  }

  //上传图片
  Future<ImgEntity> imgUpload(File image, String type) {
    String filePath = image.path;
    var name =
        filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
    return DioFile.getInstance().upload(
      Api.imgUpload,
      filePath,
      fileName: name,
      queryParameters: {
        "uid": UserInfo.getUserInfoId(),
        "type": type,
      },
    );
  }

  //ocr验证
  Future<BaseEntity> ocr(
      {@required String image,
      @required String type,
      @required String imgType}) {
    return DioManager.getInstance().post<BaseEntity>(Api.uploadOcr,
        params: {"img_url": image, "type": type, "img_type": imgType});
  }

  //上传头像
  Future<BaseEntity> uploadHeaderImage({@required String url}) {
    return DioManager.getInstance().post(Api.updateHeadImage, params: {
      "uid": UserInfo.getUserInfoId(),
      "url": url,
    });
  }

  ///权限转让
  Future<BaseEntity> staffTransfer({@required int id}) {
    return DioManager.getInstance().post(Api.staffTransfer, params: {
      "uid": UserInfo.getUserInfoId(),
      "id": id,
    });
  }

  //邀请链接
  Future<BaseEntity> getInviteLink() {
    return DioManager.getInstance()
        .post(Api.HOST + "/user/inviteLink", params: {
      "uid": UserInfo.getUserInfoId(),
    });
  }

  //企业邀请加入链接
  Future<BaseEntity> getBusInviteLink() {
    return DioManager.getInstance()
        .post(Api.HOST + "/h5invite/createInviteLink", params: {
      "uid": UserInfo.getUserInfoId(),
    });
  }

  //企业重新认证
  Future<BaseEntity> clearBusiness() {
    return DioManager.getInstance()
        .post(Api.HOST + "/business/clearBusiness", params: {
      "uid": UserInfo.getUserInfoId(),
    });
  }

  //获取用户信息
  Future<UserInfoEntity> getUserInfo() {
    return DioManager.getInstance()
        .post<UserInfoEntity>(Api.getUserInfo, params: {
      "uid": UserInfo.getUserInfoId(),
    });
  }

  //获取基础信息
  Future<BaseInfoEntity> getBaseInfoData() {
    return DioManager.getInstance().post<BaseInfoEntity>(Api.getBaseInfoData);
  }

  //获取会员客服联系电话
  Future<BaseEntity> getConnectMobile() {
    return DioManager.getInstance().post<BaseEntity>(Api.getConnectMobile);
  }

  //-------------------登录-----------------
  //登录
  Future<UserInfoEntity> login(String mobile, String regId) {
    return DioManager.getInstance().post<UserInfoEntity>(Api.login, params: {
      "mobile": mobile,
      "regid": regId,
    });
  }

  //密码登录
  Future<UserInfoEntity> passLogin(
      String mobile, String password, String regId) {
    return DioManager.getInstance()
        .post<UserInfoEntity>(Api.passLogin, params: {
      "mobile": mobile,
      "password": password,
      "regid": regId,
    });
  }

  //找回密码
  Future<UserInfoEntity> findPass(
      String mobile, String password, String conPass, String regId) {
    return DioManager.getInstance().post<UserInfoEntity>(Api.findPass, params: {
      "mobile": mobile,
      "password": password,
      "conPass": conPass,
      "regId": regId
    });
  }

  //修改密码
  Future<BaseEntity> updPass(String password, String conPass) {
    return DioManager.getInstance().post<BaseEntity>(Api.updPass, params: {
      "uid": UserInfo.getUserInfoId(),
      "oldPass": password,
      "newPass": conPass,
    });
  }

  //注册
  Future<UserInfoEntity> register(
      String mobile, String password, String conPass, String regId) {
    return DioManager.getInstance().post<UserInfoEntity>(Api.register, params: {
      "mobile": mobile,
      "password": password,
      "conPass": conPass,
      "regId": regId
    });
  }

  //发送短信
  Future<SmsEntity> smsSend(String mobile, String type) {
    return DioManager.getInstance().post<SmsEntity>(Api.sms, params: {
      "phone": mobile,
      "type": type,
    });
  }

  /// 验证验证码
  Future<BaseEntity> smsVerify(String phone, String code, String bizId) {
    return DioManager.getInstance().post<BaseEntity>(Api.smsCode, params: {
      "biz_id": bizId,
      "phone": phone,
      "code": code,
    });
  }

  //手机号验证
  Future<BaseEntity> phoneVerify(String mobile,{int userId}) {
    return DioManager.getInstance().post<BaseEntity>(Api.phoneVerify, params: {
      "mobile": mobile,
      "userId": userId,
    });
  }

  //------------------个人中心------------------
  //获取企业信息
  Future<CompanyEntity> getCompany() {
    return DioManager.getInstance().post<CompanyEntity>(Api.company, params: {
      "uid": UserInfo.getUserInfoId(),
    });
  }

  //修改手机号
  Future<BaseEntity> updPhone(String mobile) {
    return DioManager.getInstance().post<BaseEntity>(Api.updPhone, params: {
      "uid": UserInfo.getUserInfoId(),
      "mobile": mobile,
    });
  }

  //获取会员权益列表
  Future<List<LegalRightEntity>> legalRightList() {
    return DioManager.getInstance()
        .postList<LegalRightEntity>(Api.legalRightList);
  }

  //--------------------地址--------------------------

  //地址列表
  Future<AddressListEntity> addressList(
      {@required int page, @required int limit}) {
    return DioManager.getInstance()
        .post<AddressListEntity>(Api.addressList, params: {
      "uid": UserInfo.getUserInfoId(),
      "page": page,
      "limit": limit,
    });
  }

  //新增地址
  Future<BaseEntity> addAddress({
    @required String name,
    @required String idNum,
    @required String mobile,
    @required String city,
    @required String address,
    @required String imageUrl,
  }) {
    return DioManager.getInstance().post<BaseEntity>(Api.addAddress, params: {
      "uid": UserInfo.getUserInfoId(),
      "name": name,
      "idnum": idNum,
      "mobile": mobile,
      "city": city,
      "address": address,
      "image_url": imageUrl,
    });
  }

  //编辑地址
  Future<BaseEntity> modifyAddress({
    @required String name,
    @required String idNum,
    @required String mobile,
    @required String city,
    @required String address,
    @required String imageUrl,
    @required int rid,
  }) {
    return DioManager.getInstance()
        .post<BaseEntity>(Api.modifyAddress, params: {
      "uid": UserInfo.getUserInfoId(),
      "name": name,
      "idnum": idNum,
      "mobile": mobile,
      "city": city,
      "address": address,
      "image_url": imageUrl,
      "rid": rid
    });
  }

  //删除地址
  Future<BaseEntity> deleteAddress({@required int rid}) {
    return DioManager.getInstance()
        .post<BaseEntity>(Api.deleteAddress, params: {
      "rid": rid,
    });
  }

  //单个地址
  Future<AddressSingleEntity> singleAddress({@required int rid}) {
    return DioManager.getInstance()
        .post<AddressSingleEntity>(Api.singleAddress, params: {
      "rid": rid,
    });
  }

  ///-------------------------通知公告------------------------
  //消息列表
  Future<NoticeListEntity> noticeList(
      {@required int type, @required int page, @required int limit}) {
    return DioManager.getInstance()
        .post<NoticeListEntity>(Api.noticeList, params: {
      "uid": UserInfo.getUserInfoId(),
      "type": type,
      "page": page,
      "limit": limit,
    });
  }

  //消息详情
  Future<NoticeDetailEntity> noticeDetail({@required int nid}) {
    return DioManager.getInstance()
        .post<NoticeDetailEntity>(Api.noticeDetail, params: {
      "nid": nid,
    });
  }

  //设置已读
  Future<BaseEntity> noticeSetread({@required int nid, @required int type}) {
    return DioManager.getInstance()
        .post<BaseEntity>(Api.noticeSetread, params: {
      "nid": nid,
      "uid": UserInfo.getUserInfoId(),
      "type": type,
    });
  }

  ///获取未读数
  Future<NoticeCountEntity> noticeCount() {
    return DioManager.getInstance()
        .post<NoticeCountEntity>(Api.noticeCount, params: {
      "uid": UserInfo.getUserInfoId(),
    });
  }

  //---------------订单--------------------
  //订单列表
  Future<OrderListEntity> orderList(
      {@required int status, @required int page, @required int limit}) {
    return DioManager.getInstance().post<OrderListEntity>(Api.orderList,
        params: {
          "uid": UserInfo.getUserInfoId(),
          "status": status,
          "page": page,
          "limit": limit
        });
  }

  //订单详情
  Future<OrderDetailEntity> orderDetail({@required int id}) {
    return DioManager.getInstance()
        .post<OrderDetailEntity>(Api.orderDetail, params: {
      "id": id,
    });
  }

  //采购单列表
  Future<PurchaseListEntity> purchaseList(
      {@required int oid,
      @required int status,
      @required int page,
      @required int limit}) {
    return DioManager.getInstance().post<PurchaseListEntity>(Api.purchaseList,
        params: {"oid": oid, "status": status, "page": page, "limit": limit});
  }

  //预采购列表
  Future<List<PurchasePreEntity>> purchasePre({@required int oid}) {
    return DioManager.getInstance()
        .postList<PurchasePreEntity>(Api.purchasePre, params: {
      "oid": oid,
    });
  }

  //查看订单应采等数据
  Future<PurchaseNumEntity> purchaseNum({@required int oid}) {
    return DioManager.getInstance()
        .post<PurchaseNumEntity>(Api.purchaseNum, params: {
      "oid": oid,
    });
  }

  //发起采购
  Future<PurchaseSubmitEntity> purchaseDo({
    @required int oid,
    @required int count,
    @required double price,
    @required int rid,
    @required String data,
    String remarks,
  }) {
    return DioManager.getInstance()
        .post<PurchaseSubmitEntity>(Api.purchaseDo, params: {
      "oid": oid,
      "uid": UserInfo.getUserInfoId(),
      "count": count,
      "price": price,
      "rid": rid,
      "data": data,
      "remarks": remarks
    });
  }

  //编辑采购
  Future<PurchaseSubmitEntity> purchaseEdit({
    @required int pid,
    @required int count,
    @required double price,
    @required int rid,
    @required String data,
    String remarks,
  }) {
    return DioManager.getInstance()
        .post<PurchaseSubmitEntity>(Api.purchaseEdit, params: {
      "pid": pid,
      "uid": UserInfo.getUserInfoId(),
      "count": count,
      "price": price,
      "rid": rid,
      "data": data,
      "remarks": remarks
    });
  }

  /// 采购详情
  Future<PurchaseDetailEntity> purchaseDetail({@required int id}) {
    return DioManager.getInstance()
        .post<PurchaseDetailEntity>(Api.purchaseDetail, params: {
      "id": id,
    });
  }

  //上传支付凭证
  Future<BaseEntity> purchaseUpload({@required int pid, @required String url}) {
    return DioManager.getInstance()
        .post<BaseEntity>(Api.purchaseUpload, params: {
      "pid": pid,
      "url": url,
      "uid": UserInfo.getUserInfoId(),
    });
  }

  //根据采购单查看收车单列表
  Future<PurchaseReceiveListEntity> purchaseGetReceiveList(
      {@required int pid, @required int page, @required int limit}) {
    return DioManager.getInstance()
        .post<PurchaseReceiveListEntity>(Api.purchaseGetReceiveList, params: {
      "pid": pid,
      "page": page,
      "limit": limit,
    });
  }

  //查看单个收车单
  Future<PurchaseReceiveEntity> purchaseGetReceive({@required int rid}) {
    return DioManager.getInstance()
        .post<PurchaseReceiveEntity>(Api.purchaseGetReceive, params: {
      "rid": rid,
    });
  }

  Future<BaseEntity> purchaseCancel({@required int pid}) {
    return DioManager.getInstance()
        .post<BaseEntity>(Api.purchaseCancel, params: {
      "pid": pid,
    });
  }

  //上传收车单
  Future<BaseEntity> purchaseUploadReceive(
      {@required int pid,
      @required int count,
      @required String url,
      int rid = 0}) {
    return DioManager.getInstance().post<BaseEntity>(Api.purchaseUploadReceive,
        params: {"pid": pid, "count": count, "url": url, "rid": rid});
  }

  //删除收车
  Future<BaseEntity> purchaseDeleteReceive({@required int rid}) {
    return DioManager.getInstance()
        .post<BaseEntity>(Api.purchaseDeleteReceive, params: {
      "rid": rid,
    });
  }

  //资料列表
  Future<List<PurchaseFileListEntity>> purchaseFileList(
      {@required int pid, String vin}) {
    return DioManager.getInstance().postList<PurchaseFileListEntity>(
        Api.purchaseFileList,
        params: {"pid": pid, "vin": vin});
  }

  //资料查看
  Future<PurchaseFileEntity> purchaseFile({@required int vid}) {
    return DioManager.getInstance()
        .post<PurchaseFileEntity>(Api.purchaseFileCheck, params: {
      "vid": vid,
    });
  }

  //资料上传
  Future<PurchaseFileEntity> purchaseFileUpload({
    @required int vid,
    @required String name,
    @required String mobile,
    @required String vFUrl,
    @required String vBUrl,
    @required String cUrl,
    @required String iUrl,
    @required String idCardFUrl,
    @required String idCardBUrl,
    @required String certUrl,
    @required String code,
    @required type,
    int aid,
    String businessImage,
    String businessMobile,
    String businessCode,
    String businessName,
    String fileImage,
  }) {
    return DioManager.getInstance()
        .post<PurchaseFileEntity>(Api.purchaseFileUpload, params: {
      "vid": vid,
      "aid": aid,
      "name": name,
      "mobile": mobile,
      "v_f_url": vFUrl,
      "v_b_url": vBUrl,
      "c_url": cUrl,
      "i_url": iUrl,
      "idcard_f_url": idCardFUrl,
      "idcard_b_url": idCardBUrl,
      "cert_url": certUrl,
      "idcard_code": code,
      "businessImage": businessImage,
      "businessMobile": businessMobile,
      "businessCode": businessCode,
      "type": type,
      "fileImage": fileImage,
    });
  }

  //-----------------------------------------------------------------------------------------------------认证管理
  //实名认证
  Future<BaseEntity> businessRealName(
      {@required String name,
      @required String imageZ,
      @required String imageF,
      @required String code,
      @required String date,
      @required String sex}) {
    return DioManager.getInstance()
        .post<BaseEntity>(Api.businessRealName, params: {
      "uid": UserInfo.getUserInfoId(),
      "name": name,
      "imageZ": imageZ,
      "imageF": imageF,
      "code": code,
      "date": date,
      "sex": sex,
    });
  }

  //经销商类型列表
  Future<List<DealerTypeListEntity>> dealerTypeList() {
    return DioManager.getInstance()
        .postList<DealerTypeListEntity>(Api.businessDealerTypeList);
  }

  //企业认证
  Future<BaseEntity> businessAuth({
    @required String image,
    @required String name,
    @required String creditCode,
    @required String openTerm,
    @required String legalImageZ,
    @required String legalImageF,
    @required String legal,
    @required String legalIdCardCode,
    @required String startTime,
    @required String legalIdCardDate,
    @required int typeId,
  }) {
    return DioManager.getInstance().post<BaseEntity>(Api.businessAuth, params: {
      "image": image,
      "name": name,
      "code": creditCode,
      "term": openTerm,
      "legalImageZ": legalImageZ,
      "legalImageF": legalImageF,
      "legal": legal,
      "legalCode": legalIdCardCode,
      "start_time": startTime,
      "legalIdCardDate": legalIdCardDate,
      "typeId": typeId,
      "uid": UserInfo.getUserInfoId(),
    });
  }

  //申请加入企业
  Future<BaseEntity> businessApply({@required int bid}) {
    return DioManager.getInstance()
        .post<BaseEntity>(Api.businessApply, params: {
      "uid": UserInfo.getUserInfoId(),
      "bid": bid,
    });
  }

  //获取企业信息
  Future<UserInfoDealer> businessInfo({@required int bid}) {
    return DioManager.getInstance()
        .post<UserInfoDealer>(Api.businessInfo, params: {
      "bid": bid,
    });
  }

  //修改企业信息
  Future<BaseEntity> businessUpdate(
      {@required int bid,
      String taxNum,
      String city,
      String address,
      String tele,
      String bankName,
      String bankCode,
      String startTime}) {
    return DioManager.getInstance()
        .post<BaseEntity>(Api.businessUpdate, params: {
      "bid": bid,
      "taxNum": taxNum,
      "city": city,
      "address": address,
      "tele": tele,
      "bankName": bankName,
      "bankCode": bankCode,
      "startTime": startTime
    });
  }

  //----------------------------------------------------------------------------------------------------员工管理
  //员工列表
  Future<StaffListEntity> staffList(
      {@required int page,
      @required int limit,
      @required int bid,
      String keyWord}) {
    return DioManager.getInstance()
        .post<StaffListEntity>(Api.staffList, params: {
      "page": page,
      "limit": limit,
      "bid": bid,
      "keyWord": keyWord,
    });
  }

  ///员工申请数量数据
  Future<BaseEntity> staffApplyCount({@required int bid}) {
    return DioManager.getInstance()
        .post<BaseEntity>(Api.getStaffApplyCount, params: {"bid": bid});
  }

  ///选择城市数据
  Future<List<CityChoseEntity>> getChoseCity() {
    return DioManager.getInstance().postList<CityChoseEntity>(Api.getChoseCity);
  }

  //删除员工
  Future<BaseEntity> staffDelete({@required int id}) {
    return DioManager.getInstance().post<BaseEntity>(Api.staffDelete, params: {
      "id": id,
    });
  }

  //申请列表
  Future<ApplyListEntity> applyList(
      {@required int page, @required int limit, @required int bid}) {
    return DioManager.getInstance()
        .post<ApplyListEntity>(Api.applyList, params: {
      "page": page,
      "limit": limit,
      "bid": bid,
    });
  }

  //同意申请
  Future<BaseEntity> applyAgree({
    @required int id,
  }) {
    return DioManager.getInstance().post<BaseEntity>(Api.applyAgree, params: {
      "id": id,
    });
  }

  //拒绝申请
  Future<BaseEntity> applyRefuse({
    @required int id,
  }) {
    return DioManager.getInstance().post<BaseEntity>(Api.applyRefuse, params: {
      "id": id,
    });
  }

  //清除申请
  Future<BaseEntity> applyClear({
    @required int bid,
  }) {
    return DioManager.getInstance().post<BaseEntity>(Api.applyClear, params: {
      "bid": bid,
    });
  }

  //-----------------------------------------------------------------------------------------------tab 采购
  //车源列表
  Future<TabPurchaseListEntity> tabPurchaseList({
    @required int page,
    @required int limit,
    carName,
    defaultOrder,
    saleArea,
    brandId,
    seriesId,
    specId,
  }) {
    return DioManager.getInstance().post<TabPurchaseListEntity>(
      Api.tabPurchaseList,
      params: {
        "page": page,
        "limit": limit,
        "default": defaultOrder,
        "saleArea": saleArea,
        "brandId": brandId,
        "seriesId": seriesId,
        "specId": specId,
        "carName": carName,
      },
    );
  }

  //车源详情
  Future<TabPurchaseListList> tabPurchaseDetail({@required int id}) {
    return DioManager.getInstance()
        .post<TabPurchaseListList>(Api.tabPurchaseDetail, params: {"id": id});
  }

  //车源预下单
  Future<CarPreOrderEntity> carPreOrder({@required int id}) {
    return DioManager.getInstance()
        .post<CarPreOrderEntity>(Api.carPreOrder, params: {"carId": id});
  }

  //车源下单
  Future<BaseEntity> carOrder(
      {@required int id,
      @required String colors,
      @required int addressId,
      String remark}) {
    return DioManager.getInstance().post<BaseEntity>(Api.carOrder, params: {
      "carId": id,
      "colors": colors,
      "uid": UserInfo.getUserInfoId(),
      "remark": remark,
      "addressId": addressId,
    });
  }

  //车源预下单
  Future<Map<String, dynamic>> getCarArgumentByIdNew({@required int id}) {
    return DioManager.getInstance().post<Map<String, dynamic>>(
        Api.getCarArgumentByIdNew,
        params: {"id": id});
  }

  //车源订单列表
  Future<CarOrderListEntity> carOrderList(
      {@required int page, @required int limit, int status}) {
    return DioManager.getInstance().post<CarOrderListEntity>(Api.carOrderList,
        params: {
          "uid": UserInfo.getUserInfoId(),
          "page": page,
          "limit": limit,
          "status": status
        });
  }

  //车源订单详情
  Future<CarOrderDetailEntity> carOrderDetail({@required int oid}) {
    return DioManager.getInstance()
        .post<CarOrderDetailEntity>(Api.carOrderDetail, params: {"oid": oid});
  }

  //获取合同
  Future<ContractEntity> getContract({@required int oid}) {
    return DioManager.getInstance()
        .post<ContractEntity>(Api.getContract, params: {"oid": oid});
  }

  //上传合同
  Future<BaseEntity> uploadContract(
      {@required int oid, @required String contractUrils, int contractId}) {
    return DioManager.getInstance().post<BaseEntity>(Api.uploadContract,
        params: {
          "oid": oid,
          "contractUrils": contractUrils,
          "contractId": contractId
        });
  }

  //上传支付凭证
  Future<BaseEntity> uploadVouch({@required int oid, @required String url}) {
    return DioManager.getInstance().post<BaseEntity>(Api.uploadVouch,
        params: {"pid": oid, "uid": UserInfo.getUserInfoId(), "url": url});
  }

  //根据采购单查看收车单列表
  Future<CarReceiveListEntity> carGetReceiveList({
    @required int pid,
    @required int page,
    @required int limit,
  }) {
    return DioManager.getInstance()
        .post<CarReceiveListEntity>(Api.carGetReceiveList, params: {
      "pid": pid,
      "page": page,
      "limit": limit,
    });
  }

  //上传收车单
  Future<BaseEntity> carUploadReceive({
    @required int pid,
    @required int count,
    @required String url,
    int rid,
  }) {
    return DioManager.getInstance().post<BaseEntity>(Api.carUploadReceive,
        params: {"pid": pid, "count": count, "url": url, "rid": rid});
  }

  //查看单个收车单
  Future<CarReceiveDetailEntity> carGetReceive({@required int rid}) {
    return DioManager.getInstance()
        .post<CarReceiveDetailEntity>(Api.carGetReceive, params: {
      "rid": rid,
    });
  }

  //取消订单
  Future<BaseEntity> carOrderCancel({@required int id}) {
    return DioManager.getInstance()
        .post<BaseEntity>(Api.carOrderCancel, params: {
      "pid": id,
    });
  }

  //取消订单
  Future<BankAccountEntity> carGetPayInfo({@required int id}) {
    return DioManager.getInstance()
        .post<BankAccountEntity>(Api.carGetPayInfo, params: {
      "pid": id,
    });
  }

  //删除收车单
  Future<BaseEntity> carDeleteReceive({@required int id}) {
    return DioManager.getInstance()
        .post<BaseEntity>(Api.carDeleteReceive, params: {
      "rid": id,
    });
  }

  //资料列表
  Future<List<CarFileListEntity>> carProfileList(
      {@required int pid, String vin}) {
    return DioManager.getInstance().postList<CarFileListEntity>(
        Api.carProfileList,
        params: {"pid": pid, "vin": vin});
  }

  //资料查看
  Future<CarFileDetailEntity> carProfileDetail({@required int vid}) {
    return DioManager.getInstance()
        .post<CarFileDetailEntity>(Api.carProfileDetail, params: {
      "vid": vid,
    });
  }

  //车源订单删除
  Future<BaseEntity> carOrderDelete({@required int oid}) {
    return DioManager.getInstance()
        .post<BaseEntity>(Api.carOrderDelete, params: {
      "oid": oid,
    });
  }

  //获取需要上传的自定义资料(车源)
  Future<List<CarFileImageEntity>> getImageField({
    @required int pid,
    @required int vinId,
  }) {
    return DioManager.getInstance().postList<CarFileImageEntity>(
        Api.getImageField,
        params: {"pid": pid, "vinId": vinId});
  }

  //获取需要上传的自定义资料(项目)
  Future<List<PurchaseFileImageEntity>> getPurchaseFileImageField({
    @required int pid,
    @required int vinId,
  }) {
    return DioManager.getInstance().postList<PurchaseFileImageEntity>(
        Api.getPurchaseFileImageField,
        params: {"pid": pid, "vinId": vinId});
  }

  //资料上传
  Future<BaseEntity> carProfileUpload({
    @required int type,
    @required int vid,
    @required String vFurl,
    @required String vBUrl,
    @required String cUrl,
    @required String iUrl,
    @required String certUrl,
    String businessImage,
    String businessMobile,
    String businessCode,
    String businessName,
    String clientName,
    String clientMobile,
    String idCardFUrl,
    String idCardBUrl,
    String idCardCode,
    int aid,
    String fileImage,
  }) {
    return DioManager.getInstance()
        .post<BaseEntity>(Api.carProfileUpload, params: {
      "vid": vid,
      "v_f_url": vFurl,
      "v_b_url": vBUrl,
      "c_url": cUrl,
      "i_url": iUrl,
      "cert_url": certUrl,
      "businessImage": businessImage,
      "businessMobile": businessMobile,
      "businessCode": businessCode,
      "businessName": businessName,
      "clientName": clientName,
      "clientMobile": clientMobile,
      "idCardFUrl": idCardFUrl,
      "idCardBUrl": idCardBUrl,
      "idCardCode": idCardCode,
      "type": type,
      "aid": aid,
      "fileImage": fileImage
    });
  }
}
