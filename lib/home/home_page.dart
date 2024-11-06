import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kssdt/home/statistics_model.dart';

import '../message-notification/msg_notification_page.dart';
import '../order/order_managing_page.dart';
import '../personal-info/personal_center_page.dart';
import 'Deliverying_order_model.dart';
import 'home_apis.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool isOnline = true;
  List<DeliveryingOrder> deliveryingOrders = []; 
  List<String> systemNotifications = [];
  late Statistics statistics;
  final HomeApiService homeApiService = HomeApiService();

  void changeOnlineStatus(bool status) async {
    Map<String, dynamic> response = await homeApiService.updateMyOnlineStatus(status, context);

    if (response['code'] == 1) {
      setState(() {
        isOnline = status;
      });
    }
  }

  void getStatistics() async {
    DateTime now = DateTime.now();
    Map<String, dynamic> response = await homeApiService.getStatisticsInfo(now, context);

    if (response['code'] == 1) {
      setState(() {
        statistics = Statistics.fromJson(response['data']);
      });
    }
  }

  void getDeliveryingOrders() async {
    DateTime now = DateTime.now();
    Map<String, dynamic> response = await homeApiService.getDeliveryingOrders(now, context);

    if (response['code'] == 1) {
      List<dynamic> data = response['data'];
      List<DeliveryingOrder> orders = data.map((e) => DeliveryingOrder(customerName: e['customerName'], deliveryAddr: e['deliveryAddr'], mapUrl: e['mapUrl'])).toList();

      setState(() {
        deliveryingOrders = orders;
      });
    }
  }

  void getSystemNotification() async {
    Map<String, dynamic> response = await homeApiService.getSystemNotification(context);

    if (response['code'] == 1) {
      List<dynamic> data = response['data'];
      List<String> notifications = data.map((e) => e.toString()).toList();

      setState(() {
        systemNotifications = notifications;
      });
    }
  }

  @override
  void initState() {
    super.initState();
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
                  onPressed: () {
                    changeOnlineStatus(true);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.play_arrow),
                      SizedBox(width: 5),
                      Text('开始接单'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    changeOnlineStatus(false);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.stop),
                      SizedBox(width: 5),
                      Text('停止接单'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatistic('今日已接单', statistics.acceptedOrdersToday.toString(), '比昨日${statistics.isOrderIncreased ? '↑' : '↓'}${statistics.compareYesterdayOrderNum}'),
                _buildStatistic('预计今日收入', statistics.estimatedIncomeToday.toString(), '比昨日${statistics.isIncomeIncreased ? '↑' : '↓'}${statistics.compareYesterdayIncome}'),
                _buildStatistic('本月总收入', statistics.totalIncomeThisMonth.toString(), '比昨日${statistics.isMonthIncomeIncreased ? '↑' : '↓'}${statistics.compareLastMonthIncome}'),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('系统通知'),
                  Container(
                    color: Colors.grey[200],
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: systemNotifications.map((e) => Text(e)).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('正在配送'),
                  ListView.builder(
                    itemCount: deliveryingOrders.length,
                    itemBuilder: (context, index) {
                      final order = deliveryingOrders[index];

                      return Card(
                        child: ListTile(
                          title: Text('${order.customerName} ${order.deliveryAddr}'),
                          subtitle: Container(
                            margin: const EdgeInsets.only(top: 10),
                            color: Colors.grey[300],
                            height: 150,
                            child: Center(
                              child: Image.network(order.mapUrl, width: 200, height: 150, fit: BoxFit.cover)
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            )
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
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(subtext, style: const TextStyle(color: Colors.green)),
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