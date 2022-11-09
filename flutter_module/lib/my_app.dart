import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MethodChannel _oneChannel = const MethodChannel('one_page');
  final MethodChannel _twoChannel = const MethodChannel('two_page');
  final BasicMessageChannel _messageChannel =
      const BasicMessageChannel('messgaeChannel', StandardMessageCodec());

  String pageIndex = 'one';
  Map<String, String> pageOneArguments = {};
  Map<String, String> pageTwoArguments = {};

  String nativeMessage = "";

  @override
  void initState() {
    super.initState();

    _oneChannel.setMethodCallHandler((call) {
      setState(() {
        if (call.method == 'one') {
          pageIndex = call.method;
          pageOneArguments = call.arguments;
        }
      });
      return Future.value("one_page: flutter 响应 ios 后, 回调给 ios 的数据 111");
    });

    _twoChannel.setMethodCallHandler((call) {
      setState(() {
        if (call.method == 'two') {
          pageIndex = call.method;
          pageTwoArguments = call.arguments;
        }
      });
      return Future.value("two_page: flutter 响应 ios 后, 回调给 ios 的数据 222");
    });

    _messageChannel.setMessageHandler((message) {
      setState(() {
        nativeMessage = message;
      });
      return Future.value("_messageChannel: flutter 响应 ios 后, 回调给 ios 的数据 000");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter与原生通信',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: _rootPage(pageIndex),
    );
  }

  Widget _rootPage(String pageIndex) {
    switch (pageIndex) {
      case 'one':
        return Scaffold(
          appBar: AppBar(
            title: Text(pageIndex),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    var result = await _oneChannel
                        .invokeMethod("exit", {"key9": "参数1", "key10": "参数2"});
                    print("_oneChannel: $result");
                  },
                  child: Text("$pageIndex -- ${pageOneArguments.toString()}")),
              ElevatedButton(
                onPressed: () {
                  _messageChannel.send("我来自dart--BasicMessageChannel");
                },
                child: Text("发送BasicMessageChannel消息 $nativeMessage"),
              )
            ],
          ),
        );
      case 'two':
        return Scaffold(
            appBar: AppBar(
              title: Text(pageIndex),
            ),
            body: Center(
              child: ElevatedButton(
                  onPressed: () async {
                    var result = await _twoChannel.invokeMethod(
                        "exit", {"key99": "参数1222", "key100": "参数222"});
                    print("_oneChannel: $result");
                  },
                  child: Text("$pageIndex -- ${pageTwoArguments.toString()}")),
            ));
      default:
        return Scaffold(
          appBar: AppBar(
            title: Text(pageIndex),
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                const MethodChannel('default_page').invokeListMethod('exit');
              },
              child: Text(pageIndex),
            ),
          ),
        );
    }
  }
}
