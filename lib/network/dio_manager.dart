import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:tob/entity/base_entity.dart';
import 'package:tob/entity/base_list_entity.dart';
import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/global/address.dart';
import 'package:tob/global/config.dart';
import 'package:tob/global/userInfo.dart';
import 'package:tob/main.dart';
import 'package:tob/route/my_route.dart';
import 'package:tob/route/route_util.dart';
import 'package:tob/route/routes.dart';
import 'my_interceptor.dart';
import 'api.dart';

/*
 * 网络请求管理类
 */
class DioManager {
  //写一个单例
  //在 Dart 里，带下划线开头的变量是私有变量
  static DioManager _instance;

  static DioManager getInstance() {
    if (_instance == null) {
      _instance = DioManager._();
    }
    return _instance;
  }

  Dio dio = new Dio();

  DioManager._() {
    dio.options.baseUrl = Api.HOST;
    dio.options.connectTimeout = 30000;
    dio.options.receiveTimeout = 30000;

    dio.interceptors.add(MyInterceptor());
    dio.interceptors.add(LogInterceptor(
      request: false,
      responseHeader: false,
      responseBody: Config.DEBUG,
      requestBody: Config.DEBUG,
    )); //是否开启请求日志
    // dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded").toString();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      // client.findProxy = (uri) {
      //   return "PROXY 192.168.201.50:8899";
      // };
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };

