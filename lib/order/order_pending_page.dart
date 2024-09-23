import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order_card.dart';
import 'order_controller.dart';

class OrderPendingPage extends StatefulWidget {
  const OrderPendingPage({super.key});

  @override
  State<OrderPendingPage> createState() => _OrderPendingPageState();
}

class _OrderPendingPageState extends State<OrderPendingPage> with AutomaticKeepAliveClientMixin {
  String _selectedDate = '今日';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    getData();
  }

  void getData() async {
    // 初次加载时默认显示今日订单
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day);
    final OrderController orderController = Get.find<OrderController>();

    orderController.fetchPendingOrders(start, now, null, context, isInitFetch: true);
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

    orderController.fetchPendingOrders(start, now, like, context, isInitFetch: false);

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
                onChanged: (value) {
                  // 实现下拉框选择后的逻辑
                  setState(() {
                    _selectedDate = value!;
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

              if (orderController.pendingOrders.isEmpty) {
                return const Center(child: Text('暂无待处理订单'));
              }

              return ListView.builder(
                itemCount: orderController.pendingOrders.length,
                itemBuilder: (context, index) {
                  var order = orderController.pendingOrders[index];
                  return OrderCardWithButton(
                    orderId: order.orderId,
                    deliveryTime: order.deliveryTime,
                    customerName: order.customerName,
                    customerAddress: order.customerAddress,
                    orderAddress: order.orderAddress,
                    frontButtonText: '接单',
                    rearButtonText: '取消',
                    foodItems: order.foodItems,
                    onFrontButtonPressed: () {
                      // 更新订单状态为 accepted
                      orderController.updateOrderStatus(orderController.pendingOrders, order.orderId, 2, context);
                    },
                    onRearButtonPressed: () {
                      // 更新订单状态为 cancelled
                      orderController.updateOrderStatus(orderController.pendingOrders, order.orderId, 5, context);
                    },
                    customerPhone: order.customerPhone,
                    status: 1,
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
