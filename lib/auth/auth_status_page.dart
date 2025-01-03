import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kssdt/auth/auth_status_apis.dart';

import '../utils/common_utils.dart';

class AuthStatusPage extends StatefulWidget {
  const AuthStatusPage({super.key});

  @override
  AuthStatusPageState createState() => AuthStatusPageState();
}

class AuthStatusPageState extends State<AuthStatusPage> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final CommonUtilsApiService utils = CommonUtilsApiService();
  final AuthStatusApiService authStatusApiService = AuthStatusApiService();
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

  void query(String phone, String code, BuildContext context) async {
    String? authStatus;
    String? authMessage;

    Map<String, dynamic> response = await authStatusApiService.query(_phoneController.text, _codeController.text, context);

    if (response['code'] == 1) {
      // 查询
      authStatus = response['data']['authStatus'];
      authMessage = response['data']['authMessage'];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('审核状态：$authStatus'),
              const SizedBox(height: 5),
              Text('详细信息：$authMessage'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                color: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text('确认', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                keyboardType: TextInputType.phone,
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
                      keyboardType: TextInputType.number,
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
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  query(_phoneController.text, _codeController.text, context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Text(
                    '查询审核状态',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        )
      )
    );
  }
}