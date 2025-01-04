import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'waiting_auth_page.dart';
import '../utils/common_utils.dart';
import 'sign_up_apis.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  final SignUpApiService signUpApiService = SignUpApiService();

  final CommonUtilsApiService utils = CommonUtilsApiService();

  int _countdown = 60;
  Timer? _timer;
  bool _canResend = true;

  // 新增变量：大学列表和选中值
  List<Map<String, dynamic>> _collegeList = [];
  String? _selectedCollegeName;
  int? _selectedCollegeId;
  bool _isCollegeLoading = true;

  @override
  initState() {
    super.initState();
    _fetchCollegeList();
  }

  Future<void> _fetchCollegeList() async {
    try {
      Map<String, dynamic> response = await signUpApiService.getCollegeList(context);

      // 解析大学列表
      if (response['code'] == 1 && response['data'] != null && response['data']['UniversityList'] != null) {
        setState(() {
          _collegeList = List<Map<String, dynamic>>.from(response['data']['UniversityList']);
          _isCollegeLoading = false;
        });
      } else {
        setState(() {
          _isCollegeLoading = false;
        });
        showSnackBar('错误', response['msg'] ?? '获取大学列表失败', ContentType.failure, context);
      }
    } catch (e) {
      setState(() {
        _isCollegeLoading = false;
      });
      showSnackBar('错误', '无法获取大学列表，请稍后再试', ContentType.failure, context);
    }
  }


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
              const Text(
                '注册',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          labelText: '手机号',
                          hintText: "请输入手机号",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          // filled: true,
                        ),
                        keyboardType: TextInputType.phone,
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
                      const SizedBox(height: 20,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.46,
                            child: TextFormField(
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                labelText: '验证码',
                                hintText: "请输入验证码",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
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
                          SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                          ElevatedButton(
                            onPressed: _canResend ? _startCountdown : null,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(MediaQuery.of(context).size.width * 0.2, 50),
                              // maximumSize: const Size(120, 50),
                              textStyle: const TextStyle(fontSize: 14),
                            ),
                            child: Text(_canResend ? '获取验证码' : '(${_countdown}s)'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          labelText: '使用人姓名',
                          hintText: "请输入外卖员姓名",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        controller: _nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '请输入姓名';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _isCollegeLoading
                          ? const CircularProgressIndicator()
                          : DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: '选择大学',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              value: _selectedCollegeName,
                              items: _collegeList
                                  .map((college) => DropdownMenuItem<String>(
                                        value: college['collegeName'],
                                        child: Text(college['collegeName']),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCollegeName = value;
                                  _selectedCollegeId = _collegeList.firstWhere((college) => college['collegeName'] == value)['collegeId'];
                                });
                                // print(_selectedCollegeId);
                              },
                            ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          labelText: '登录密码',
                          hintText: "请输入登录密码",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '请输入登录密码';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          labelText: '确认登录密码',
                          hintText: "请再次输入登录密码",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '请再次输入登录密码';
                          }
                          if (value != _passwordController.text) {
                            return '两次输入密码不一致';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.resolveWith((states) => Size(MediaQuery.of(context).size.width * 0.5, MediaQuery.of(context).size.height * 0.05)),
                        ),
                        onPressed: () async {
                          if ((_formKey.currentState as FormState).validate()) {
                            // 提交表单
                            final String phoneNumber = _phoneController.text;
                            final String validationCode = _codeController.text;
                            final String realName = _nameController.text;
                            final String password = _passwordController.text;
                            
                            // 发送请求
                            Map<String, dynamic> response = await signUpApiService.submit(phoneNumber, realName, validationCode, password, _selectedCollegeId.toString(), context);

                            if (response['code'] == 1) {
                              // 注册成功
                              Get.off(() => const WaitingAuthPage());
                              return;
                            }

                            // 注册失败
                            showSnackBar('注册失败', response['msg'] ?? '', ContentType.failure, context);
                          }
                        },
                        child: const Text('提交'),
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _codeController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}