import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../welcome/welcome_page.dart';

class WaitingAuthPage extends StatelessWidget{
  const WaitingAuthPage({super.key});

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
              const Text("您已成功提交注册，请耐心等待审核通过"),
              ElevatedButton(
                onPressed: () {
                  Get.offAll(() => const WelcomePage());
                }, 
                child: const Text("确认")
              )
            ],
          ),
        ),
      )
    );
  }
}