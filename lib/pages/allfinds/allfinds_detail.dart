import 'dart:async';
import 'dart:ffi';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutterjb/api/api_service.dart';
import 'package:flutterjb/pages/allfinds/allfinds_locationdetail.dart';
import 'package:flutterjb/pages/home.dart';
import 'package:flutterjb/utils/user_secure_storage.dart';
import '../../model/finds_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AllfindsDetail extends StatefulWidget {
  final Finds finds;
  // static Float lat;
  // static double long;

  AllfindsDetail({@required this.finds});

  @override
  _AllfindsDetailState createState() => _AllfindsDetailState();
}

class _AllfindsDetailState extends State<AllfindsDetail> {
  String profileId;
  static double latitude = 0;
  static double longitude = 0;
  APIService httpService = new APIService();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final profileid = await UserSecureStorage.getProfileId() ?? '';
    latitude = widget.finds.latitude as double;
    longitude = widget.finds.longitude as double;
    setState(() {
      profileId = profileid;
    });

    if (int.parse(profileId) == widget.finds.created_by) {
      print('Current users item');
    }
    print(profileId);
    print('LAtitude: $latitude');
    print('Longitude: $longitude');
  }

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 12.4746,
  );

  _getDelete() {
    if (int.parse(profileId) == widget.finds.created_by) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            showAlertDialog(context);
          },
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.finds.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        iconTheme: IconThemeData(color: Colors.white),
        actions: _getDelete(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllfindsLocationdetail(
                latitude: '${widget.finds.latitude}',
                longitude: '${widget.finds.longitude}'),
          ),
        ),
        label: Text('Location!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  // Future<void> _showLocation(lat, lon) async {
  //   print(lat);
  //   print(lon);
  // }

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
        await httpService.deleteMyfinds(widget.finds.id);
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
