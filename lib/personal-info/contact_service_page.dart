import 'package:flutter/material.dart';

class ContactServicePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  ContactServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // // 输入框
          // TextField(
          //   controller: _controller,
          //   maxLines: 5,
          //   decoration: InputDecoration(
          //     hintText: '请输入您遇到的问题……',
          //     border: const OutlineInputBorder(),
          //     filled: true,
          //     fillColor: Colors.grey[200],
          //   ),
          // ),
          // const SizedBox(height: 20),
          // // 提交按钮
          // Center(
          //   child: ElevatedButton(
          //     onPressed: () {
          //       // 提交按钮点击事件
          //       // 你可以在这里处理用户提交的信息
          //     },
          //     child: const Text('提交'),
          //   ),
          // ),
          // const SizedBox(height: 20),
          // 联系方式提示信息
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          const Text(
            '如您的问题没有解决或客服没有在三个工作日内回复您，您可以选择以下方式联系：',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 10),
          const Text(
            '客服电话：000-00000000\n客服微信：xxxxxxxxxxxxxx\n……',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}