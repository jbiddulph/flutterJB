import 'package:flutter/material.dart';
import 'package:flutterjb/pages/allfinds/allfinds_grid.dart' as tabone;
import 'package:flutterjb/pages/allfinds/allfinds.dart' as tabtwo;

class Finds extends StatefulWidget {
  @override
  // final String pageText;
  // Finds(this.pageText);
  _FindState createState() => new _FindState();
}

class _FindState extends State<Finds> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('All Finds', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent,
          bottom: new TabBar(controller: controller, tabs: <Widget>[
            new Tab(
              icon: new Icon(Icons.grid_on),
            ),
            new Tab(
              icon: new Icon(Icons.list),
            ),
          ]),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: new TabBarView(
          controller: controller,
          children: <Widget>[
            new tabone.AllfindsGrid('All Finds'),
            new tabtwo.AllfindsPage('All Finds'),
          ],
        ));
  }
}
