import 'package:flutter/material.dart';
import 'package:takeout/order/order_card.dart';

class OrderDeliveringPage extends StatefulWidget {
  const OrderDeliveringPage({super.key});

  @override
  State<OrderDeliveringPage> createState() => _OrderDeliveringPageState();
}

class _OrderDeliveringPageState extends State<OrderDeliveringPage> with AutomaticKeepAliveClientMixin {
  String _selectedDate = '今日';
  String? like;
  List<OrderCardWithButton>? orders;

  @override
  void initState() {
    super.initState();
    // TODO: 发出网络请求获取订单
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
                items: <String>['今日', '明日'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  // 这里可以实现下拉框选择后的逻辑
                  // TODO: 发出网络请求更新页面订单内容，然后刷新页面
                  setState(() {
                    _selectedDate = value!;
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.search),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '搜索订单',
                        ),
                        onChanged: (value) {
                          // TODO:这里可以实现搜索逻辑
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 订单卡片列表
          Expanded(
            child: ListView(
              children: const [
                OrderCardWithButton(
                  orderId: 12,
                  deliveryTime: '12:00',
                  customerName: '王先生',
                  customerAddress: '家属四公寓-1201',
                  orderAddress: 'xxxxxxxxxxxxxxxxx',
                  frontButtonText: '已送达',
                  rearButtonText: '联系用户',
                  foodItems: [
                    FoodItem('鱼香肉丝', 1),
                    FoodItem('宫保鸡丁', 2),
                  ],
                ),
                // SizedBox(height: 10),
                OrderCardWithButton(
                  orderId: 13,
                  deliveryTime: '12:00',
                  customerName: '赵女士',
                  customerAddress: '家属四公寓-1301',
                  orderAddress: 'xxxxxxxxxxxxxxxxx',
                  frontButtonText: '已送达',
                  rearButtonText: '联系用户',
                  foodItems: [
                    FoodItem('好大的乳山生蚝', 12),
                    FoodItem('干拌粉', 2),
                  ],
                ),
                // SizedBox(height: 10),
                OrderCardWithButton(
                  orderId: 14,
                  deliveryTime: '12:00',
                  customerName: '刘先生',
                  customerAddress: '家属四公寓-1401',
                  orderAddress: 'xxxxxxxxxxxxxxxxx',
                  frontButtonText: '已送达',
                  rearButtonText: '联系用户',
                  foodItems: [
                    FoodItem('烤肉拌饭', 1),
                    FoodItem('农夫山泉', 2),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
