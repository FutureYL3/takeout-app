import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../home/home_page.dart';
import '../utils/common_utils.dart';
import 'forget_password_page.dart';
import 'login_apis.dart';
import 'phone_login_page.dart';
import '../signup/sign_up_page.dart';


class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  void login() async {
    if ((_formKey.currentState as FormState).validate()) {
      // 登录逻辑
      final String phoneNumber = _phoneController.text;
      final String password = _passwordController.text;
      final LoginApiService loginApiService = LoginApiService();
      const FlutterSecureStorage secureStorage = FlutterSecureStorage();
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      Map<String, dynamic> response = await loginApiService.loginWithPwd(phoneNumber, password, context);
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
        showSnackBar('登录失败', response['msg'] ?? '请稍后再试或联系客服', ContentType.failure, context);
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
                        child: Form(
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
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: '密码',
                                  hintText: '请输入密码',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                  )
                                ),
                                controller: _passwordController,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '请输入密码';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                        ),
                      ),  
                      const SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const ForgetPasswordPage());
                            },
                            child: const Text("忘记密码？",)
                          )
                          
                        ],
                      ),
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.02), 
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const PhoneLoginPage());
                        },
                        child: const Text(
                          '手机号一键登录',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
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
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.015),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.off(() => const SignUpPage());
                            },
                            child: const Text(
                              "还没有账号？去注册",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 16
                              ),
                            )
                          )
                          
                        ],
                      ),
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.025),
                      const Divider(
                        color: Colors.grey,
                        height: 1,
                        thickness: 2,
                        indent: 0,
                        endIndent: 0,
                      ),
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.015),
                      const Text("第三方登录方式"),
                      GestureDetector(
                        onTap: () {
                          // 微信登录
                        },
                        child:Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.005),
                      const Text("微信")
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
}