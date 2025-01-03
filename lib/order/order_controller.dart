/// @Author: yl Future_YL@outlook.com
/// @Date: 2024-09-25
/// @LastEditors: yl Future_YL@outlook.com
/// @LastEditTime: 2024-10-06 16:16
/// @FilePath: lib/order/order_controller.dart
/// @Description: 这是订单控制器类，负责各页面订单数据的获取和更新


import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/common_utils.dart';
import '../welcome/welcome_page.dart';
import './order_model.dart';
import 'order_managing_apis.dart';

class OrderController extends GetxController {
  final OrderManagingApiService apiService = OrderManagingApiService();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  // 集中管理所有状态的订单
  var pendingOrders = <Order>[].obs;
  var acceptedOrders = <Order>[].obs;
  var deliveryingOrders = <Order>[].obs;
  var completedOrders = <Order>[].obs;
  var cancelledOrders = <Order>[].obs;

  bool isPendingOrdersFetched = false;
  bool isAcceptedOrdersFetched = false;
  bool isDeliveryingOrdersFetched = false;
  bool isCompletedOrdersFetched = false;
  bool isCancelledOrdersFetched = false;

  // 从API获取订单数据
  Future<void> fetchPendingOrders(DateTime start, DateTime end, String? like, BuildContext ctx, {required bool isInitFetch}) async {

    // 避免冗余，提取出获取数据的方法
    Future<void> fetchData() async {
      // 实现API调用，获取订单数据并赋值给pendingOrders
      String? phone = await secureStorage.read(key: 'phone');
      int status = 4;
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (phone == null) {
        // 如果没有存储手机号，即表示未登录，跳转到欢迎页面
        await Get.offAll(() => const WelcomePage());
        return;
      }
      
      Map<String, dynamic> result = await apiService.getOrders(phone, start, end, status, like, ctx);

      if (result['code'] == 401) {
        Map<String, dynamic> refreshData = await apiService.refreshAccessToken(ctx);
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
        fetchPendingOrders(start, end, like, ctx, isInitFetch: isInitFetch); // 重新获取数据
        return;
      }

      if (result['code'] == 1) {
        pendingOrders.clear();
        for (var order in result['data']) {
          print(order);
          pendingOrders.add(Order(
            orderId: order['id'],
            number: order['number'],
            deliveryTime: order['deliveryTime'] ?? '',
            customerName: order['name'],
            customerPhone: order['cphone'],
            customerAddress: order['caddress'],
            orderAddress: order['maddress'],
            foodItems: ((order['ordersList'] ?? []) as List).map((item) => FoodItem(item['dishName'], item['dishSales'])).toList(),
            status: status,
            completeTime: order['completeTime'] ?? '', // TODO: 与后端沟通
          ));
        }
        pendingOrders.refresh(); // 通知监听者
      }
    }
    // 避免切换页面后重置先前订单数据
    if (isInitFetch) {
      if (!isPendingOrdersFetched) {

        await fetchData();
        isPendingOrdersFetched = true;

      } else {
        return;
      }
      
    } else {
      await fetchData();
    }  
  }

  // 从API获取订单数据
  Future<void> fetchAcceptedOrders(DateTime start, DateTime end, String? like, BuildContext ctx, {required bool isInitFetch}) async {

    Future<void> fetchData() async {
      // 实现API调用，获取订单数据并赋值给acceptedOrders
      String? phone = await secureStorage.read(key: 'phone');
      int status = 2;
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (phone == null) {
        // 如果没有存储手机号，即表示未登录，跳转到欢迎页面
        await Get.offAll(() => const WelcomePage());
        return;
      }
      
      Map<String, dynamic> result = await apiService.getOrders(phone, start, end, status, like, ctx);

      if (result['code'] == 401) {
        Map<String, dynamic> refreshData = await apiService.refreshAccessToken(ctx);
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
        fetchAcceptedOrders(start, end, like, ctx, isInitFetch: isInitFetch); // 重新获取数据
        return;
      }

      if (result['code'] == 1) {
        acceptedOrders.clear();
        for (var order in result['data']) {
          acceptedOrders.add(Order(
            orderId: order['id'],
            number: order['number'],
            deliveryTime: order['deliveryTime'] ?? '',
            customerName: order['name'],
            customerPhone: order['cphone'],
            customerAddress: order['caddress'],
            orderAddress: order['maddress'],
            foodItems: ((order['ordersList'] ?? []) as List).map((item) => FoodItem(item['dishName'], item['dishSales'])).toList(),
            status: status,
            completeTime: order['completeTime'] ?? '', // TODO: 与后端沟通
          ));
        }
        acceptedOrders.refresh(); // 通知监听者
      }
    }

    if (isInitFetch) {
      if (!isAcceptedOrdersFetched) {
        await fetchData();
        isAcceptedOrdersFetched = true;

      } else {
        return;
      }
    } else {
      fetchData();
    }
  }

