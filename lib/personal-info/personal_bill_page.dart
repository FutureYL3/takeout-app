import 'package:flutter/material.dart';

class PersonalBillPage extends StatefulWidget {
  @override
  State<PersonalBillPage> createState() => _PersonalBillPageState();
}

class _PersonalBillPageState extends State<PersonalBillPage> {
  String _selectedDateRange = '本日';
  String _selectedFilter = '全部';

  final TextEditingController _searchController = TextEditingController();

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
          const Text(
            '577.31',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                  });
                },
              ),
            ],
          ),
          const Divider(),
          // 订单明细列表
          Expanded(
            child: ListView(
              children: [
                _buildTransactionItem(
                    'xxxxxxxxxxxxxxxxxxxxxxxx', '2元', '微信打款'),
                _buildTransactionItem(
                    'xxxxxxxxxxxxxxxxxxxxxxxx', '2元', '微信打款'),
                // 可以根据实际数据继续添加
              ],
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