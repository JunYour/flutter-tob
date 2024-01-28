import 'package:fluwx/fluwx.dart';

class Weixin{
  static initFluWx() async {
    await registerWxApi(
        appId: "wx4f1a200d06e2a2b3",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://bkirm5.jgshare.cn/");
    var result = await isWeChatInstalled;
    print("is installed $result");
  }
}