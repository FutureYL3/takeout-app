import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../message-notification/msg_notification_page.dart';
import '../order/order_managing_page.dart';
import '../personal-info/personal_center_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool isOnline = true;
  String systemNotification = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('xxxxxx外卖端'),
            SizedBox(width: 10),
            Text(
              '在线',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Icon(Icons.circle, color: Colors.green, size: 10),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(Icons.play_arrow),
                      SizedBox(width: 5),
                      Text('开始接单'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  // style: ElevatedButton.styleFrom(
                  //   backgroundColor: Colors.grey,
                  // ),
                  child: Row(
                    children: [
                      Icon(Icons.stop),
                      SizedBox(width: 5),
                      Text('停止接单'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatistic('今日已接单', '99', '比昨日 ↑12'),
                _buildStatistic('预计今日收入', '389.21', '比昨日 ↑121.21'),
                _buildStatistic('本月总收入', '33389.21', '比上月 ↑1211.89'),
              ],
            ),
            SizedBox(height: 20),
            Text('系统通知'),
            Container(
              color: Colors.grey[200],
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              child: Text(
                'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
              ),
            ),
            SizedBox(height: 20),
            Text('正在配送'),
            Card(
              child: ListTile(
                title: Text('陈先生  xxxx小区xxxx楼xxx楼1420'),
                subtitle: Container(
                  margin: EdgeInsets.only(top: 10),
                  color: Colors.grey[300],
                  height: 150,
                  child: Center(
                    child: Text('静态地图指引'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '订单管理',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '通知与申诉',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '个人中心',
          ),
        ],
        onTap: _bottomNavigationBarOnTap,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 251, 255, 0), // 选中项的颜色
        unselectedItemColor: Colors.white, // 未选中项的颜色
        type: BottomNavigationBarType.fixed, // 确保所有项都显示 label
      ),
    );
  }

  Widget _buildStatistic(String title, String value, String subtext) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(subtext, style: TextStyle(color: Colors.green)),
      ],
    );
  }

  void _bottomNavigationBarOnTap(int value) {
    setState(() {
      _selectedIndex = value;
    });

    switch (value) {
      case 0:
        Get.off(() => const HomePage());
        break;
      case 1:
        Get.off(() => const OrderManagingPage());
        break;
      case 2:
        Get.off(() => const MsgNotificationPage());
        break;
      case 3:
        Get.off(() => const PersonalCenterPage());
        break;      
    }
  }
}