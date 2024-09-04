import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'waiting_auth_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();


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
                        decoration: const InputDecoration(
                          labelText: '手机号',
                          hintText: "请输入手机号",
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
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.59,
                              child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: '验证码',
                                hintText: "请输入验证码",
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
                          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                          GestureDetector(
                            onTap: () {
                              
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                              // padding: const EdgeInsets.only(top: 10),
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.04,
                              width: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.green),
                              ),
                              child: const Text(
                                "获取验证码",
                              ),
                            ),
                          )
                        ],
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: '使用人姓名',
                          hintText: "请输入外卖员姓名"
                        ),
                        controller: _nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '请输入姓名';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: '登录密码',
                          hintText: "请输入登录密码",
                          
                        ),
                        // keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '请输入登录密码';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: '确认登录密码',
                          hintText: "请再次输入登录密码",
                        ),
                        // keyboardType: TextInputType.visiblePassword,
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
                        onPressed: () {
                          if ((_formKey.currentState as FormState).validate()) {
                            // 提交表单
                            if (true) {
                              // 提交成功
                              Get.to(() => const WaitingAuthPage());
                            }
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
}