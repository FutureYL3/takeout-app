/// @Author: yl Future_YL@outlook.com
/// @Date: 2024-09-23 
/// @LastEditors: yl Future_YL@outlook.com
/// @LastEditTime: 2024-10-06 16:16
/// @FilePath: lib/order/order_card.dart
/// @Description: 这是单个订单展示卡片小组件

import 'package:flutter/material.dart';

import 'order_model.dart';

// ignore: must_be_immutable
class OrderCardWithButton extends StatefulWidget {
  final int orderId;
  final String number;
  final String deliveryTime;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String orderAddress;
  final String frontButtonText;
  final String rearButtonText;
  final List<FoodItem> foodItems;
  final VoidCallback onFrontButtonPressed;
  final VoidCallback onRearButtonPressed;

  int status = -1;

  OrderCardWithButton({super.key, required this.orderId, required this.number, required this.deliveryTime, required this.customerName, required this.customerPhone, required this.customerAddress, required this.orderAddress, required this.frontButtonText, required this.rearButtonText, required this.foodItems, required this.status, required this.onFrontButtonPressed, required this.onRearButtonPressed,});


  @override
  State<StatefulWidget> createState() => _OrderCardWithButtonState();
}

class _OrderCardWithButtonState extends State<OrderCardWithButton> {
  bool isExpanded = false; // 控制卡片是否展开

  Widget _buildFoodItems(List<FoodItem> items) {
    return Column(
      children: items.map((item) {
        return Row(
          children: [
            Text(item.name),
            const Spacer(),
            Text('x${item.count}'),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '#${widget.number.toString()}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text("${widget.deliveryTime.split("T")[0].substring(5, 10)}  ${widget.deliveryTime.split("T")[1].substring(0, 5)}"),
                const Spacer(),
                
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onFrontButtonPressed,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(40, 30),
                    ),
                    child: Text(widget.frontButtonText),
                  ),
                ),
                
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onRearButtonPressed,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(40, 30),
                    ),
                    child: Text(widget.rearButtonText),
                  ),
                )
                
              ],
            ),
            Row(
              children: [
                Text(widget.customerName),
                const SizedBox(width: 10),
                Text(widget.customerAddress)
              ],
            ),
            const SizedBox(height: 4),
            Text(
              widget.orderAddress,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // 使用 AnimatedCrossFade 实现展开和折叠动画
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 100),
              firstChild: _buildFoodItems(widget.foodItems.take(2).toList()), // 折叠时只显示前两个
              secondChild: _buildFoodItems(widget.foodItems), // 展开时显示全部
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded; // 切换展开状态
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class OrderCardWithoutButton extends StatefulWidget {
  final int orderId;
  final String number;
  final String deliveryTime;
  final String customerName;
  final String customerAddress;
  final String orderAddress;
  final String? completeTime;
  final String hintText;
  final List<FoodItem> foodItems;

  int status = -1;

  OrderCardWithoutButton({super.key, required this.orderId, required this.number, required this.deliveryTime, required this.customerName, required this.customerAddress, required this.orderAddress, this.completeTime, required this.hintText, required this.foodItems, required this.status});
  
  @override
  State<StatefulWidget> createState() => _OrderCardWithoutButtonState();
}

class _OrderCardWithoutButtonState extends State<OrderCardWithoutButton> {
  bool isExpanded = false; // 控制卡片是否展开

  Widget _buildFoodItems(List<FoodItem> items) {
    return Column(
      children: items.map((item) {
        return Row(
          children: [
            Text(item.name),
            const Spacer(),
            Text('x${item.count}'),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "#${widget.number.toString()}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text("${widget.deliveryTime.split("T")[0].substring(5, 10)}  ${widget.deliveryTime.split("T")[1].substring(0, 5)}"),
                const Spacer(),
                Text(widget.completeTime ?? ''),
                Text(widget.hintText)
              ],
            ),
            const SizedBox(height: 8),
            Text(widget.customerAddress),
            const SizedBox(height: 4),
            Text(
              widget.orderAddress,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // 使用 AnimatedCrossFade 实现展开和折叠动画
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 100),
              firstChild: _buildFoodItems(widget.foodItems.take(2).toList()), // 折叠时只显示前两个
              secondChild: _buildFoodItems(widget.foodItems), // 展开时显示全部
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded; // 切换展开状态
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}