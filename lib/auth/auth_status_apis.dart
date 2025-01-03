import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utils/common_utils.dart';

class AuthStatusApiService {
  static const String baseUrl = 'http://114.55.108.97:8080';
  late Dio _dio;

  AuthStatusApiService() {
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
  Future<Map<String, dynamic>> query(String phoneNumber, String validationCode, BuildContext ctx) async {
    try {
      Response response = await _dio.post('/xxx', data: {
        'phoneNumber': phoneNumber,
        'validationCode': validationCode,
      });

      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      showSnackBar('提交失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }
}