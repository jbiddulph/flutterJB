import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterjb/pages/login.dart';
import 'package:flutterjb/pages/register.dart';
import 'package:flutterjb/services/Storage.dart';

import 'pages/home.dart';

final storage = new FlutterSecureStorage();
String newToken;
void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  final SecureStorage secureStorage = SecureStorage();
  @override
  _MyAppState createState() => _MyAppState();
  initState() {
    secureStorage.readSecureData('key').then((value) => newToken = value);
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'LookWhatFound.ME',
        theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Colors.white,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          accentColor: Colors.redAccent,
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 22.0, color: Colors.redAccent),
            headline2: TextStyle(
              fontSize: 24.0,
              color: Colors.redAccent,
              fontWeight: FontWeight.w700,
            ),
            bodyText1: TextStyle(
              fontSize: 14.0,
              color: Colors.blueAccent,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        home: newToken == null ? LoginPage() : Home(),
        routes: {
          '/register': (_) => RegisterPage(),
          '/login': (_) => LoginPage(),
        });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
