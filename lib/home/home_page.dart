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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("首页"),
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