  // 从API获取订单数据
  Future<void> fetchDeliveryingOrders(DateTime start, DateTime end, String? like, BuildContext ctx, {required bool isInitFetch}) async {

    Future<void> fetchData() async {
      // 实现API调用，获取订单数据并赋值给deliveryingOrders
      String? phone = await secureStorage.read(key: 'phone');
      int status = 5;
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (phone == null) {
        // 如果没有存储手机号，即表示未登录，跳转到欢迎页面
        await Get.offAll(() => const WelcomePage());
        return;
      }
      
      Map<String, dynamic> result = await apiService.getOrders(phone, start, end, status, like, ctx);

      if (result['code'] == 401) {
        Map<String, dynamic> refreshData = await apiService.refreshAccessToken(ctx);
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
        fetchDeliveryingOrders(start, end, like, ctx, isInitFetch: isInitFetch); // 重新获取数据
        return;
      }

      if (result['code'] == 1) {
        deliveryingOrders.clear();
        for (var order in result['data']) {
          deliveryingOrders.add(Order(
            orderId: order['id'],
            number: order['number'],
            deliveryTime: order['deliveryTime'] ?? '',
            customerName: order['name'],
            customerPhone: order['cphone'],
            customerAddress: order['caddress'],
            orderAddress: order['maddress'],
            foodItems: ((order['ordersList'] ?? []) as List).map((item) => FoodItem(item['dishName'], item['dishSales'])).toList(),
            status: status,
            completeTime: order['completeTime'] ?? '', // TODO: 与后端沟通
          ));
        }
        deliveryingOrders.refresh(); // 通知监听者
      }

      deliveryingOrders.refresh();
    }

    if (isInitFetch) {
      if (!isDeliveryingOrdersFetched) {
        await fetchData();
        isDeliveryingOrdersFetched = true;
      } else {
        return;
      }
    } else {
      await fetchData();
    }
    
    
  }

  // 从API获取订单数据
  Future<void> fetchCompletedOrders(DateTime start, DateTime end, String? like, BuildContext ctx, {required bool isInitFetch}) async {

    Future<void> fetchData() async {
      // 实现API调用，获取订单数据并赋值给deliveryingOrders
      String? phone = await secureStorage.read(key: 'phone');
      int status = 6;
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (phone == null) {
        // 如果没有存储手机号，即表示未登录，跳转到欢迎页面
        await Get.offAll(() => const WelcomePage());
        return;
      }
      
      Map<String, dynamic> result = await apiService.getOrders(phone, start, end, status, like, ctx);

      if (result['code'] == 401) {
        Map<String, dynamic> refreshData = await apiService.refreshAccessToken(ctx);
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
        fetchCompletedOrders(start, end, like, ctx, isInitFetch: isInitFetch); // 重新获取数据
        return;
      }

      if (result['code'] == 1) {
        completedOrders.clear();
        for (var order in result['data']) {
          completedOrders.add(Order(
            orderId: order['id'],
            number: order['number'],
            deliveryTime: order['deliveryTime'] ?? '',
            customerName: order['name'],
            customerPhone: order['cphone'],
            customerAddress: order['caddress'],
            orderAddress: order['maddress'],
            foodItems: ((order['ordersList'] ?? []) as List).map((item) => FoodItem(item['dishName'], item['dishSales'])).toList(),
            status: status,
            completeTime: order['completeTime'] ?? '', // TODO: 与后端沟通
          ));
        }
        completedOrders.refresh(); // 通知监听者
      }
    }

    if (isInitFetch) {
      if (!isCompletedOrdersFetched) {
        await fetchData();
        isCompletedOrdersFetched = true;
      } else {
        return;
      }
    } else {
      await fetchData();
    }
  }

