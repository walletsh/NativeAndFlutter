import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/basic_message_channel_page.dart';
import 'package:flutter_module/event_channel_page.dart';
import 'package:flutter_module/method_channel_page.dart';
import 'dart:ui';

import 'package:flutter_module/my_app.dart';

void main() {
  runApp(run(window.defaultRouteName));
}

Widget run(String name) {
  switch (name) {
    case "myApp":
      return const MyApp();
    case "basic":
      return MaterialApp(
        title: "BasicMessageChannelPage",
        theme: ThemeData(backgroundColor: Colors.orange),
        home: const BasicMessageChannelPage(),
      );
    case "event":
      return MaterialApp(
        title: "BasicMessageChannelPage",
        theme: ThemeData(backgroundColor: Colors.orange),
        home: const EventChannelPage(),
      );
    case "method":
      return MaterialApp(
        title: "BasicMessageChannelPage",
        theme: ThemeData(backgroundColor: Colors.orange),
        home: const MethodChannelPage(),
      );
    default:
      return MaterialApp(
        title: "BasicMessageChannelPage",
        theme: ThemeData(backgroundColor: Colors.orange),
        home: Center(child: Text('Unknown route: $name')),
      );
  }
}
