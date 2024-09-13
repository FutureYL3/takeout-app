import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../welcome/welcome_page.dart';

class AccountManagementPage extends StatefulWidget {
  const AccountManagementPage({super.key});

  @override
  State<AccountManagementPage> createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? phone;

  void init() async {
    
    final String? getPhone = await secureStorage.read(key: 'phone');

    if (getPhone == null) {
      // 如果没有存储手机号，即表示未登录，跳转到欢迎页面
      await Get.offAll(() => const WelcomePage());
      return;
    }
    setState(() {
      phone = getPhone;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 平台Logo
          Container(
            width: 100,
            height: 100,
            color: Colors.grey[300],
            child: const Center(
              child: Text(
                '平台logo',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 当前账号信息
          Text(
            '当前账号：$phone',
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 40),
          // 退出登录按钮
          ElevatedButton(
            onPressed: () {
              // 处理退出登录的逻辑
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('确认退出登录吗？'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () async {
                        // 退出逻辑
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('Login_Status', false);
                        await secureStorage.deleteAll();
                        Get.offAll(() => const WelcomePage());
                      },
                      child: const Text('确认'),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: const Text('退出登录'),
          ),
        ],
      ),
    );
  }
}

// class AccountManagementPage extends StatelessWidget {
  
// }