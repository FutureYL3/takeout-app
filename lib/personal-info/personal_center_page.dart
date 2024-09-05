import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/home_page.dart';
import '../message-notification/msg_notification_page.dart';
import '../order/order_managing_page.dart';
import 'account_management_page.dart';
import 'contact_service_page.dart';
import 'personal_bill_page.dart';
import 'personal_info_page.dart';

class PersonalCenterPage extends StatefulWidget {
  const PersonalCenterPage({super.key});

  @override
  State<PersonalCenterPage> createState() => _PersonalCenterPageState();
}

class _PersonalCenterPageState extends State<PersonalCenterPage> {
  int _selectedIndex = 3;
  int _selectedItem = 0;

  final List<Widget> _pages = [
    const PersonalInfoPage(),
    PersonalBillPage(),
    ContactServicePage(),
    const AccountManagementPage()
  ];

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
      body: Row(
        children: [
          // 左侧菜单栏
          Container(
            width: 90,
            color: Colors.grey[200],
            child: ListView(
              children: [
                _buildMenuItem('个人信息', 0),
                _buildMenuItem('个人账单', 1),
                _buildMenuItem('联系客服', 2),
                _buildMenuItem('账号管理', 3),
              ],
            ),
          ),
          // 右侧内容区
          Expanded(
            child: IndexedStack(
              index: _selectedItem,
              children: _pages,
            ),
          ),
        ],
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
            label: '私信与通知',
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

Widget _buildMenuItem(String title, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedItem = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          title,
          style: TextStyle(
            color: _selectedItem == index ? Colors.blue : Colors.black,
            fontWeight: _selectedItem == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
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