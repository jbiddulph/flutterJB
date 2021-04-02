import 'package:flutter/material.dart';
import '../model/artwork_model.dart';

class ArtworkDetail extends StatelessWidget {
  final Artwork artwork;

  ArtworkDetail({@required this.artwork});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artwork.title),
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
      )
    );
  }
}