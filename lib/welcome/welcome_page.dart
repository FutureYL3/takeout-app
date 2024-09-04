import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../signup/sign_up_page.dart';
import '../login/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
            // App Logo
            const Text(
              'LOGO',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.25),
            // 登录按钮
            GestureDetector(
              onTap: () {
                Get.to(() => const SignUpPage());
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '登录',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // 注册按钮
            GestureDetector(
              onTap: () {
                Get.to(() => const SignUpPage());
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '注册',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
  
}