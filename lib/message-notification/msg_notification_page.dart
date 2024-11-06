import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/home_page.dart';
import '../order/order_managing_page.dart';
import '../personal-info/personal_center_page.dart';
import 'order_complaint_page.dart';
import 'sys_notification_page.dart';

class MsgNotificationPage extends StatefulWidget {
  const MsgNotificationPage({super.key});

  @override
  State<MsgNotificationPage> createState() => _MsgNotificationPageState();
}

class _MsgNotificationPageState extends State<MsgNotificationPage> {
  int _selectedIndex = 2;

  int _selectedTabIndex = 0;

  final List<Widget> _pages = [
    const NotificationsPage(),
    const ComplaintsPage(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

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
          NavigationRail(
            selectedIndex: _selectedTabIndex,
            onDestinationSelected: _onTabSelected,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.notifications),
                label: Text('通知'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.assignment),
                label: Text('申诉'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter, // 确保内容靠上对齐
              child: _pages[_selectedTabIndex],
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