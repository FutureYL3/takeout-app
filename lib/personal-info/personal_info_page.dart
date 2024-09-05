import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:takeout/personal-info/personal_info_apis.dart';

import '../welcome/welcome_page.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  late final String imageUrl;
  late final String id;
  late final String? phone;
  final PersonalInfoApiService personalInfoApiService = PersonalInfoApiService();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() async {
    super.initState();
    phone = await secureStorage.read(key: 'phone');
    if (phone == null) {
      // 如果没有存储手机号，即表示未登录，跳转到欢迎页面
      Get.offAll(() => const WelcomePage());
      return;
    }
    // 请求成功，保存数据
    Map<String, dynamic> response = await personalInfoApiService.getPersonalInfo(phone!, context);
    if (response['code'] == 1 && response['data']['isSuccess']) {
      id = response['data']['id'];
      imageUrl = response['data']['imageURL'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('头像：'),
              const SizedBox(width: 20),
              Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(id),
          const SizedBox(height: 10),
          Text(phone ?? ''),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 修改资料按钮点击事件
            },
            child: const Text('修改资料'),
          ),
        ],
      )
    );
  }
}