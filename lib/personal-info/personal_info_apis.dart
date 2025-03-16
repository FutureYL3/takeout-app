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

class PersonalInfoApiService {
  final FlutterSecureStorage  secureStorage = const FlutterSecureStorage();
  static const String baseUrl = 'https://kangshisudiantong.cn';
  // static const String baseUrl = 'http://47.99.35.140:8080';
  late Dio dio;

  PersonalInfoApiService() {
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

  Future<void> _requestPermissions() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      await Permission.photos.request(); // 请求访问相册权限
    }

    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request(); // 请求相机权限
    }
  }
  
  Future<Map<String, dynamic>> getPersonalInfo(String phone, BuildContext ctx) async {
    try {
      Response response = await dio.get('/courier/person_info', queryParameters: {
        'phone': phone,
      });
      // print(response);
      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      showSnackBar('获取个人信息失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }

  Future<Map<String, dynamic>> getDeliveryArea(String phone, BuildContext ctx) async {
    try {
      Response response = await dio.get('/courier/viewWorkingarea', queryParameters: {
        'phone': phone,
      });
      // print(response);
      print(response.data);
      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      print(e.message);
      showSnackBar('获取配送区域失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }

  Future<Map<String, dynamic>> getPlaces(String id, BuildContext ctx) async {
    try {
      Response response = await dio.get('/common/getPlace/$id');
      // print(response);
      print(response.data);
      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      print(e.message);
      showSnackBar('获取待选区域失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }

  Future<Map<String, dynamic>> updateDeliveryArea(String phone, String location, BuildContext ctx) async {
    try {
      Response response = await dio.put('/courier/updateWorkingarea', data: {
        'phone': phone,
        'location': location,
      });

      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      showSnackBar('更新配送区域信息失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }

  Future<Map<String, dynamic>> updatePersonalInfo(PersonalInfoDto dto, BuildContext ctx) async {
    try {
      Response response = await dio.put('/courier/changePersonInfo', data: dto.toJson());

      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      showSnackBar('更新个人信息失败', e.message!, ContentType.failure, ctx);
      return {};
    }
  }

  Future<void> uploadImage(PersonalInfoDto dto, BuildContext ctx) async {
    await _requestPermissions(); // 请求权限

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        // 构建 FormData
        FormData formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(image.path),
        });
        // print(formData);
        // print(image.path);

        // 发送 POST 请求
        Response response = await dio.post('/courier/uploadPersonImage', data: formData, 
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',  // 设置 Content-Type
            },
        ),);

        // 处理响应
        Map<String, dynamic> result = response.data;
        // print(result);

        checkForTokenRefresh(result, ctx, () => uploadImage(dto, ctx));

        if (result['code'] == 1) {
          // 上传成功
          // print(result);
          dto.imageUrl = result['data'];
          showSnackBar('上传成功', '成功上传了头像', ContentType.success, ctx);
        } else {
          // 上传失败
          showSnackBar('上传失败', result['msg'], ContentType.failure, ctx);
        }
      } on DioException catch (e) {
        // 处理 Dio 的错误并反馈给用户
        // print(e.message);
        showSnackBar('上传失败', 'Failed to upload image: ${e.message}', ContentType.failure, ctx);
      } catch (e) {
        // 处理其他潜在的错误
        // print(e.toString());
        showSnackBar('上传失败', 'An unknown error occurred: ${e.toString()}', ContentType.failure, ctx);
      }
    } else {
      // 没有选择图片时的处理
      showSnackBar('未选择图片', '请先选择一张图片再上传', ContentType.warning, ctx);
    }
  }

  Future<Map<String, dynamic>> getBillList(String phone, String dateRange, String like, String type, BuildContext ctx) async {
    DateTime now = DateTime.now();
    DateTime start = now;
    switch (dateRange) {
      case '本日':
        start = DateTime(now.year, now.month, now.day);
        break;
      case '近7天':
        start = now.subtract(const Duration(days: 7));
        break;
      case '近30天':
        start = now.subtract(const Duration(days: 30));
        break;
    }
    // 时间日期格式化为yyyy-MM-dd
    String startDate = DateFormat('yyyy-MM-dd').format(start);
    String endDate = DateFormat('yyyy-MM-dd').format(now);
    try {
      Response response = await dio.get('/courier/viewEarningsHistory', queryParameters: {
        // 'phone': phone,
        'start': startDate,
        'end': endDate,
        'number': like,
        // 'type': null,
      });

      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      showSnackBar('获取账单失败', e.message!, ContentType.failure, ctx);
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