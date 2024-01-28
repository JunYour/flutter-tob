import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tob/entity/base_entity.dart';
import 'package:tob/entity/img_entity.dart';
import 'package:tob/generated/json/base/json_convert_content.dart';
import 'package:tob/global/config.dart';
import 'error/dio_error.dart';
import 'my_interceptor.dart';
import 'package:http_parser/http_parser.dart';


/// 上传、下载文件
class DioFile {
  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory DioFile.getInstance() => _getInstance();
  static DioFile _instance;
  Dio _dio;

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  DioFile._internal() {
    // 初始化
    _dio = new Dio();
    _dio.interceptors.add(MyInterceptor());
    _dio.interceptors
        .add(LogInterceptor(responseBody: Config.DEBUG)); //是否开启请求日志
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };
  }

  /// 获取单例内部方法
  static DioFile _getInstance() {
    if (_instance == null) {
      _instance = new DioFile._internal();
    }
    return _instance;
  }

  /// 下载
  Future<Response> download(
    String url,
    String savePath, {
    ProgressCallback progressCallback,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    data,
    Options options,
  }) async {
    return _dio.download(url, savePath,
        onReceiveProgress: progressCallback,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: options);
  }

  /// 上传（单个文件）
  Future<ImgEntity> upload(
    String url,
    String filePath, {
    ProgressCallback progressCallback,
    String fileName,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    int index = filePath.lastIndexOf(".");
    if (index == -1) {
      return Future.error("Known file type!");
    }
    String suffix = filePath.substring(index + 1)?.toLowerCase();
    MediaType mediaType;
    if (suffix == "jpg" ||
        suffix == "png" ||
        suffix == "gif" ||
        suffix == "bmp") {
      mediaType = MediaType("image", suffix);
    }
    Map<String, dynamic> map = {
      "file": await MultipartFile.fromFile(filePath,
          filename: fileName, contentType: mediaType),
    };
    map.addAll(queryParameters);
    print(map);
    var formData = FormData.fromMap(map);
    Response response = await _dio
        .post(
      url,
      data: formData,
      onSendProgress: progressCallback,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    )
        .onError((error, stackTrace) {
      String er = diyDioError(error);
      showToast(er);
      return Future.error(er);
    });
    BaseEntity baseEntity = JsonConvert.fromJsonAsT<BaseEntity>(response.data);
    if (baseEntity.code == 200) {
      ImgEntity imgEntity = JsonConvert.fromJsonAsT<ImgEntity>(baseEntity.data);
      return Future.value(imgEntity);
    } else {
      showToast(baseEntity.msg);
      return Future.error(baseEntity.msg);
    }
  }
}
