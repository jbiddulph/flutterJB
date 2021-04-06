import 'package:flutter/material.dart';
import 'package:flutterjb/api/api_service.dart';
import 'package:flutterjb/pages/home.dart';
import '../model/artwork_model.dart';

class ArtworkDetail extends StatelessWidget {
  APIService httpService = new APIService();
  final Artwork artwork;

  ArtworkDetail({@required this.artwork});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(artwork.title),
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
                        subtitle: Text(artwork.title),
                      ),
                      ListTile(
                        title: Text("ID"),
                        subtitle: Text("${artwork.id}"),
                      ),
                      ListTile(
                        title: Text("Body"),
                        subtitle: Text(artwork.description),
                      ),
                      ListTile(
                        title: Text("Created At"),
                        subtitle: Text("${artwork.primary_art}"),
                      ),
                      ListTile(
                        title: Text("Height"),
                        subtitle: Text("${artwork.height}"),
                      ),
                      ListTile(
                        title: Text("Width"),
                        subtitle: Text("${artwork.width}"),
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
        await httpService.deleteArtwork(artwork.id);
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Artwork"),
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
