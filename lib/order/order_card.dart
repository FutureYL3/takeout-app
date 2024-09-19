import 'package:flutter/material.dart';

class OrderCardWithButton extends StatelessWidget {
  final int? orderId;
  final String? deliveryTime;
  final String? customerName;
  final String? customerAddress;
  final String? orderAddress;
  final String? frontButtonText;
  final String? rearButtonText;
  final List<FoodItem>? foodItems;

  const OrderCardWithButton({super.key, this.orderId, this.deliveryTime, this.customerName, this.customerAddress, this.orderAddress, this.frontButtonText, this.rearButtonText, this.foodItems});

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
                  orderId.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text(deliveryTime!),
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
                      child: Text(frontButtonText!),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 根据按钮的不同，实现不同的逻辑
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(60, 30),
                      ),
                      child: Text(rearButtonText!),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(customerAddress!),
            const SizedBox(height: 4),
            Text(
              orderAddress!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: foodItems!.take(2).map((item) =>
                Row(
                  children: [
                    Text(item.name),
                    const Spacer(),
                    Text('x${item.count}'),
                  ],
                )
              ).toList(),
            ),
            const SizedBox(height: 4),
            // TODO: 点击后展示全部订单内容
            const Align(
              alignment: Alignment.center,
              child: Icon(Icons.expand_more),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCardWithoutButton extends StatelessWidget {
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
                  orderId.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text(deliveryTime!),
                const Spacer(),
                Text(completeTime ?? ''),
                Text(hintText!)
              ],
            ),
            const SizedBox(height: 8),
            Text(customerAddress!),
            const SizedBox(height: 4),
            Text(
              orderAddress!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: foodItems!.take(2).map((item) =>
                Row(
                  children: [
                    Text(item.name),
                    const Spacer(),
                    Text('x${item.count}'),
                  ],
                )
              ).toList(),
            ),
            const SizedBox(height: 4),
            // TODO: 点击后展示全部订单内容
            const Align(
              alignment: Alignment.center,
              child: Icon(Icons.expand_more),
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