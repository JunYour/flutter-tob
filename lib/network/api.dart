class Api {
  static const bool inProduction =
      const bool.fromEnvironment("dart.vm.product");
  static const String HOST = inProduction
      ? "http://47.114.42.167:19802"
      : "http://47.114.42.167:19802";

      // : "http://212.64.73.150:9802";

  // : "http://192.168.0.14:9802";
  // : "http://47.114.42.167:19802";

  //车型选择器的地址
  static const String carUrl = "http://47.114.42.167:18307";
  // static const String carUrl = "http://212.64.73.150:9802";

  //云合同的地址
  static const String contractUrl = "https://api.yunhetong.com/api";

  //获取基础数据
  static const String getBaseData = "$HOST/user/bdata";

  //获取基础信息
  static const String getBaseInfoData = "$HOST/home/getBaseData";

  //上传图片
  static const String imgUpload = "$HOST/oss/upload";

  //上传头像
  static const String updateHeadImage = "/user/avatar";

  //ocr
  static const String uploadOcr = "$HOST/user/aliocr";

  //获取用户信息

  static const String getUserInfo = "$HOST/user/getUserInfo";

  ///获取城市选择器
  static const String getChoseCity = "$HOST/city/city";

  ///--------------------------------------------------------------------登录
  //登录
  static const String login = "$HOST/user/login";

  //发送验证码
  static const String sms = "$HOST/sms/send";

  //验证验证码
  static const String smsCode = "$HOST/sms/verify";

  //验证手机号
  static const String phoneVerify = "$HOST/user/verify";

  //更新
  static const String update = "$HOST/home/update";

  //密码登录
  static const String passLogin = "$HOST/user/passLogin";

  //找回密码
  static const String findPass = "$HOST/user/findPass";

  //注册
  static const String register = "$HOST/user/register";

  ///--------------------------------------------------------------------------个人中心
  //查看企业信息
  static const String company = "$HOST/user/companyinfo";

  //修改手机号
  static const String updPhone = "$HOST/user/modifyPhone";

  //修改密码
  static const String updPass = "$HOST/user/updPass";

  //会员权益列表
  static const String legalRightList = "$HOST/vip/legalRightList";

  //会员客服联系电话
  static const String getConnectMobile = "$HOST/vip/getConnectMobile";

  ///-------------------------------------------------------------------------------通知公告
  ///获取列表
  static const String noticeList = "$HOST/notice/list";

  ///获取详情
  static const String noticeDetail = "$HOST/notice/detail";

  ///设置已读
  static const String noticeSetread = "$HOST/notice/setread";

  ///获取未读数
  static const String noticeCount = "$HOST/notice/count";

  ///------------------------------------------------------------------------------------地址
  //列表
  static const String addressList = "$HOST/user/addressList";

  //新增
  static const String addAddress = "$HOST/user/addAddress";

  //编辑
  static const String modifyAddress = "$HOST/user/modifyAddress";

  //删除
  static const String deleteAddress = "$HOST/user/deleteAddress";

  //详情
  static const String singleAddress = "$HOST/user/single";

  ///------------------------------------------------------------------------------------订单
  //订单列表
  static const String orderList = "$HOST/order/list";

  //订单详情
  static const String orderDetail = "$HOST/order/detail";

  //采购单列表
  static const String purchaseList = "$HOST/purchase/list";

  //采购单详情
  static const String purchaseDetail = "$HOST/purchase/detail";

  //采购单预采购数据获取,预采购（获取剩余可采购数量）
  static const String purchasePre = "$HOST/order/pre";

  ///查看订单应采等数据
  static const String purchaseNum = "$HOST/purchase/getCountData";

  //发起采购
  static const String purchaseDo = "$HOST/purchase/do";

  //编辑采购
  static const String purchaseEdit = "$HOST/purchase/edit";

  //取消采购
  static const String purchaseCancel = "$HOST/purchase/cancel";

  //上传支付凭证
  static const String purchaseUpload = "$HOST/purchase/upload";

  //根据采购单查看收车单列表
  static const String purchaseGetReceiveList = "$HOST/purchase/getReceivList";

  //查看单个收车单
  static const String purchaseGetReceive = "$HOST/purchase/getReceiv";

  //上传收车单
  static const String purchaseUploadReceive = "$HOST/purchase/uploadReceiv";

  //删除收车单
  static const String purchaseDeleteReceive = "$HOST/purchase/deleteReceiv";

  //资料列表
  static const String purchaseFileList = "$HOST/profile/list";

  //查看资料
  static const String purchaseFileCheck = "$HOST/profile/check";

  //回传资料
  static const String purchaseFileUpload = "$HOST/profile/upload";

  //获取需要上传的自定义资料(项目)
  static const String getPurchaseFileImageField = "$HOST/profile/getImageField";

  ///------------------------------------------------------------------------------------认证管理
  //实名认证
  static const String businessRealName = "$HOST/business/realName";

  //经销商类型列表
  static const String businessDealerTypeList = "$HOST/business/dealerType";

  //企业认证
  static const String businessAuth = "$HOST/business/auth";

  //申请加入企业
  static const String businessApply = "$HOST/business/apply";

  //获取企业信息
  static const String businessInfo = "$HOST/business/getDealer";

  //修改企业信息
  static const String businessUpdate = "$HOST/business/update";

  ///------------------------------------------------------------------------------------员工管理
  //员工列表
  static const String staffList = "$HOST/staff/list";
  //申请列表
  static const String applyList = "$HOST/staff/applyList";
  //申请同意
  static const String applyAgree = "$HOST/staff/applyAgree";
  //申请拒绝
  static const String applyRefuse = "$HOST/staff/applyRefuse";
  //申请清除
  static const String applyClear = "$HOST/staff/applyClear";
  //申请清除
  static const String getStaffApplyCount = "$HOST/staff/applyCount";
  //删除员工
  static const String staffDelete = "$HOST/staff/delete";
  //权限转让
  static const String staffTransfer = "$HOST/staff/transfer";

  ///----------------------------------------------------------------------------------tab 采购
  //车源列表
  static const String tabPurchaseList = "$HOST/cars/list";
  //车源详情
  static const String tabPurchaseDetail = "$HOST/cars/detail";
  //车源预下单
  static const String carPreOrder = "$HOST/carSourceOrder/preOrder";
  //车源发起采购
  static const String carOrder = "$HOST/carSourceOrder/carOrder";
  //车源配置
  static const String getCarArgumentByIdNew = "$HOST/cars/argument";
  //车源订单列表
  static const String carOrderList = "$HOST/carSourceOrder/carOrderList";
  //车源订单详情
  static const String carOrderDetail = "$HOST/carSourceOrder/carOrderDetail";
  //车源订单取消
  static const String carOrderCancel = "$HOST/carSourceOrder/cancel";
  //车源订单删除
  static const String carOrderDelete = "$HOST/carSourceOrder/deleteOrder";
  //获取合同
  static const String getContract = "$HOST/carSourceOrder/getContract";
  //上传合同
  static const String uploadContract = "$HOST/carSourceOrder/uploadContract";
  //上传支付凭证
  static const String uploadVouch = "$HOST/carSourceOrder/uploadVouch";
  //根据订单id获取收车单
  static const String carGetReceiveList =
      "$HOST/carSourceOrder/getCarReceivList";
  //上传收车单
  static const String carUploadReceive = "$HOST/carSourceOrder/uploadReceive";
  //获取收车单信息
  static const String carGetReceive = "$HOST/carSourceOrder/getReceive";
  //删除收车单
  static const String carDeleteReceive = "$HOST/carSourceOrder/deleteReceive";
  //资料列表
  static const String carProfileList = "$HOST/carProfile/list";
  //资料查看
  static const String carProfileDetail = "$HOST/carProfile/detail";
  //资料上传-新增-修改
  static const String carProfileUpload = "$HOST/carProfile/upload";
  //付款信息获取
  static const String carGetPayInfo = "$HOST/carSourceOrder/getPayInfo";
  //获取需要上传的自定义资料(车源)
  static const String getImageField = "$HOST/carProfile/getImageField";
}
