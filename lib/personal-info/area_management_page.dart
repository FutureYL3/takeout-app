import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/common_utils.dart';
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

  // 获取初始数据
  void getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = await secureStorage.read(key: 'phone');
    if (phone == null) {
      await Get.offAll(() => const WelcomePage());
      return;
    }

    Map<String, dynamic> response = await personalInfoApiService.getDeliveryArea(phone!, context);
    if (response['code'] == 401) {
      Map<String, dynamic> refreshData = await personalInfoApiService.refreshAccessToken(context);
      if (refreshData['code'] == 409) {
        // 如果refreshToken也过期了，要求重新登录
        await secureStorage.deleteAll();
        await prefs.setBool('Login_Status', false);
        Get.offAll(() => const WelcomePage());
        return;
      }
      if (refreshData['code'] == 1) {
        secureStorage.write(key: 'accessToken', value: refreshData['data']['accessToken']);
        secureStorage.write(key: 'refreshToken', value: refreshData['data']['refreshToken']);
      }
      getData();
    }
    if (response['code'] == 1) {
      final String? tempDeliveryArea = response['data'];
      setState(() {
        deliveryArea = tempDeliveryArea;
      });
    }
  }

  // 显示修改区域的对话框
  Future<void> _showModifyAreaDialog() async {
    String modifiedArea = deliveryArea ?? '校区1'; // 设置初始值
    final String? selectedArea = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('修改区域'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('请选择所属区域'),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: modifiedArea,
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
                // const SizedBox(height: 10),
                // Text(modifiedArea),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, modifiedArea); // 返回选择的区域并关闭对话框
                },
                child: const Text('确认修改'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context), // 取消并关闭对话框
                child: const Text('取消'),
              ),
            ],
          );
        },
      ),
    );

    // 如果用户选择了区域并点击“确认修改”
    if (selectedArea != null && selectedArea.isNotEmpty) {
      // 更新主页面的状态并发送请求
      await _updateDeliveryArea(selectedArea);
    }
  }

  // 更新配送区域
  Future<void> _updateDeliveryArea(String newArea) async {
    final Map<String, dynamic> response = await personalInfoApiService.updateDeliveryArea(phone!, newArea, context);
    if (response['code'] == 1) {
      setState(() {
        deliveryArea = newArea; // 更新页面的配送区域
      });
      showSnackBar("修改成功", "配送区域已更新", ContentType.success, context);
    } else {
      showSnackBar("修改失败", response['msg'] ?? "请稍后再试", ContentType.failure, context);
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
          Text('所属区域：${schoolName ?? 'xxx大学'}',
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
              onPressed: _showModifyAreaDialog, // 点击按钮显示修改区域对话框
              child: const Text('修改区域',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
            ),
          ),
        ],
      ),
    );
  }
}