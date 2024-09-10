import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../utils/common_utils.dart';
import 'reset_password_page.dart';

class ForgetPasswordPage extends StatefulWidget{
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>{
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final CommonUtilsApiService _apiService = CommonUtilsApiService();

  int _countdown = 60;
  Timer? _timer;
  bool _canResend = true;

  // 开始倒计时
  void _startCountdown() async {
    RegExp regTel = RegExp(r'^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$');

    if (phoneController.text.isEmpty) {
      showSnackBar('错误', '手机号不能为空', ContentType.failure, context);
      return;
    }

    if (!regTel.hasMatch(phoneController.text)) {
      showSnackBar('错误', '请输入正确的手机号', ContentType.failure, context);
      return;
    }

    // 获取验证码
    Map<String, dynamic> response = await _apiService.getValidationCode(phoneController.text);

    if (response['error'] == true) {
      showSnackBar('错误', '网络错误，请检查网络连接', ContentType.failure, context);
      return;
    }
    if (response['code'] == 1) {
      showSnackBar('成功', "已发送验证码", ContentType.success, context);
    } else {
      showSnackBar('错误', response['msg'], ContentType.success, context);
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

  void submit() async {
    // Get.to(() => ResetPasswordPage(phoneNumber: phoneController.text));
    // return;

    // 验证码为空
    if (codeController.text.isEmpty) {
      showSnackBar('错误', '验证码不能为空', ContentType.failure, context);
      return;
    }

    // 验证码错误
    Map<String, dynamic> response = await _apiService.checkValidationCode(phoneController.text, codeController.text);
    if (response['error'] == true) {
      showSnackBar('错误', '网络错误，请检查网络连接', ContentType.failure, context);
      return;
    }
    if (response['code'] == 0) {
      showSnackBar('错误', response['msg'], ContentType.failure, context);
      return;
    } 
    // 跳转到下一步
    Get.to(() => ResetPasswordPage(phoneNumber: phoneController.text));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 标题
                const Text(
                  '找回密码',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                // 手机号输入框
                Row(
                  children: [
                    const Text('手机号'),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: '请输入手机号',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 验证码输入框和获取验证码按钮
                Row(
                  children: [
                    const Text('验证码'),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: codeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '请输入验证码',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _canResend ? _startCountdown : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 50),
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                      child: Text(_canResend ? '获取验证码' : '(${_countdown}s)'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // 下一步按钮
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black),
                      ),
                      // primary: Colors.white,
                      // onPrimary: Colors.black,
                    ),
                    child: const Text('下一步'),
                  ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}  