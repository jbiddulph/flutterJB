import 'package:flutter/material.dart';
import 'package:flutterjb/model/finds_model.dart';
import 'package:flutterjb/api/api_service.dart';
import 'package:flutterjb/pages/allfinds/allfinds_detail.dart';

class AllfindsPage extends StatefulWidget {
  final String pageText;
  AllfindsPage(this.pageText);

  @override
  _AllfindsPageState createState() => _AllfindsPageState();
}

class _AllfindsPageState extends State<AllfindsPage> {
  Future<Finds> futureFinds;

  APIService apiService = new APIService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: apiService.fetchAllfinds(),
        builder: (BuildContext context, AsyncSnapshot<List<Finds>> snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            List<Finds> finds = snapshot.data;
            return ListView(
              children: finds
                  .map(
                    (Finds find) => ListTile(
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage("${find.primary_art}")),
                      title: Text(find.title),
                      subtitle: Text("${find.description}"),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AllfindsDetail(
                            finds: find,
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
