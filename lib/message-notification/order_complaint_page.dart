import 'package:flutter/material.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<ComplaintsPage> {
  String _selectedDate = '今日';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  value: _selectedDate, // 默认显示"今日"
                  items: <String>['今日', '近7天', '近30天', '今年'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) async {
                    // 实现下拉框选择后的逻辑
                    setState(() {
                      _selectedDate = value!;
                    });
                  },
                ),
                const Spacer(),
                // 搜索框
                Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {}, 
                          child: const Icon(Icons.search),
                        )
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '搜索订单',
                          ),
                          controller: _searchController,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('用户aaa'),
                  subtitle: Text('订单超时，外卖员态度差'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: Text('处理'),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('管理员'),
                  subtitle: Text('处理结果：申诉通过'),
                  trailing: Text('13:58'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}