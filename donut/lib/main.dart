import 'dart:io';

import 'package:donut/screen/auth_screen.dart';
import 'package:donut/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences _preferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoContext.clientId = "cfc90a0a9f916d05a0a207404f0915df";

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthPage()
    );
  }
}