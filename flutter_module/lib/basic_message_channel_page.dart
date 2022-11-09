import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasicMessageChannelPage extends StatefulWidget {
  const BasicMessageChannelPage({super.key});

  @override
  State<BasicMessageChannelPage> createState() =>
      _BasicMessageChannelPageState();
}

class _BasicMessageChannelPageState extends State<BasicMessageChannelPage> {
  final BasicMessageChannel _channel = const BasicMessageChannel(
      'basic_message_channel', StandardMessageCodec());

  String data1 = '';
  String data2 = '';
  String data3 = '';

  @override
  void initState() {
    super.initState();

    _channel.setMessageHandler((message) {
      if (message != null && message is String) {
        setState(() {
          data3 = message;
        });
      }
      return Future.value("setMessageHandler");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("BasicMessageChannel"),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () =>
                    sendMessage({'name': 'test1', 'text': 'toPlatform'}),
                child: const Text('发送数据到原生并获得回调'),
              ),
              Text('原生的回调数据:$data1'),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () => sendMessage({'key': 'test2'}),
                child: const Text('发送数据到原生没有回调'),
              ),
              Text('原生的回调数据:$data2'),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () => sendMessage({'title': 'test3'}),
                child: const Text('原生发送给Flutter的消息'),
              ),
              Text('原生主动发送消息:$data3'),
            ],
          ),
        ));
  }

  ///flutter向原生端发送消息
  Future<void> sendMessage(Map<String, dynamic> params) async {
    String? result = await _channel.send(params); //通过send方法向原生发送消息
    if (result != null) {
      if (result == '我是原生的字典!') {
        setState(() {
          data1 = result;
        });
      } else if (result == '我是原生的数组!') {
        setState(() {
          data2 = result;
        });
      }
    }
  }
}
