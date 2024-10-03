class Order {
  final String orderId;
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