import 'package:flutter/material.dart';
import 'package:flutterjb/model/myfinds_model.dart';
import 'package:flutterjb/api/api_service.dart';
import 'package:flutterjb/pages/myfinds/myfinds_detail.dart';

class MyfindsPage extends StatefulWidget {
  final String pageText;
  MyfindsPage(this.pageText);

  @override
  _MyfindsPageState createState() => _MyfindsPageState();
}

class _MyfindsPageState extends State<MyfindsPage> {
  Future<Myfinds> futureMyfinds;

  APIService apiService = new APIService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Finds', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: apiService.fetchMyfinds(),
        builder: (BuildContext context, AsyncSnapshot<List<Myfinds>> snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            List<Myfinds> myfinds = snapshot.data;
            return ListView(
              children: myfinds
                  .map(
                    (Myfinds myfind) => ListTile(
                      leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage("${myfind.primary_art}")),
                      title: Text(myfind.title),
                      subtitle: Text("${myfind.description}"),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MyfindsDetail(
                            myfinds: myfind,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
