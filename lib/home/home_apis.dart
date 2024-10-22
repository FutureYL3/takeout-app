import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';


import '../dto/personal_info_dto.dart';
import '../utils/common_utils.dart';
import '../welcome/welcome_page.dart';

class HomeApiService {
  final FlutterSecureStorage  secureStorage = const FlutterSecureStorage();
  static const String baseUrl = 'http://114.55.108.97:8080';
  // static const String baseUrl = 'http://47.99.35.140:8080';
  late Dio dio;

  HomeApiService() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    dio = Dio(options);

    // 添加拦截器
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 在请求发送之前检查和添加token
        String? accessToken = await secureStorage.read(key: 'accessToken');
        String? refreshToken = await secureStorage.read(key: 'refreshToken');
        // 如果未登录，跳转到欢迎页面
        
        if (accessToken == null || refreshToken == null) {
          Get.offAll(() => const WelcomePage());
        }

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

  // 0 表示离线，1 表示在线
  // Future<Map<String, dynamic>> updateMyOnlineStatus(bool status, BuildContext ctx) async {
  //   try {
      
  //   } on DioException catch (e) {
  //     showSnackBar('登录失败', e.message!, ContentType.failure, ctx);
  //     return {};
  //   }
  // }


}