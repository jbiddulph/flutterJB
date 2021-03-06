// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutterjb/api/api_service.dart';
// import 'package:flutterjb/pages/home.dart';
// import 'package:flutterjb/utils/user_secure_storage.dart';
// import '../../model/finds_model.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class AllfindsLocationdetail extends StatefulWidget {
//   final Finds finds;
//   static double lat = 0;
//   static double lon = 0;
//   AllfindsLocationdetail(
//       {@required this.finds, double longitude, double latitude});
//   @override
//   _AllfindsLocationdetailState createState() => _AllfindsLocationdetailState();
// }

// class _AllfindsLocationdetailState extends State<AllfindsLocationdetail> {
//   // double lat = latitude as double;
//   // double lon = longitude as double;

//   Completer<GoogleMapController> _controller = Completer();
//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.43296265331129, -122.08832357078792),
//     zoom: 14.4746,
//   );

//   // static final CameraPosition _kLake = CameraPosition(
//   //     bearing: 192.8334901395799,
//   //     target: LatLng(37.43296265331129, -122.08832357078792),
//   //     tilt: 59.440717697143555,
//   //     zoom: 19.151926040649414);
//   String profileId;

//   APIService httpService = new APIService();

//   static get latitude => null;
//   static get longitude => null;

//   static double get lat => null;
//   static double get lon => null;

//   Set<Marker> _markers = {};

//   @override
//   void initState() {
//     super.initState();
//     init();
//   }

//   Future init() async {
//     print(latitude);
//     final profileid = await UserSecureStorage.getProfileId() ?? '';
//     setState(() {
//       profileId = profileid;
//       double lat = latitude;
//       double lon = longitude;
//     });
//     print(profileId);
//     print('LAtitude: $latitude');
//     print('Longitude: $longitude');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Location", style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.redAccent,
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: Container(
//         height: 300,
//         width: double.infinity,
//         child: GoogleMap(
//           mapType: MapType.normal,
//           markers: _markers,
//           initialCameraPosition: _kGooglePlex,
//           onMapCreated: (GoogleMapController controller) {
//             _controller.complete(controller);
//             setState(() {
//               _markers.add(Marker(
//                 markerId: MarkerId('Marker 1'),
//                 position: LatLng(37.43296265331129, -122.08832357078792),
//               ));
//             });
//           },
//         ),
//       ),
//       // floatingActionButton: FloatingActionButton.extended(
//       //   onPressed: _goToTheLake,
//       //   label: Text('To the lake!'),
//       //   icon: Icon(Icons.directions_boat),
//       // ),
//     );
//   }

//   // Future<void> _goToTheLake() async {
//   //   final GoogleMapController controller = await _controller.future;
//   //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   // }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterjb/api/api_service.dart';
import 'package:flutterjb/pages/home.dart';
import 'package:flutterjb/utils/user_secure_storage.dart';
import '../../model/finds_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(AllfindsLocationdetail());

class AllfindsLocationdetail extends StatefulWidget {
  String id;
  final Finds finds;
  final double latitude;
  final double longitude;
  AllfindsLocationdetail({Key key, @required this.finds, this.latitude, this.longitude})
      : super(key: key);
  @override
  _AllfindsLocationdetailState createState() => _AllfindsLocationdetailState();
}

class _AllfindsLocationdetailState extends State<AllfindsLocationdetail> {
  
BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  @override
   void initState() {
      BitmapDescriptor.fromAssetImage(
         ImageConfiguration(devicePixelRatio: 2.5),
         'assets/marker.png').then((onValue) {
            pinLocationIcon = onValue;
         });
   }

  
  GoogleMapController mapController;
  
  // final LatLng _center = const LatLng(widget.latitude, widget.longitude);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    LatLng pinPosition = LatLng(widget.latitude, widget.longitude);
   
   // these are the minimum required values to set 
   // the camera position 
   CameraPosition initialLocation = CameraPosition(
      zoom: 16,
      // bearing: 30,
      target: pinPosition
   );
    // return MaterialApp(
    return Scaffold(
        appBar: AppBar(
          title: Text("Location", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: 
        GoogleMap(
          myLocationEnabled: true,
   markers: _markers,
   initialCameraPosition: initialLocation,
   onMapCreated: (GoogleMapController controller) {
      _controller.complete(controller);
      setState(() {
         _markers.add(
            Marker(
               markerId: MarkerId('<MARKER_ID>'),
               position: pinPosition,
               icon: pinLocationIcon
            )
         );
      });
   }),
      
        );
  }
}
