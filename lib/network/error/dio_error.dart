import 'dart:io';

import 'package:dio/dio.dart';

String diyDioError(DioError error) {
  switch (error.type) {
    case DioErrorType.sendTimeout:
      return "请求超时！";
      break;
    case DioErrorType.connectTimeout:
      return "连接超时！";
      break;
    case DioErrorType.receiveTimeout:
      return "网络不给力！";
      break;
    case DioErrorType.cancel:
      return "请求已取消";
      break;
    case DioErrorType.other:
      if (error.error is SocketException) {
        return "暂时无法连接服务器,请稍后再试！";
      }else {
        return "连接已断开";
      }
      break;
    default:
      return error.toString();
  }
}
