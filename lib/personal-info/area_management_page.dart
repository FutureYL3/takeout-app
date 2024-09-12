import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:takeout/utils/common_utils.dart';

import '../welcome/welcome_page.dart';
import 'personal_info_apis.dart';

class AreaManagementPage extends StatefulWidget {
  const AreaManagementPage({super.key});

  @override
  State<StatefulWidget> createState() => _AreaManagementPageState();
}

class _AreaManagementPageState extends State<AreaManagementPage> {
  String? phone;
  String? schoolName;
  String? deliveryArea;
  final PersonalInfoApiService personalInfoApiService = PersonalInfoApiService();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    phone = await secureStorage.read(key: 'phone');
    if (phone == null) {
      // 如果没有存储手机号，即表示未登录，跳转到欢迎页面
      await Get.offAll(() => const WelcomePage());
      return;
    }
    // 请求成功，保存数据
    Map<String, dynamic> response = await personalInfoApiService.getDeliveryArea(phone!, context);
    if (response['code'] == 1 && response['data']['isSuccess']) {
      deliveryArea = response['data']['location'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          Text('所属区域：${schoolName ?? ''}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 10),
          Text('配送范围：${deliveryArea ?? ''}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.width * 0.7,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // 修改资料按钮点击事件
                String? modifiedArea;
                showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('修改区域'),
                  content: Column(
                    children: [
                      const Text('请选择所属区域'),
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        value: schoolName,
                        items: <String>['校区1', '校区2', '校区3']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            modifiedArea = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.width * 0.7,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        // 修改配送范围逻辑
                        if (modifiedArea == null) {
                          showSnackBar("请选择配送范围", "配送范围不能为空", ContentType.warning, context);
                          return;
                        }

                        final Map<String, dynamic> response = await personalInfoApiService.updateDeliveryArea(phone!, modifiedArea!, context);
                        if (response['code'] == 1) {
                          setState(() {
                            deliveryArea = modifiedArea;
                          });
                          return;
                        } else {
                          showSnackBar("修改失败", response['msg'] ?? "请稍后再试", ContentType.failure, context);
                        }
                      },
                      child: const Text('确认修改'),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('取消'),
                    ),
                  ],
                ),
              );
              },
              child: const Text('修改区域',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
            ),
          )
        ],
      )
    );
  }
}