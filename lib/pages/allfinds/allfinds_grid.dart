import 'package:flutter/material.dart';
import 'package:flutterjb/model/finds_model.dart';
import 'package:flutterjb/api/api_service.dart';
import 'package:flutterjb/pages/allfinds/allfinds_detail.dart';

class AllfindsGrid extends StatefulWidget {
  final String pageText;
  AllfindsGrid(this.pageText);

  @override
  _AllfindsGridState createState() => _AllfindsGridState();
}

class _AllfindsGridState extends State<AllfindsGrid> {
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
            return GridView.count(
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              crossAxisCount: 3,
              children: finds
                  .map(
                    (Finds find) => Container(
                      child: Container(
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                              image: new NetworkImage("${find.primary_art}"),
                              fit: BoxFit.cover),
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

// leading: CircleAvatar(
//                           backgroundImage: NetworkImage("${find.primary_art}")),
//                       title: Text(find.title),
//                       subtitle: Text("${find.description}"),
//                       onTap: () => Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => AllfindsDetail(
//                             finds: find,
//                           ),
//                         ),
//                       ),
