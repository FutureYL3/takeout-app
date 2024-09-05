import 'package:dio/dio.dart';

class LoginApiService {
  static const String baseUrl = 'https://api.example.com';
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

    // // 添加拦截器
    // _dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) {
    //     // 在请求发送之前做一些处理
    //     print('Request: ${options.method} ${options.path}');
    //     return handler.next(options); // Continue the request
    //   },
    //   // onResponse: (response, handler) {
    //   //   // 在响应数据返回之前做一些处理
    //   //   print('Response: ${response.statusCode} ${response.data}');
    //   //   return handler.next(response); // Continue the response
    //   // },
    //   onError: (DioException e, handler) {
    //     // 在发生错误时做一些处理
    //     print('Error: ${e.response?.statusCode} ${e.message}');
    //     return handler.next(e); // Continue the error
    //   },
    // ));

  }  
  Future<Map<String, dynamic>> loginWithPwd(String phoneNumber, String password) async {
    try {
      Response response = await _dio.post('/courier/login/password', queryParameters: {
        'phoneNumber': phoneNumber,
        'password': password
      });

      return response.data;
    } on DioException catch (e) {
      // 处理 Dio 的错误
      throw Exception('Failed to get validation code: ${e.message}');
    }
  }
}