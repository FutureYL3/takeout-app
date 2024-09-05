import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:takeout/utils/common_utils.dart';

import '../dto/personal_info_dto.dart';
import '../welcome/welcome_page.dart';

class PersonalInfoApiService {
  final FlutterSecureStorage  secureStorage = const FlutterSecureStorage();
  static const String baseUrl = 'https://api.example.com';
  late Dio _dio;

  PersonalInfoApiService() {
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
      onRequest: (options, handler) async {
        // 在请求发送之前检查和添加token
        String? accessToken = await secureStorage.read(key: 'accessToken');
        String? refreshToken = await secureStorage.read(key: 'refreshToken');
        // 如果未登录，跳转到欢迎页面
        if (accessToken == null || refreshToken == null) {
          Get.offAll(() => const WelcomePage());
        }
        // TODO: 检查两个token是否过期

        options.headers['token'] = accessToken;
        options.headers['refreshToken'] = refreshToken;
        return handler.next(options); // Continue the request
      },
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
    ));

  }  
  
  Future<Map<String, dynamic>> getPersonalInfo(String phone, BuildContext ctx) async {
    try {
      Response response = await _dio.post('/courier/person_info', queryParameters: {
        'phone': phone,
      });

      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      showSnackBar('获取个人信息失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }

  Future<Map<String, dynamic>> updatePersonalInfo(PersonalInfoDto dto, BuildContext ctx) async {
    try {
      Response response = await _dio.put('/courier/changePersonInfo', data: dto.toJson());

      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      showSnackBar('更新个人信息失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }

  Future<void> uploadImage(PersonalInfoDto dto, BuildContext ctx) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        // 构建 FormData
        FormData formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(image.path),
        });

        // 发送 POST 请求
        Response response = await _dio.post('/courier/setPersonImage', data: formData);

        // 处理响应
        Map<String, dynamic> result = response.data;

        if (result['code'] == 1 && result['data']['isSuccess']) {
          // 上传成功
          dto.imageUrl = result['data']['image'];
          showSnackBar('上传成功', '成功上传了头像', ContentType.success, ctx);
        } else {
          // 上传失败
          showSnackBar('上传失败', result['msg'], ContentType.failure, ctx);
        }
      } on DioException catch (e) {
        // 处理 Dio 的错误并反馈给用户
        showSnackBar('上传失败', 'Failed to upload image: ${e.message}', ContentType.failure, ctx);
      } catch (e) {
        // 处理其他潜在的错误
        showSnackBar('上传失败', 'An unknown error occurred: ${e.toString()}', ContentType.failure, ctx);
      }
    } else {
      // 没有选择图片时的处理
      showSnackBar('未选择图片', '请先选择一张图片再上传', ContentType.warning, ctx);
    }
  }

  Future<Map<String, dynamic>> getBillList(String phone, String dateRange, String like, String type, BuildContext ctx) async {
    try {
      Response response = await _dio.post('/courier/viewEarningsHistory', queryParameters: {
        'phone': phone,
        'dateRange': dateRange,
        'like': like,
        'type': type,
      });

      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      showSnackBar('获取账单失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }

}