/// @Author: yl Future_YL@outlook.com
/// @Date: 2024-09-20 
/// @LastEditors: Hui_Loading 3080811164@qq.com
/// @LastEditTime: 2025-03-17 21:28:35
/// @FilePath: lib/order/order_delivering_page.dart
/// @Description: 这是配送中订单页面

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


import 'order_card.dart';
import 'order_controller.dart';

class OrderDeliveringPage extends StatefulWidget {
  const OrderDeliveringPage({super.key});

  @override
  State<OrderDeliveringPage> createState() => _OrderDeliveringPageState();
}

class _OrderDeliveringPageState extends State<OrderDeliveringPage> with AutomaticKeepAliveClientMixin {
  String _selectedDate = '今日';
  String? like;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      init(); // 保证在页面构建后初始化数据
  });
  }

  void init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedDate = prefs.getString('deleverying_selectedDate') ?? '今日';
    });
    regetData();
  }

  void regetData() async {
    DateTime now = DateTime.now();
    DateTime start;
    String like = _searchController.text;
    final OrderController orderController = Get.find<OrderController>();

    switch (_selectedDate) {
      case '今日':
        start = DateTime(now.year, now.month, now.day);
        break;
      case '近7天':
        start = now.subtract(const Duration(days: 7));
        break;
      case '近30天':
        start = now.subtract(const Duration(days: 30));
        break;
      case '今年':
        start = DateTime(now.year, 1, 1);
        break;
      default:
        start = DateTime(now.year, now.month, now.day);  
    }

    orderController.fetchDeliveryingOrders(start, now, like, context, isInitFetch: false);

  }  

  @override
  bool get wantKeepAlive => true; // 确保页面在切换时保持活动状态

  void _showContactOptions(BuildContext context, String countryCode, String phoneNumber) {
    void makeDirectCall() async {
      await makePhoneCall('$phoneNumber');
    }

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                makeDirectCall();
                Navigator.pop(context);
              },
              child: const Text('电话联系',
                style: TextStyle(
                  fontSize: 22
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                // TODO: 添加私信联系的逻辑
                Navigator.pop(context);
              },
              child: const Text('私信联系',
                style: TextStyle(
                  fontSize: 22
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 调用 super.build 以确保 AutomaticKeepAliveClientMixin 正常工作
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 今日下拉框和搜索框
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
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('deleverying_selectedDate', value!);
                  setState(() {
                    _selectedDate = value;
                    regetData();
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
                        onTap: regetData, 
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

          Expanded(
            child: Obx(() {
              final OrderController orderController = Get.find<OrderController>();

              if (orderController.deliveryingOrders.isEmpty) {
                return const Center(child: Text('暂无配送中订单'));
              }

              return ListView.builder(
                itemCount: orderController.deliveryingOrders.length,
                itemBuilder: (context, index) {
                  var order = orderController.deliveryingOrders[index];
                  return OrderCardWithButton(
                    orderId: order.orderId,
                    number: order.number,
                    deliveryTime: order.deliveryTime,
                    customerName: order.customerName,
                    customerAddress: order.customerAddress,
                    orderAddress: order.orderAddress,
                    frontButtonText: '已送达',
                    rearButtonText: '联系用户',
                    foodItems: order.foodItems,
                    onFrontButtonPressed: () {
                      // 更新订单状态为 completed
                      orderController.updateOrderStatus(orderController.deliveryingOrders, order.orderId, 6, context, '送达成功', '');
                    },
                    onRearButtonPressed: () => _showContactOptions(context, '+86', order.customerPhone),
                    customerPhone: order.customerPhone,
                    status: 5,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}


Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  if (!await canLaunchUrl(launchUri)) {
    throw '无法拨打电话: $phoneNumber';
  }
  await launchUrl(launchUri);
}