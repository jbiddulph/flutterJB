import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  // const AboutPage({Key key}) : super(key: key);

  final String pageText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text(pageText)),
      body: new Center(
        child: new Text('this page'),
      )
    );
  }
}