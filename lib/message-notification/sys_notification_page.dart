import 'package:flutter/material.dart';
import 'package:kssdt/utils/common_utils.dart';
import './msg_notification_apis.dart';
import 'sys_notification_model.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String _selectedDate = '今日';
  final TextEditingController _searchController = TextEditingController();
  final MsgNotificationApiService msgNotificationApiService = MsgNotificationApiService();
  List<SysNotification> sysNotification = [];

  void getSysNotification() async {
    Map<String, dynamic> response = await msgNotificationApiService.getSystemNotifications(_selectedDate, _searchController.text, context);

    checkForTokenRefresh(response, context, getSysNotification);

    if (response['code'] == 1) {
      List<dynamic> data = response['data'];
      List<SysNotification> notifications = data.map((e) => SysNotification(title: e['title'], content: e['content'], releaseTime: e['releaseTime'])).toList();

      setState(() {
        sysNotification = notifications;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSysNotification();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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

                    getSysNotification();
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
                          onTap: () async {
                            getSysNotification();
                          }, 
                          child: const Icon(Icons.search),
                        )
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '搜索通知',
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
              children: sysNotification.map((e) => ListTile(
                title: Text(e.title),
                subtitle: Text(e.content),
                trailing: Text(e.releaseTime),
              )).toList(),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}