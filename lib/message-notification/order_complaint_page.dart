import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:kssdt/utils/common_utils.dart';

import 'msg_notification_apis.dart';
import 'order_complaint_model.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<ComplaintsPage> {
  String _selectedDate = '今日';
  final TextEditingController _searchController = TextEditingController();
  List<OrderComplaint> orderComplaints = [];
  final MsgNotificationApiService msgNotificationApiService = MsgNotificationApiService();

  void getOrderComplaints() async {
    Map<String, dynamic> response = await msgNotificationApiService.getUserComplaints(_selectedDate, _searchController.text, context);

    checkForTokenRefresh(response, context, getOrderComplaints);

    if (response['code'] == 1) {
      List<dynamic> data = response['data'];
      List<OrderComplaint> complaints = data.map((e) => OrderComplaint(id: e['id'], appealType: e['appealType'], complaintsContent: e['complaintsContent']
      , complaintsTime: e['complaintsTime'], customer: e['customer'])).toList();

      setState(() {
        orderComplaints = complaints;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getOrderComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
                  onChanged: (value) async {
                    // 实现下拉框选择后的逻辑
                    setState(() {
                      _selectedDate = value!;
                    });
                    getOrderComplaints();
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
                          onTap: () {
                            getOrderComplaints();
                          }, 
                          child: const Icon(Icons.search),
                        )
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '搜索申诉',
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
            ListView(
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              children: 
              orderComplaints.map((e) {
                Widget w;
                if (e.appealType == 0) {
                  w = ElevatedButton(onPressed: () {_showComplaintDialog(e, context);}, child: const Text('处理'),);
                } else if (e.appealType == 1) {
                  w = const Text("已处理");
                }
                else if (e.appealType == 2) {
                  w = const Text("已申诉");
                } else {
                  w = const Text("未知");
                }
                
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('用户${e.customer}'),
                  subtitle: Text(e.complaintsContent),
                  trailing: w,
                );
              }).toList(),
              // [
              //   ListTile(
              //     leading: const Icon(Icons.person),
              //     title: Text('用户aaa'),
              //     subtitle: Text('订单超时，外卖员态度差'),
              //     trailing: ElevatedButton(
              //       onPressed: () {
              //         _showComplaintDialog(OrderComplaint(id: 1, appealType: 1, complaintsContent: "222", complaintsTime: "13:10", customer: "张三"), context);
              //       },
              //       child: Text('处理'),
              //     ),
              //   ),
              // ],
            )
          ],
        ),
      ),
    );
  }

  void _showComplaintDialog(OrderComplaint c, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('投诉用户：${c.customer}'),
              const SizedBox(height: 5),
              Text('投诉时间：${c.complaintsTime}'),
              const SizedBox(height: 5),
              Text('投诉原因：${c.complaintsContent}'),
              const SizedBox(height: 5),
              const Text("系统处理：扣款50元"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // 封装需要重复执行的逻辑为一个闭包
                f() async {
                  Map<String, dynamic> response = await msgNotificationApiService.acceptComplaint(c.id, context);

                  // 检查 token 是否需要刷新
                  checkForTokenRefresh(response, context, f);

                  // 根据响应结果处理逻辑
                  if (response['code'] == 1) {
                    showSnackBar("接受成功", "您已接收用户${c.customer}的投诉", ContentType.success, context);
                  }

                  // 获取最新的投诉订单
                  getOrderComplaints();

                  // 关闭当前页面
                  Navigator.of(context).pop();
                }

                // 首次调用逻辑
                await f();
              },
              child: Container(
                color: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text('接受', style: TextStyle(color: Colors.white)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 可在这里添加申诉逻辑
                _showAppealDialog(c, context);
              },
              child: Container(
                color: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text('申诉', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAppealDialog(OrderComplaint c, BuildContext context) {
    TextEditingController appealController = TextEditingController();
    List<String> imageList = []; // 上传的图片列表

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('申诉说明'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: appealController,
                maxLines: 5,
                maxLength: 400,
                decoration: const InputDecoration(
                  hintText: '请说明申诉的理由和详情',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  // 显示已上传图片的缩略图
                  for (var imageUrl in imageList)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                  // 添加图片按钮
                  if (imageList.length < 3)
                    GestureDetector(
                      onTap: () async {
                        if (imageList.length >= 3) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('最多上传3张图片')),
                          );
                          return;
                        }
                        // 上传图片逻辑
                        msgNotificationApiService.uploadImage(imageList, context);
                        
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.green[50],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add, color: Colors.green),
                            Text(
                              '${imageList.length}/3',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              )
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // 将提交申诉逻辑封装为闭包
                f() async {
                  Map<String, dynamic> response = await msgNotificationApiService.submitAppeal(
                    c.id,
                    appealController.text,
                    imageList,
                    context,
                  );

                  // 检查 token 是否过期
                  checkForTokenRefresh(response, context, f);

                  // 根据响应结果处理逻辑
                  if (response['code'] == 1) {
                    showSnackBar("申诉提交成功", "您已提交对用户${c.customer}投诉的申诉", ContentType.success, context);
                  }

                  // 更新订单投诉
                  getOrderComplaints();

                  // 关闭当前页面
                  Navigator.of(context).pop();
                }

                // 首次调用申诉逻辑
                await f();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('提交', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('再想想'),
            ),
          ],
        );
      },
    );
  }
}