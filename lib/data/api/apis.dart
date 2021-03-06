import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class Apis {
  static String token = '';
  static const mailURL = "http://192.168.100.27:8000/api/v1";
  static const login = '/auth/login';
  static const contact = '/contact_list';
}

Dio getDio() {
  Dio dio = Dio();
  dio.transformer = FlutterTransformer();
  dio.options.headers["Demo-Header"] = "Oversea";
  dio.options.headers["content-type"] = "application/json";
  dio.options.headers[HttpHeaders.authorizationHeader] = "Bearer " + Apis.token;
  dio.interceptors
      .addAll([LogInterceptor(requestBody: true, responseBody: true)]);
  dio.interceptors
      .add(DioCacheManager(CacheConfig(baseUrl: Apis.mailURL)).interceptor);
  return dio;
}
