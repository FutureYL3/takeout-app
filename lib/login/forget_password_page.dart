import 'package:flutter/material.dart';
import 'dart:async';

class ForgetPasswordPage extends StatefulWidget{
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>{
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  int _countdown = 60;
  Timer? _timer;
  bool _canResend = true;

  // 开始倒计时
  void _startCountdown() {
    setState(() {
      _canResend = false;
      _countdown = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 标题
            Text(
              '找回密码',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),

            // 手机号输入框
            Row(
              children: [
                Text('手机号'),
                Spacer(),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '请输入手机号',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // 验证码输入框和获取验证码按钮
            Row(
              children: [
                Text('验证码'),
                Spacer(),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '请输入验证码',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _canResend ? _startCountdown : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(100, 50),
                    textStyle: TextStyle(fontSize: 14),
                  ),
                  child: Text(_canResend ? '获取验证码' : '(${_countdown}s)'),
                ),
              ],
            ),
            SizedBox(height: 40),

            // 下一步按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 下一步的操作
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black),
                  ),
                  // primary: Colors.white,
                  // onPrimary: Colors.black,
                ),
                child: Text('下一步'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}  