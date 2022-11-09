import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventChannelPage extends StatefulWidget {
  const EventChannelPage({super.key});

  @override
  State<EventChannelPage> createState() => _EventChannelPageState();
}

class _EventChannelPageState extends State<EventChannelPage> {
  final EventChannel _channel = const EventChannel('event_channel');
  StreamSubscription? _streamSubscription;

  String _platformMessage = '未收到消息';

  @override
  void initState() {
    super.initState();
    _enableEventReceiver();
  }

  void _enableEventReceiver() {
    _streamSubscription = _channel.receiveBroadcastStream(
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]).listen((event) {
      int s = 0;
      if (event is int) {
        s = event;
      }

      setState(() {
        _platformMessage = '$s s';
      });
    }, onError: (error) {
      setState(() {
        _platformMessage = error.message;
      });
    }, onDone: () {
      setState(() {
        _platformMessage = "接收完成";
      });
    }, cancelOnError: true);
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EventChannel"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text('原生返回的字符串:'),
            Text(_platformMessage),
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: () {
                  _streamSubscription?.cancel();
                },
                child: const Text("取消"))
          ],
        ),
      ),
    );
  }
}
