import 'package:flutter/material.dart';
import 'package:flutterjb/api/api_service.dart';
import 'package:flutterjb/pages/home.dart';
import '../../model/myfinds_model.dart';

class MyfindsDetail extends StatelessWidget {
  APIService httpService = new APIService();
  final Myfinds myfinds;

  MyfindsDetail({@required this.myfinds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(myfinds.title, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent,
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showAlertDialog(context);
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                        title: Text("Title"),
                        subtitle: Text(myfinds.title),
                      ),
                      ListTile(
                        title: Text("ID"),
                        subtitle: Text("${myfinds.id}"),
                      ),
                      ListTile(
                        title: Text("Body"),
                        subtitle: Text(myfinds.description),
                      ),
                      ListTile(
                        title: Text("Created At"),
                        subtitle: Text("${myfinds.primary_art}"),
                      ),
                      ListTile(
                        title: Text("Height"),
                        subtitle: Text("${myfinds.height}"),
                      ),
                      ListTile(
                        title: Text("Width"),
                        subtitle: Text("${myfinds.width}"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () async {
        await httpService.deleteMyfinds(myfinds.id);
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete My Find"),
      content: Text("Are you sure you want to delete this item?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
