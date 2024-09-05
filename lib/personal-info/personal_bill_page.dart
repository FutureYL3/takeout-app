import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:takeout/personal-info/personal_info_apis.dart';

import '../welcome/welcome_page.dart';

class BillData {
  final String? orderNumber;
  final double? earning;
  final String? payMethod;

  BillData({this.orderNumber, this.earning, this.payMethod});
}

class PersonalBillPage extends StatefulWidget {
  const PersonalBillPage({super.key});

  @override
  State<PersonalBillPage> createState() => _PersonalBillPageState();
}

class _PersonalBillPageState extends State<PersonalBillPage> {
  String _selectedDateRange = '本日';
  String _selectedFilter = '全部';
  final List<BillData> _billList = [];
  double totalEarning = 0.0;

  final TextEditingController _searchController = TextEditingController();
  final PersonalInfoApiService personalInfoApiService = PersonalInfoApiService();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void regetData() async {
    // 发送请求
    final String? phone = await secureStorage.read(key: 'phone');
    Map<String, dynamic> response = await personalInfoApiService.getBillList(phone!, _selectedDateRange, '', _selectedFilter, context);
    if (response['code'] == 1 && response['data']['isSuccess']) {
      // 获取 data 数组
      List<dynamic> dataList = response['data']['data'];
      // 清空原数组
      _billList.clear();

      // 遍历 data 数组
      for (var item in dataList) {
        String orderNumber = item['orderNumber'];
        double earning = item['earning'];
        String payMethod = item['payMethod'];

        _billList.add(BillData(orderNumber: orderNumber, earning: earning, payMethod: payMethod));
        totalEarning += earning;
      }
    }
  }

  @override
  void initState() async {
    super.initState();
    final String? phone = await secureStorage.read(key: 'phone');

    if (phone == null) {
      // 如果没有存储手机号，即表示未登录，跳转到欢迎页面
      Get.offAll(() => const WelcomePage());
      return;
    }
    // 发送请求
    Map<String, dynamic> response = await personalInfoApiService.getBillList(phone, _selectedDateRange, '', _selectedFilter, context);
    if (response['code'] == 1 && response['data']['isSuccess']) {
      // 获取 data 数组
      List<dynamic> dataList = response['data']['data'];

      // 遍历 data 数组
      for (var item in dataList) {
        String orderNumber = item['orderNumber'];
        double earning = item['earning'];
        String payMethod = item['payMethod'];

        _billList.add(BillData(orderNumber: orderNumber, earning: earning, payMethod: payMethod));
        totalEarning += earning;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 日期选择和总流水
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: _selectedDateRange,
                items: <String>['本日', '本周', '本月']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDateRange = newValue!;
                    regetData();
                  });
                },
              ),
              const SizedBox(width: 20,),
              const Text(
                '总金额流水',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            totalEarning.toString(),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          // 搜索与筛选
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: '流水明细',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _selectedFilter,
                items: <String>['全部', '配送收入', '平台奖励']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedFilter = newValue!;
                    regetData();
                  });
                },
              ),
            ],
          ),
          const Divider(),
          // 订单明细列表
          Expanded(
            child: ListView(
              children: _billList.map((item) {
                return _buildTransactionItem(item.orderNumber ?? '', item.earning.toString(), item.payMethod!);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String orderNumber, String fee, String paymentMethod) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('订单编号：$orderNumber', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text('配送费：$fee', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Text('到账方式：$paymentMethod', style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}