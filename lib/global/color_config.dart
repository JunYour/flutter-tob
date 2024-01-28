import 'package:flutter/material.dart';
import 'package:tob/util/materia_color.dart';

class ColorConfig{
  ///主题色
  static MaterialColor themeColor = getMaterialColor(Color(0xff649AFF));
  ///字体整体颜色
  static Color fontColorBlack = Color(0xff242A37);
  ///错误提示颜色
  static Color errColor = Colors.red[300];
  ///取消-关闭-删除的颜色
  static Color cancelColor = Colors.grey[300];
  ///同意-通过的颜色
  static Color sureColor = Colors.green[300];
  ///背景默认颜色
  static Color bgColor = Color(0xffEDEDED);
}