import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takeout/utils/common_utils.dart';
import 'package:takeout/welcome/welcome_page.dart';
import './login_apis.dart';

class ResetPasswordPage extends StatefulWidget {
  final String phoneNumber;
  const ResetPasswordPage({super.key, required this.phoneNumber});
  
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();

}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final LoginApiService _apiService = LoginApiService();
  String? errorText1;
  String? errorText2;


  void submit() async {
    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      // 密码为空
      setState(() {
        errorText1 = _passwordController.text.isEmpty ? '密码不能为空' : null;
        errorText2 = _confirmPasswordController.text.isEmpty ? '确认密码不能为空' : null;
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      // 两次密码不一致
      setState(() {
        errorText1 = null;
        errorText2 = '两次密码不一致';
      });
      return;
    }

    setState(() {
      errorText1 = null;
      errorText2 = null;
    });

    Map<String, dynamic> response = await _apiService.resetPassword(widget.phoneNumber, _passwordController.text);
    if (response['error'] == true) {
      // 重置密码失败
      showSnackBar('错误', '网络错误，请检查网络连接', ContentType.failure, context);
      return;
    }

    if (response['code'] == 1) {
      // 重置密码成功
      showSnackBar('成功', '重置密码成功', ContentType.success, context);
      Get.offAll(() => const WelcomePage());
      return;
    } else {
      // 重置密码失败
      showSnackBar('错误', response['msg'], ContentType.failure, context);
    }
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
                    const SizedBox(
                      width: 70,
                      child: Text('新密码'),
                    ), 
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          errorText: errorText1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 验证码输入框和获取验证码按钮
                Row(
                  children: [
                    const SizedBox(
                      width: 70,
                      child: Text('确认密码'),
                    ), 
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          errorText: errorText2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // 下一步按钮
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
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
                    child: const Text('提交'),
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