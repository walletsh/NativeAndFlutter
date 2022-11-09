import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChannelPage extends StatefulWidget {
  const MethodChannelPage({super.key});

  @override
  State<MethodChannelPage> createState() => _MethodChannelPageState();
}

class _MethodChannelPageState extends State<MethodChannelPage> {
  //定义一个MethodChannel通道,同时约定通道名称method_channel.
  static const MethodChannel _channel = MethodChannel('method_channel');

  String detail = '未知';

  String methodName = '';
  String arg = '';

  @override
  void initState() {
    super.initState();

    _channel.setMethodCallHandler((call) {
      setState(() {
        if (call.method == 'ios_method') {
          methodName = call.method;
          arg = call.arguments.toString();
        }
      });
      return Future.value("setMethodCallHandler");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("data"),
        ),
        body: Center(
          child: Column(children: [
            const SizedBox(height: 60),
            OutlinedButton(
                onPressed: getTextFromPlatform,
                child: const Text('MethodChannel通信')),
            const Text('点击按钮,调用MethodChannel方法,获得从原生端返回的字符串'),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('当前电池电量:'),
                Text(detail),
              ],
            ),
            const SizedBox(height: 60),
            Text("ios方法：$methodName"),
            Text("参数：$arg"),
          ]),
        ));
  }

  Future<void> getTextFromPlatform() async {
    String? result = await _channel.invokeMethod(
        'method_channel_test', {"key1": "title", "key2": "picUrl"});
    if (result != null) {
      setState(() {
        detail = '$result%';
      });
    }
  }
}
