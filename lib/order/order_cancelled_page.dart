/// @Author: yl Future_YL@outlook.com
/// @Date: 2024-09-20 
/// @LastEditors: yl Future_YL@outlook.com
/// @LastEditTime: 2024-10-06 16:16
/// @FilePath: lib/order/order_cancelled_page.dart
/// @Description: 这是已取消订单页面

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'order_card.dart';
import 'order_controller.dart';

class OrderCancelledPage extends StatefulWidget {
  const OrderCancelledPage({super.key});

  @override
  State<OrderCancelledPage> createState() => _OrderCancelledPageState();
}

class _OrderCancelledPageState extends State<OrderCancelledPage> with AutomaticKeepAliveClientMixin {
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
      _selectedDate = prefs.getString('cancelled_selectedDate') ?? '今日';
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

    orderController.fetchCancelledOrders(start, now, like, context, isInitFetch: false);

  }  


  @override
  bool get wantKeepAlive => true; // 确保页面在切换时保持活动状态

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
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('cancelled_selectedDate', value!);
                  // 实现下拉框选择后的逻辑
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

          // 订单卡片列表
          // 使用 Obx 监听订单列表的变化
          Expanded(
            child: Obx(() {
              final OrderController orderController = Get.find<OrderController>();

              if (orderController.cancelledOrders.isEmpty) {
                return const Center(child: Text('暂无已取消订单'));
              }

              return ListView.builder(
                itemCount: orderController.cancelledOrders.length,
                itemBuilder: (context, index) {
                  var order = orderController.cancelledOrders[index];
                  return OrderCardWithoutButton(
                    orderId: order.orderId,
                    number: order.number,
                    deliveryTime: order.deliveryTime,
                    customerName: order.customerName,
                    customerAddress: order.customerAddress,
                    orderAddress: order.orderAddress,
                    hintText: '已取消', 
                    foodItems: order.foodItems,
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
