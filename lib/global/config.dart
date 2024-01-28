class Config {
  static const PRODUCT = bool.fromEnvironment("dart.vm.product");
  static const bool DEBUG = PRODUCT ? false : true;
  ///oa客服地址
  static const String OACS = "http://oakf.zhekouchecang.com/?m=front&a=chatm&key=6f46eaw242ffa9&khname=";
  //文件上传类型
  /// 支付凭证
  static const String vouch = "vouch";
  /// 身份证
  static const String idCard = "idcard";
  /// 行驶证
  static const String vehicle = "vehicle";
  /// 头像
  static const String profile = "profile";
  /// 收车单
  static const String receive = "receive";
  /// 机动车登记
  static const String carCert = "carcert";
  /// 机动车销售发票
  static const String carInvoice = "carinvoice";
  /// 营业执照
  static const String business = "business";
  /// 合同
  static const String contract = "contract";
  /// Dynamic
  static const String dynamic = "dynamic";
}

