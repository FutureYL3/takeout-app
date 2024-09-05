import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget{
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text("忘记密码页面"),
      ),
    );
  }
  
}