import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utils/common_utils.dart';

class SignUpApiService {
  static const String baseUrl = 'http://114.55.108.97:8080';
  late Dio _dio;

  SignUpApiService() {
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
  Future<Map<String, dynamic>> submit(String phoneNumber, String realName, String validationCode, String password, String collegeId, String idCardNumber, BuildContext ctx) async {
    try {
      Response response = await _dio.post('/courier/register', data: {
        'phoneNumber': phoneNumber,
        'realName': realName,
        'validationCode': validationCode,
        'password': password,
        'collegeId': collegeId,
        'idCardNumber': idCardNumber
      });

      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      showSnackBar('提交失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }

  Future<Map<String, dynamic>> getCollegeList(BuildContext ctx) async {
    try {
      Response response = await _dio.get('/common/getUniversityList');

      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      showSnackBar('提交失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }
}