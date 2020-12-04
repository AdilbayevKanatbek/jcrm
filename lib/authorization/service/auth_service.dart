import 'dart:io';
import 'package:dio/dio.dart';
import 'package:jcrm/authorization/data/entity/AuthResponse.dart';
import 'package:jcrm/general/GeneralUtil.dart';

class AuthService {
  static const BASIC_TOKEN =
      'amNybS1nTGpvNnZUNjplODQ4MzI0NDc5ZjFhNjE1MjVjOTRlNGYxY2MxY2QwMWM1YmRkMTI1MGJlYjE2YjcxZTk3Yjg5ZTdjOWI1Y2Nh';
  String username;
  String password;

  final Dio _dio = Dio(
    BaseOptions(baseUrl: GeneralUtil.BASE_URL),
  );

  Future<AuthResponse> getToken(String username, String password) async {
    var response ;
    _dio.options.headers[HttpHeaders.authorizationHeader] =
        "Basic " + BASIC_TOKEN;
    try {
      response = await _dio.post(
        '',
        queryParameters: {
          "grant_type": "password",
          "username": username,
          "password": password,
        },
      );
    } on DioError catch (e) {
      if(e.response.statusCode == 404){
        print(e.response.statusCode);
      }
    }
    return (response != null && response.data != null)
        ? AuthResponse.fromJson(response.data)
        : null;
  }
}
