import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home_page.dart';
import '../utils/common_utils.dart';
import 'login_apis.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  final CommonUtilsApiService utils = CommonUtilsApiService();
  final LoginApiService loginApiService = LoginApiService();

  int _countdown = 60;
  Timer? _timer;
  bool _canResend = true;

  // 开始倒计时
  void _startCountdown() async {
    RegExp regTel = RegExp(r'^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$');

    if (_phoneController.text.isEmpty) {
      showSnackBar('错误', '手机号不能为空', ContentType.failure, context);
      return;
    }

    if (!regTel.hasMatch(_phoneController.text)) {
      showSnackBar('错误', '请输入正确的手机号', ContentType.failure, context);
      return;
    }

    // 获取验证码
    Map<String, dynamic> response = await utils.getValidationCode(_phoneController.text);

    if (response['error'] == true) {
      showSnackBar('错误', '网络错误，请检查网络连接', ContentType.failure, context);
      return;
    }
    if (response['code'] == 20000 || response['code'] == 20001) {
      showSnackBar('成功', "已发送验证码", ContentType.success, context);
    } else {
      showSnackBar('错误', response['msg'], ContentType.failure, context);
      return;
    }

    setState(() {
      _canResend = false;
      _countdown = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  void login() async {
    if ((_formKey.currentState as FormState).validate()) {
      // 登录逻辑
      final String phoneNumber = _phoneController.text;
      final String validationCode = _codeController.text;
      const FlutterSecureStorage secureStorage = FlutterSecureStorage();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> response = await loginApiService.loginWithCode(phoneNumber, validationCode, context);

      if (response['code'] == 1) {
        // 登录成功
        await secureStorage.write(key: 'accessToken', value: response['data']['accessToken']);
        await secureStorage.write(key: 'refreshToken', value: response['data']['refreshToken']);
        await secureStorage.write(key: 'phone', value: phoneNumber);
        await prefs.setBool('Login_Status', true);
        Get.offAll(() => const HomePage());
        return;
      } else {
        // 登录失败
        showSnackBar('登录失败', response['msg'] ?? '', ContentType.failure, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
              const Text(
                "外卖员登录", 
                style: TextStyle(fontSize: 24)
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child:Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: '手机号',
                                  hintText: '请输入手机号',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                ),
                                controller: _phoneController,
                                validator: (value) {
                                  RegExp regTel = RegExp(r'^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$');
                                  if (value!.isEmpty) {
                                    return '请输入手机号';
                                  }
                                  if (!regTel.hasMatch(value)) {
                                    return '请输入正确的手机号';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    child: TextFormField(
                                      style: const TextStyle(fontSize: 14),
                                      decoration: const InputDecoration(
                                        labelText: '验证码',
                                        hintText: "请输入验证码",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                        )
                                      ),
                                      controller: _codeController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return '请输入验证码';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                                  ElevatedButton(
                                    onPressed: _canResend ? _startCountdown : null,
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(60, 50),
                                      maximumSize: const Size(120, 50),
                                      textStyle: const TextStyle(fontSize: 14),
                                    ),
                                    child: Text(_canResend ? '获取验证码' : '(${_countdown}s)'),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ),
                      ),
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                      GestureDetector(
                        onTap: login,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Text(
                            '登录',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              )
            ],
          ),
        )
      )
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  
}