import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takeout/order/order_card.dart';
import 'package:takeout/order/order_managing_apis.dart';

import '../welcome/welcome_page.dart';

class OrderPendingPage extends StatefulWidget {
  const OrderPendingPage({super.key});

  @override
  State<OrderPendingPage> createState() => _OrderPendingPageState();
}

class _OrderPendingPageState extends State<OrderPendingPage> with AutomaticKeepAliveClientMixin {
  String _selectedDate = '今日';
  List<OrderCardWithButton>? orders;
  final OrderManagingApiService apiService = OrderManagingApiService();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    getData();
  }

  void getData() async {
    String? phone = await secureStorage.read(key: 'phone');
    int status = 1;
    // 初次加载时默认显示今日订单
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (phone == null) {
      // 如果没有存储手机号，即表示未登录，跳转到欢迎页面
      await Get.offAll(() => const WelcomePage());
      return;
    }
    
    // 初次获取数据时like为null,不进行模糊搜索
    Map<String, dynamic> result = await apiService.getOrders(phone, start, now, status, null, context);
    
    if (result['code'] == 401) {
      Map<String, dynamic> refreshData = await apiService.refreshAccessToken(context);
      if (refreshData['code'] == 409) {
        // 如果refreshToken也过期了，要求重新登录
        await secureStorage.deleteAll();
        await prefs.setBool('Login_Status', false);
        Get.offAll(() => const WelcomePage());
        return;
      }
      if (refreshData['code'] == 1) {
        secureStorage.write(key: 'accessToken', value: refreshData['data']['accessToken']);
        secureStorage.write(key: 'refreshToken', value: refreshData['data']['refreshToken']);
      }
      getData();
      return;
    }

    if (result['code'] == 1) {
      List<dynamic> dataList = result['data'];
      List<OrderCardWithButton> cardList = [];
      for (var item in dataList) {
        int orderId = item['order_Id'];
        String deliveryTime = item['deliveryTime'];
        String customerName = item['user_name'];
        // String customerPhone = item['user_phoneNumber'];
        String customerAddress = item['user_address'];
        String orderAddress = item['merchant_address'];
        List<FoodItem> foodItems = [];
        for (var food in item['orderList']) {
          foodItems.add(FoodItem(food['dish_name'], food['dish_num']));
        }
        cardList.add(OrderCardWithButton(
          orderId: orderId,
          deliveryTime: deliveryTime,
          customerName: customerName,
          customerAddress: customerAddress,
          orderAddress: orderAddress,
          frontButtonText: '接单',
          rearButtonText: '取消',
          foodItems: foodItems,
        ));
      }
      setState(() {
        orders = cardList;
      });

    }
  }

  void regetData() async {
    String? phone = await secureStorage.read(key: 'phone');
    int status = 1;
    DateTime now = DateTime.now();
    DateTime start;
    String like = _searchController.text;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (phone == null) {
      // 如果没有存储手机号，即表示未登录，跳转到欢迎页面
      await Get.offAll(() => const WelcomePage());
      return;
    }

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

    Map<String, dynamic> result = await apiService.getOrders(phone, start, now, status, like, context);
    
    if (result['code'] == 401) {
      Map<String, dynamic> refreshData = await apiService.refreshAccessToken(context);
      if (refreshData['code'] == 409) {
        // 如果refreshToken也过期了，要求重新登录
        await secureStorage.deleteAll();
        await prefs.setBool('Login_Status', false);
        Get.offAll(() => const WelcomePage());
        return;
      }
      if (refreshData['code'] == 1) {
        secureStorage.write(key: 'accessToken', value: refreshData['data']['accessToken']);
        secureStorage.write(key: 'refreshToken', value: refreshData['data']['refreshToken']);
      }
      regetData();
      return;
    }

    if (result['code'] == 1) {
      List<dynamic> dataList = result['data'];
      List<OrderCardWithButton> cardList = [];
      for (var item in dataList) {
        int orderId = item['order_Id'];
        String deliveryTime = item['deliveryTime'];
        String customerName = item['user_name'];
        // String customerPhone = item['user_phoneNumber'];
        String customerAddress = item['user_address'];
        String orderAddress = item['merchant_address'];
        List<FoodItem> foodItems = [];
        for (var food in item['orderList']) {
          foodItems.add(FoodItem(food['dish_name'], food['dish_num']));
        }
        cardList.add(OrderCardWithButton(
          orderId: orderId,
          deliveryTime: deliveryTime,
          customerName: customerName,
          customerAddress: customerAddress,
          orderAddress: orderAddress,
          frontButtonText: '接单',
          rearButtonText: '取消',
          foodItems: foodItems,
        ));
      }
      setState(() {
        orders = cardList;
      });

    }

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
          Expanded(
            child: ListView(
              children: const [
                OrderCardWithButton(
                  orderId: 12,
                  deliveryTime: '12:00',
                  customerName: '王先生',
                  customerAddress: '家属四公寓-1201',
                  orderAddress: 'xxxxxxxxxxxxxxxxx',
                  frontButtonText: '接单',
                  rearButtonText: '取消',
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
                  frontButtonText: '接单',
                  rearButtonText: '取消',
                  foodItems: [
                    FoodItem('好大的乳山生蚝', 12),
                    FoodItem('干拌粉', 2),
                    FoodItem('干拌粉', 2),
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
                  frontButtonText: '接单',
                  rearButtonText: '取消',
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
