import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';

import '../utils/common_utils.dart';
import '../welcome/welcome_page.dart';

class OrderManagingApiService {
  final FlutterSecureStorage  secureStorage = const FlutterSecureStorage();
  static const String baseUrl = 'http://114.55.108.97:8080';
  // static const String baseUrl = 'http://47.99.35.140:8080';
  late Dio dio;

  OrderManagingApiService() {
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
        // 在请求发送之前检查和添加tokenstatus
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

  Future<Map<String, dynamic>> getOrders(String phone, DateTime start, DateTime end, int status, String? like, BuildContext ctx) async {
    try {
      // 时间日期格式化为yyyy-MM-dd
      String startDate = DateFormat('yyyy-MM-dd').format(start);
      String endDate = DateFormat('yyyy-MM-dd').format(end);

      Response response = await dio.get('/orders/orders/courier/viewOrder', data: {
        // 'phoneNumber': phone,
        'start': startDate,
        'end': endDate,
        'status': status,
        'like': like,
      });

      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      String tabName = '';
      switch (status) {
        case 1:
          tabName = '待处理';
          break;
        case 2:
          tabName = '已接单';
          break;
        case 3:
          tabName = '配送中';
          break;
        case 4:
          tabName = '已完成';
          break;
        case 5:
          tabName = '已取消';
          break;
      }
      showSnackBar('获取$tabName订单失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }

  Future<Map<String, dynamic>> updateOrders(String phone, String orderId, int updatedStatus, BuildContext ctx) async {
    try {
      Response response = await dio.put('/orders/courier/orderUpdate', data: {
        // 'phoneNumber': phone,
        'orderId': orderId,
        'newStatus': updatedStatus,
      });

      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      showSnackBar('更新订单$orderId状态失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }

  Future<Map<String, dynamic>> refreshAccessToken(BuildContext ctx) async {
    // print('尝试刷新token');
    try {
      Response response = await dio.post('/common/newToken/login/');
      // print('成功刷新token');
      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      showSnackBar('刷新令牌失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }


}