    // dio.interceptors.add(CookieManager(CookieJar()));//缓存相关类，具体设置见https://github.com/flutterchina/cookie_jar
  }

  ///get请求，返回'经过BaseEntity包装后的实体'
  Future<T> get<T>(String url, {Map<String, dynamic> params}) async {
    return _requestHttp(url, 'get', params).then((res) => handleObj(res));
  }

  ///get请求返回'经过BaseListEntity包装后的列表<实体>'
  Future<List<T>> getList<T>(String url, {Map<String, dynamic> params}) async {
    return _requestHttp(url, 'get', params).then((res) => handleList(res));
  }

  ///post请求，返回'经过BaseEntity包装后的实体'
  Future<T> post<T>(String url, {Map<String, dynamic> params}) async {
    return _requestHttp(url, 'post', params).then((res) => handleObj(res));
  }

  ///post请求返回'经过BaseListEntity包装后的列表<实体>'
  Future<List<T>> postList<T>(String url, {Map<String, dynamic> params}) async {
    return _requestHttp(url, 'post', params).then((res) => handleList(res));
  }

  ///============下面这3个应该用不着了=================
  ///get请求，返回'原始实体'
  Future<T> getOri<T>(String url, Map<String, dynamic> params) async {
    return _requestHttp(url, 'get', params).then((res) => handleObjOri(res));
  }

  ///get请求，返回Map
  Future<T> getMap<T>(String url, {Map<String, dynamic> params}) async {
    return _requestHttp(url, 'get', params).then((res) => handleMap(res));
  }

  Future<T> postMap<T>(String url, {Map<String, dynamic> params}) async {
    return _requestHttp(url, 'post', params).then((res) => handleMap(res));
  }

  ///post请求，返回'原始实体'
  Future<T> postOri<T>(String url, {Map<String, dynamic> params}) async {
    return _requestHttp(url, 'post', params).then((res) => handleObjOri(res));
  }

  ///实际dio请求过程
  Future<Response> _requestHttp(String url,
      [String method, Map<String, dynamic> params]) async {
    var response;
    try {
      if (method == 'get') {
        if (params != null && params.isNotEmpty) {
          response = await dio.get(url, queryParameters: params);
        } else {
          response = await dio.get(url);
        }
      } else if (method == 'post') {
        if (params != null && params.isNotEmpty) {
          response = await dio.post(url, data: params);
        } else {
          response = await dio.post(url);
        }
      }
      return Future.value(response);
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.sendTimeout:
          showToast('请求超时！');
          return Future.error(1);
          break;
        case DioErrorType.connectTimeout:
          showToast('连接超时！');
          return Future.error("连接超时！");
          break;
        case DioErrorType.receiveTimeout:
          showToast('网络不给力！');
          return Future.error("网络不给力！");
          break;
        case DioErrorType.cancel:
          showToast('请求已取消！');
          return Future.error("请求已取消");
          break;
        case DioErrorType.other:
          if (error.error is SocketException) {
            showToast('暂时无法连接服务器,请稍后再试！');
            return Future.error(0);
          }else{
            showToast('连接已断开!');
            return Future.error("连接已断开");
          }
          break;
        default:
          return Future.error(error);
      }
    }
  }

  Future<T> handleMap<T>(Response response) {
    try {
      //有些时候返回的这个是个json字符串，还转义了，导致dio不能识别为map对象，所以得自己手动又搞一遍。
      //比如极验这个接口，返回的就是一个转义后的json字符串。。。
      var map = response.data;
      if (map is String) {
        map = convert.jsonDecode(map);
      }
      return Future.value(map);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<T> handleObjOri<T>(Response response) {
    try {
      //有些时候返回的这个是个json字符串，还转义了，导致dio不能识别为map对象，所以得自己手动又搞一遍。
      //比如极验这个接口，返回的就是一个转义后的json字符串。。。
      var map = response.data;
      if (map is String) {
        map = convert.jsonDecode(map);
      }
      var entity = JsonConvert.fromJsonAsT<T>(map);
      return Future.value(entity);
    } catch (error) {
      return Future.error(error);
    }
  }

  ///处理如果返回值是'实体'的时候
  Future<T> handleObj<T>(Response response) {
    try {
      var baseEntity = JsonConvert.fromJsonAsT<BaseEntity>(response.data);
      if (baseEntity.code !=200) {
        if(baseEntity.code==501){
          tokenError();
          return Future.error(baseEntity.msg);
        } else if(baseEntity.code==502){
          showToast(baseEntity.msg);
          UserInfo.clearUserInfo();
          Address.clearAddress();
          BuildContext buildContext = navigatorKey.currentState.overlay.context;
          navTo(buildContext, Routes.loginPhone,clearStack: true,replace: true);
        }else{
          showToast(baseEntity.msg);
          return Future.error(baseEntity.msg);
        }
      } else {
        if (T == BaseEntity) {
          return Future.value(baseEntity as T);
        }
        if (T.toString().startsWith("Map")) {
          return Future.value(baseEntity.data);
        }
        if (baseEntity.data == null) {
          return Future.value(null);
        } else {
          if (baseEntity.data is String) {
            return Future.value(baseEntity.data);
          }
          return Future.value(JsonConvert.fromJsonAsT<T>(baseEntity.data));
        }
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  ///处理如果返回值是'列表<实体>'的时候
  Future<List<T>> handleList<T>(Response response) {
    var baseListEntity = JsonConvert.fromJsonAsT<BaseListEntity>(response.data);
    if (baseListEntity.code != 200) {
      if(baseListEntity.code==501){
        tokenError();
        return Future.error(baseListEntity.msg);
      } else if(baseListEntity.code==502){
        UserInfo.clearUserInfo();
        Address.clearAddress();
        showToast(baseListEntity.msg);
        BuildContext buildContext = navigatorKey.currentState.overlay.context;
        navTo(buildContext, Routes.loginPhone,clearStack: true,replace: true);
      }else{
        showToast(baseListEntity.msg);
        return Future.error(baseListEntity.msg);
      }
    } else {
      print("true");
      if (baseListEntity.data == null) {
        return Future.value(null);
      } else {
        var result = baseListEntity.data
            .map((i) => JsonConvert.fromJsonAsT<T>(i))
            .toList();
        return Future.value(result);
      }
    }
  }

  /// 修改BaseUrl
  changeBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
  }

  ///token错误-登录过期
 tokenError(){
   showToast("登录过期");
   UserInfo.clearUserInfo();
   Address.clearAddress();
    Future.delayed(Duration(microseconds: 500)).then((value){
      BuildContext context = navigatorKey.currentState.overlay.context;
      MyRoute.router.navigateTo(context, Routes.loginPhone);
    });
  }
}
