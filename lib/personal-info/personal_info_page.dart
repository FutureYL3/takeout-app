import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('头像：'),
              const SizedBox(width: 20),
              Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('实名认证：xxxxxxxxxxxxxx'),
          const SizedBox(height: 10),
          const Text('个人电话：xxxxxxxxxxxxxx'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 修改资料按钮点击事件
            },
            child: Text('修改资料'),
          ),
        ],
      )
    );
  }
}