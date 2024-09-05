import 'package:flutter/material.dart';

class AccountManagementPage extends StatelessWidget {
  const AccountManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 平台Logo
          Container(
            width: 100,
            height: 100,
            color: Colors.grey[300],
            child: const Center(
              child: Text(
                '平台logo',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 当前账号信息
          const Text(
            '当前账号：aaaaaaaaaa10000000',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 40),
          // 退出登录按钮
          ElevatedButton(
            onPressed: () {
              // 处理退出登录的逻辑
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('确认退出登录吗？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () {
                        // 在这里处理实际的退出逻辑
                        Navigator.of(context).pop();
                      },
                      child: const Text('确认'),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: const Text('退出登录'),
          ),
        ],
      ),
    );
  }
}