  // 从API获取订单数据
  Future<void> fetchCancelledOrders(DateTime start, DateTime end, String? like, BuildContext ctx, {required bool isInitFetch}) async {

    Future<void> fetchData() async {
      // 实现API调用，获取订单数据并赋值给deliveryingOrders
      String? phone = await secureStorage.read(key: 'phone');
      int status = 5;
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (phone == null) {
        // 如果没有存储手机号，即表示未登录，跳转到欢迎页面
        await Get.offAll(() => const WelcomePage());
        return;
      }
      
      Map<String, dynamic> result = await apiService.getOrders(phone, start, end, status, like, ctx);

      if (result['code'] == 401) {
        Map<String, dynamic> refreshData = await apiService.refreshAccessToken(ctx);
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
        fetchCancelledOrders(start, end, like, ctx, isInitFetch: isInitFetch); // 重新获取数据
        return;
      }

      if (result['code'] == 1) {
        cancelledOrders.clear();
        for (var order in result['data']) {
          cancelledOrders.add(Order(
            orderId: order['id'],
            number: order['number'],
            deliveryTime: order['deliveryTime'] ?? '',
            customerName: order['name'],
            customerPhone: order['cphone'],
            customerAddress: order['caddress'],
            orderAddress: order['maddress'],
            foodItems: ((order['ordersList'] ?? []) as List).map((item) => FoodItem(item['dishName'], item['dishSales'])).toList(),
            status: status,
            completeTime: order['completeTime'] ?? '', // TODO: 与后端沟通
          ));
        }
        cancelledOrders.refresh(); // 通知监听者
      }
    }

    if (isInitFetch) {
      if (!isCancelledOrdersFetched) {
        await fetchData();
        isCancelledOrdersFetched = true;
      } else {
        return;
      }
    } else {
      await fetchData();
    }
    
  }

  // 根据订单ID更新订单状态，并可选择是否同步更新服务器
  Future<void> updateOrderStatus(RxList<Order> originList, int orderId, int newStatus, BuildContext ctx, String successTitle, String successDesc) async {
    // 找到对应的订单
    int index = originList.indexWhere((order) => order.orderId == orderId);

    if (index == -1) {
      showSnackBar('未知错误', '请稍候重试', ContentType.failure, ctx);
      return;
    }

    String? phone = await secureStorage.read(key: 'phone');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (phone == null) {
      // 如果没有存储手机号，即表示未登录，跳转到欢迎页面
      await Get.offAll(() => const WelcomePage());
      return;
    }

    Map<String, dynamic> result = await apiService.updateOrders(phone, orderId, newStatus, ctx);

    if (result['code'] == 401) {
      Map<String, dynamic> refreshData = await apiService.refreshAccessToken(ctx);
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
      updateOrderStatus(originList, orderId, newStatus, ctx, successTitle, successDesc); // 重新尝试更新
      return;
    }


    if (result['code'] == 1) {
      // 更新本地状态
      Order order = originList[index];
      originList.removeAt(index);
      RxList<Order> targetList = <Order>[].obs;
      switch (newStatus) {
        case 1:
          targetList = pendingOrders;
          break;
        case 2:
          targetList = acceptedOrders;
          break;
        case 3:
          targetList = deliveryingOrders;
          break;
        case 4:
          targetList = completedOrders;
          break;
        case 5:
          targetList = cancelledOrders;
          break;
        default:
          break;
      }
      targetList.insert(0, order);
      originList.refresh(); // 通知监听者
      targetList.refresh(); // 通知监听者
      showSnackBar(successTitle, successDesc, ContentType.success, ctx);
    }
  }
}