/// @Author: yl Future_YL@outlook.com
/// @Date: 2024-09-20 
/// @LastEditors: yl Future_YL@outlook.com
/// @LastEditTime: 2024-10-03 12:45
/// @FilePath: lib/order/order_managing_page.dart
/// @Description: 这是订单管理模块的页面框架


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../home/home_page.dart';
import '../message-notification/msg_notification_page.dart';
import '../personal-info/personal_center_page.dart';
// import 'order_accepted_page.dart';
import 'order_cancelled_page.dart';
import 'order_completed_page.dart';
import 'order_delivering_page.dart';
import 'order_pending_page.dart';

class OrderManagingPage extends StatefulWidget {
  const OrderManagingPage({super.key});

  @override
  State<OrderManagingPage> createState() => _OrderManagingPageState();
}

class _OrderManagingPageState extends State<OrderManagingPage> {
  int _selectedIndex = 1;
  int _selectedItem = 0;
  bool? isOnline = false;

  // 存储已经加载的页面
  final Map<int, Widget> _loadedPages = {};

  void getOnlineStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? status = prefs.getBool('onlineStatus');

    if (status != null) {
      setState(() {
        isOnline = status;
      });
    }
  }

  @override
  void initState() {
    getOnlineStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('康食速点通 外卖端'),
            const SizedBox(width: 10),
            Text(
              isOnline! ? '在线' : '离线',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            isOnline! ? const Icon(Icons.circle, color: Colors.green, size: 10) : const Icon(Icons.circle, color: Colors.grey, size: 10),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Row(
        children: [
          // 左侧菜单栏
          Container(
            width: 70,
            color: Colors.grey[200],
            child: ListView(
              children: [
                _buildMenuItem('待处理', 0),
                // _buildMenuItem('已接单', 1),
                _buildMenuItem('配送中', 2),
                _buildMenuItem('已完成', 3),
                _buildMenuItem('已取消', 4)
              ],
            ),
          ),
          // 右侧内容区
          Expanded(
            child: _buildPageContent(_selectedItem),
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

  Widget _buildMenuItem(String title, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedItem = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _selectedItem == index ? Colors.blue : Colors.black,
            fontWeight: _selectedItem == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }


  /// 通过懒加载来构建页面，只有在用户点击菜单时才加载页面
  Widget _buildPageContent(int index) {
    if (_loadedPages.containsKey(index)) {
      return _loadedPages[index]!;
    }

    switch (index) {
      case 0:
        _loadedPages[index] = const OrderPendingPage();
        break;
      // case 1:
      //   _loadedPages[index] = const OrderAcceptedPage();
      //   break;
      case 2:
        _loadedPages[index] = const OrderDeliveringPage();
        break;
      case 3:
        _loadedPages[index] = const OrderCompletedPage();
        break;
      case 4:
        _loadedPages[index] = const OrderCancelledPage();
        break;
    }

    return _loadedPages[index]!;
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