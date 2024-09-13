import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:takeout/utils/common_utils.dart';

class LoginApiService {
  // static const String baseUrl = 'http://114.55.108.97:8080';
  static const String baseUrl = 'http://47.99.35.140:8080';
  late Dio _dio;

  LoginApiService() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    _dio = Dio(options);

  }  
  Future<Map<String, dynamic>> loginWithPwd(String phoneNumber, String password, BuildContext ctx) async {
    try {
      Response response = await _dio.post('/courier/login/password', data: {
        'phoneNumber': phoneNumber,
        'password': password
      });

      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      showSnackBar('登录失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }

  Future<Map<String, dynamic>> loginWithCode(String phoneNumber, String validationCode, BuildContext ctx) async {
    try {
      Response response = await _dio.post('/courier/login/phone', queryParameters: {
        'phoneNumber': phoneNumber,
        'validationCode': validationCode
      });

      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      showSnackBar('登录失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }

  // TODO
  Future<Map<String, dynamic>> resetPassword(String phoneNumber, String password) async {
    try {
      Response response = await _dio.get('/common/phone', queryParameters: {
        'phoneNumber': phoneNumber,
        'password': password
      });

      return response.data;
    } on DioException {
      return {
        'error': true
      };
    }
  }
}