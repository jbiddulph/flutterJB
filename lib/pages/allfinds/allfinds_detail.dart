import 'package:flutter/material.dart';
import 'package:flutterjb/api/api_service.dart';
import 'package:flutterjb/pages/home.dart';
import '../../model/finds_model.dart';

class AllfindsDetail extends StatelessWidget {
  APIService httpService = new APIService();
  final Finds finds;

  AllfindsDetail({@required this.finds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(finds.title, style: TextStyle(color: Colors.white)),
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
                        subtitle: Text(finds.title),
                      ),
                      ListTile(
                        title: Text("ID"),
                        subtitle: Text("${finds.id}"),
                      ),
                      ListTile(
                        title: Text("Body"),
                        subtitle: Text(finds.description),
                      ),
                      ListTile(
                        title: Text("Find"),
                        subtitle: Text("${finds.primary_art}"),
                      ),
                      ListTile(
                        title: Text("Height"),
                        subtitle: Text("${finds.height}"),
                      ),
                      ListTile(
                        title: Text("Width"),
                        subtitle: Text("${finds.width}"),
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
        await httpService.deleteMyfinds(finds.id);
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Find"),
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
