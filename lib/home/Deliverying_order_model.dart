class DeliveryingOrder {
  final String customerName;
  final String deliveryAddr;
  final String mapUrl;

  DeliveryingOrder({
    required this.customerName,
    required this.deliveryAddr,
    required this.mapUrl,
  });

  static fromJson(e) {}
}