import 'package:flutter/material.dart';

class OrderCardWithButton extends StatefulWidget {
  final int? orderId;
  final String? deliveryTime;
  final String? customerName;
  final String? customerPhone;
  final String? customerAddress;
  final String? orderAddress;
  final String? frontButtonText;
  final String? rearButtonText;
  final List<FoodItem>? foodItems;

  const OrderCardWithButton({super.key, this.orderId, this.deliveryTime, this.customerName, this.customerPhone, this.customerAddress, this.orderAddress, this.frontButtonText, this.rearButtonText, this.foodItems});


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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.orderId.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text(widget.deliveryTime!),
                const Spacer(),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 根据按钮的不同，实现不同的逻辑
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(60, 30),
                      ),
                      child: Text(widget.frontButtonText!),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 根据按钮的不同，实现不同的逻辑
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(60, 30),
                      ),
                      child: Text(widget.rearButtonText!),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(widget.customerAddress!),
            const SizedBox(height: 4),
            Text(
              widget.orderAddress!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // 使用 AnimatedCrossFade 实现展开和折叠动画
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 100),
              firstChild: _buildFoodItems(widget.foodItems!.take(2).toList()), // 折叠时只显示前两个
              secondChild: _buildFoodItems(widget.foodItems!), // 展开时显示全部
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

class OrderCardWithoutButton extends StatefulWidget {
  final int? orderId;
  final String? deliveryTime;
  final String? customerName;
  final String? customerAddress;
  final String? orderAddress;
  final String? completeTime;
  final String? hintText;
  final List<FoodItem>? foodItems;

  const OrderCardWithoutButton({super.key, this.orderId, this.deliveryTime, this.customerName, this.customerAddress, this.orderAddress, this.completeTime, this.hintText, this.foodItems});
  
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
              children: [
                Text(
                  widget.orderId.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text(widget.deliveryTime!),
                const Spacer(),
                Text(widget.completeTime ?? ''),
                Text(widget.hintText!)
              ],
            ),
            const SizedBox(height: 8),
            Text(widget.customerAddress!),
            const SizedBox(height: 4),
            Text(
              widget.orderAddress!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // 使用 AnimatedCrossFade 实现展开和折叠动画
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 100),
              firstChild: _buildFoodItems(widget.foodItems!.take(2).toList()), // 折叠时只显示前两个
              secondChild: _buildFoodItems(widget.foodItems!), // 展开时显示全部
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

class FoodItem {
  final String name;
  final int count;

  const FoodItem(this.name, this.count);
}