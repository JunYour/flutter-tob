import 'package:package_info/package_info.dart';
import 'package:sp_util/sp_util.dart';

class App{

  /// 获取版本信息
  static Future<String> getVersionName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// 获取是否同意隐私条款
  static bool hasAcceptLicense() {
    return SpUtil.getBool("hasAcceptLicence");
  }

  /// 设置是否同意隐私条款
  static void setAcceptLicense({bool accept = true}) {
    SpUtil.putBool("hasAcceptLicence", accept);
  }
}