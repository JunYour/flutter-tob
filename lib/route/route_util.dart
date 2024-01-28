import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/routes.dart';

///简化导包地操作
Future navTo(BuildContext context, String path,
    {bool replace = false,
    bool clearStack = false,
    TransitionType transition = TransitionType.cupertino,
    Duration transitionDuration = const Duration(milliseconds: 250),
    RouteTransitionsBuilder transitionBuilder}) {
  //如果是跳转到根目录，清空回退栈
  var isRoot = path == Routes.home;
  //只要有参数，都把？后面的encode一遍，牛皮的是：不需要decode就行，还没仔细去看为什么
  //+1是为了不要encode---？
  int index = path.indexOf("?");
  if (index != -1) {
    String prefix = path.substring(0, index + 1);
    String suffix = path.substring(index + 1);
    String suffixCombine = "";
    var suffixSplit = suffix.split("&");
    for (int i = 0; i < suffixSplit.length; i++) {
      //value大概长这样:title=这是标题
      var value = suffixSplit[i];
      var valueSplit = value.split("=");
      suffixCombine += valueSplit[0] + "=" + Uri.encodeComponent(valueSplit[1]);
      if (i != suffixSplit.length - 1) {
        suffixCombine += "&";
      }
    }
    path = prefix + suffixCombine;
  }
  return MyRoute.router.navigateTo(context, path,
      replace: replace,
      clearStack: isRoot ? true : clearStack,
      transition: transition,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder);
}
