/// @Author: yl Future_YL@outlook.com
/// @Date: 2024-09-20 
/// @LastEditors: yl Future_YL@outlook.com
/// @LastEditTime: 2024-10-06 16:16
/// @FilePath: lib/order/order_accepted_page.dart
/// @Description: 这是已接单订单页面

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'order_card.dart';
import 'order_controller.dart';

class OrderAcceptedPage extends StatefulWidget {
  const OrderAcceptedPage({super.key});

  @override
  State<OrderAcceptedPage> createState() => _OrderAcceptedPageState();
}

class _OrderAcceptedPageState extends State<OrderAcceptedPage> with AutomaticKeepAliveClientMixin {
  late String _selectedDate = '今日';
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
      _selectedDate = prefs.getString('accepted_selectedDate') ?? '今日';
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

    orderController.fetchAcceptedOrders(start, now, like, context, isInitFetch: false);

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
                  // 实现下拉框选择后的逻辑
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('accepted_selectedDate', value!);
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

              if (orderController.acceptedOrders.isEmpty) {
                return const Center(child: Text('暂无已接单订单'));
              }

              return ListView.builder(
                itemCount: orderController.acceptedOrders.length,
                itemBuilder: (context, index) {
                  var order = orderController.acceptedOrders[index];
                  return OrderCardWithButton(
                    orderId: order.orderId,
                    number: order.number,
                    deliveryTime: order.deliveryTime,
                    customerName: order.customerName,
                    customerAddress: order.customerAddress,
                    orderAddress: order.orderAddress,
                    frontButtonText: '已取餐',
                    rearButtonText: '取消',
                    foodItems: order.foodItems,
                    onFrontButtonPressed: () {
                      // 更新订单状态为 deliverying
                      orderController.updateOrderStatus(orderController.acceptedOrders, order.orderId, 3, context, '取餐成功', '');
                    },
                    onRearButtonPressed: () {
                      // 更新订单状态为 cancelled
                      orderController.updateOrderStatus(orderController.acceptedOrders, order.orderId, 5, context, '取消成功', '');
                    },
                    customerPhone: order.customerPhone,
                    status: 2,
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
