/// @Author: yl Future_YL@outlook.com
/// @Date: 2024-09-25 
/// @LastEditors: yl Future_YL@outlook.com
/// @LastEditTime: 2024-10-06 16:16
/// @FilePath: lib/order/order_model.dart
/// @Description: 这是订单的数据模型


class Order {
  final int orderId;
  final String number;
  final String deliveryTime;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String orderAddress;
  final List<FoodItem> foodItems;
  final String? completeTime;
  int status = -1;

  Order({
    required this.orderId,
    required this.number,
    required this.deliveryTime,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.orderAddress,
    required this.foodItems,
    required this.status,
    this.completeTime,
  });
}

class FoodItem {
  final String name;
  final int count;

  const FoodItem(this.name, this.count);
}