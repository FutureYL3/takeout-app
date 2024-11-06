import 'package:flutter/material.dart';

import 'Deliverying_order_model.dart';


class DeliveryOrderCard extends StatefulWidget {
  final DeliveryingOrder order;

  const DeliveryOrderCard({super.key, required this.order});

  @override
  DeliveryOrderCardState createState() => DeliveryOrderCardState();
}

class DeliveryOrderCardState extends State<DeliveryOrderCard> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _toggleExpanded, // 点击 Card 切换展开/折叠状态
        child: Padding(
          padding: const EdgeInsets.all(8.0), // 增加一些内边距
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题部分
              ListTile(
                contentPadding: EdgeInsets.zero, // 移除默认内边距
                title: Text('${widget.order.customerName}   ${widget.order.deliveryAddr}'),
                trailing: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                ),
              ),
              // 根据状态显示图片
              if (_isExpanded)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  color: Colors.grey[300],
                  height: 150,
                  width: double.infinity, // 确保图片占满宽度
                  child: Center(
                    child: Image.network(
                      widget.order.mapUrl,
                      width: 200,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('图片加载失败');
                      },
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
