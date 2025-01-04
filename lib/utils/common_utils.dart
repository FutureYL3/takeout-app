import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response;
import 'package:shared_preferences/shared_preferences.dart';

import '../welcome/welcome_page.dart';

class CommonUtilsApiService {
  static const String baseUrl = 'http://114.55.108.97:8080';
  late Dio _dio;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  CommonUtilsApiService() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    _dio = Dio(options);

    // 添加拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      // onRequest: (options, handler) {
      //   // 在请求发送之前做一些处理
      //   print('Request: ${options.method} ${options.path}');
      //   return handler.next(options); // Continue the request
      // },
      // onResponse: (response, handler) {
      //   // 在响应数据返回之前做一些处理
      //   print('Response: ${response.statusCode} ${response.data}');
      //   return handler.next(response); // Continue the response
      // },
      // onError: (DioException e, handler) {
      //   // 在发生错误时做一些处理
      //   print('Error: ${e.response?.statusCode} ${e.message}');
      //   return handler.next(e); // Continue the error
      // },
      onRequest: (options, handler) async {
        // 在请求发送之前检查和添加tokenstatus
        String? accessToken = await secureStorage.read(key: 'accessToken') ?? '';
        String? refreshToken = await secureStorage.read(key: 'refreshToken') ?? '';

        options.headers['token'] = accessToken;
        options.headers['refreshToken'] = refreshToken;
        return handler.next(options); 
      },
      onResponse: (response, handler) {
        // 如果响应是字符串，尝试手动解析
        if (response.data is String) {
          try {
            response.data = jsonDecode(response.data);
          } catch (e) {
            print("Failed to parse response JSON: $e");
          }
        }
        return handler.next(response);
      },
    ));
  }

  Future<Map<String, dynamic>> getValidationCode(String phoneNumber) async {
    try {
      // 发起 GET 请求，并将 phoneNumber 作为参数
      Response response = await _dio.get('/courier/getCaptcha', queryParameters: {
        'phoneNumber': phoneNumber,
      });

      // 返回响应数据
      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      print('Dio Error: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
        print('Response headers: ${e.response?.headers}');
      }
      return {
        'error': true
      };
    }
  }

  Future<Map<String, dynamic>> checkValidationCode(String phoneNumber, String validationCode) async {
    try {
      // 发起 POST 请求，并将 phoneNumber 和 validationCode 作为参数
      Response response = await _dio.put('/courier/findPasswordByValidationCode', data: {
        'phone': phoneNumber,
        'code': validationCode,
        'newPassword': ''
      });

      // 返回响应数据
      return response.data;
    } on DioException {
      // 处理 Dio 的错误
      return {
        'error': true
      };
    }
  }

  Future<Map<String, dynamic>> refreshAccessToken(BuildContext ctx) async {
    // print('尝试刷新token');
    try {
      Response response = await _dio.get('/common/newToken/login');
      // print('成功刷新token');
      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      showSnackBar('刷新令牌失败', e.message!, ContentType.failure, ctx);
      print('刷新令牌失败：${e.message}');
      return {};
    }
  }

}

void showSnackBar(String title, String msg, ContentType type, BuildContext ctx) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: msg,
      contentType: type,
    ),
  );

  ScaffoldMessenger.of(ctx)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void checkForTokenRefresh(Map<String, dynamic> response, BuildContext ctx, Function f) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final CommonUtilsApiService commonUtilsApiService = CommonUtilsApiService();
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  if (response['code'] == 401) {
    Map<String, dynamic> refreshData = await commonUtilsApiService.refreshAccessToken(ctx);
    if (refreshData['code'] == 409) {
      // 如果refreshToken也过期了，要求重新登录
      await secureStorage.deleteAll();
      await prefs.setBool('Login_Status', false);
      Get.offAll(() => const WelcomePage());
      return;
    }
    if (refreshData['code'] == 1) {
      secureStorage.write(key: 'accessToken', value: refreshData['data']['accessToken']);
      secureStorage.write(key: 'refreshToken', value: refreshData['data']['refreshToken']);
    }
    f(); // 重新执行原来的请求
    return;
  }
}
