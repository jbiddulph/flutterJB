import 'package:flutter/material.dart';
import 'package:flutterjb/model/artwork_model.dart';
import 'package:flutterjb/api/api_service.dart';
import 'package:flutterjb/pages/artwork_detail.dart';

class ArtworkPage extends StatefulWidget {
  // const ArtworkPage({Key key}) : super(key: key);
  final String pageText;
  ArtworkPage(this.pageText);

  @override
  _ArtworkPageState createState() => _ArtworkPageState();
}

class _ArtworkPageState extends State<ArtworkPage> {
  Future<Artwork> futureArtwork;
  

  APIService apiService = new APIService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder(
        future: apiService.fetchArtwork(),
        builder: (BuildContext context, AsyncSnapshot<List<Artwork>> snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            List<Artwork> artworks = snapshot.data;
            return ListView(
              children: artworks
                  .map(
                    (Artwork artwork) => ListTile(
                      title: Text(artwork.title),
                      subtitle: Text("${artwork.description}"),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ArtworkDetail(
                            artwork: artwork,
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