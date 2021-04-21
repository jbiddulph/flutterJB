import 'dart:ffi';

import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterjb/api/api_service.dart';
import 'package:flutterjb/model/finds_model.dart';
import 'package:flutterjb/utils/user_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

import '../../progressHUD.dart';
import '../home.dart';

class MyfindsNew extends StatefulWidget {
  @override
  _MyfindsNewState createState() => _MyfindsNewState();
}

String profileName;
String profileEmail;
String profileId;
double latitudeData;
double longitudeData;

class _MyfindsNewState extends State<MyfindsNew> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  FindsRequestModel findsRequestModel;
  bool isApiCallProcess = false;

  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    init();
    getCurrentLocation();
    findsRequestModel = new FindsRequestModel();
  }

  Future init() async {
    final profilename = await UserSecureStorage.getProfileName() ?? '';
    final profileemail = await UserSecureStorage.getProfileEmail() ?? '';
    final profileid = await UserSecureStorage.getProfileId() ?? '';
    setState(() {
      profileName = profilename;
      profileEmail = profileemail;
      profileId = profileid;
    });
    print(profileName);
    print(profileEmail);
    print(profileId);
  }

  getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitudeData = geoposition.latitude;
      longitudeData = geoposition.longitude;
    });
    print(latitudeData);
    print(longitudeData);
  }

  @override
  Widget build(BuildContext context) {
    return progressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  @override
  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Add New Find', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      key: scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () => uploadImage(),
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white,
                backgroundImage:
                    imageUrl != null ? NetworkImage(imageUrl) : null,
                child: imageUrl == null
                    ? !isloading
                        ? Icon(
                            Icons.add_a_photo,
                            size: 100,
                            color: Colors.redAccent,
                          )
                        : Loading(
                            indicator: BallPulseIndicator(),
                            size: 100.0,
                            color: Colors.red,
                          )
                    : Container(),
              ),
            ),
            Column(
              children: [],
            ),
            Stack(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.2),
                              offset: Offset(0, 10),
                              blurRadius: 20)
                        ]),
                    child: Form(
                        key: globalFormKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 25),
                            Text(
                              'Add new find',
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            new TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (input) =>
                                  findsRequestModel.title = input,
                              validator: (input) => input.isEmpty
                                  ? "Please enter a title "
                                  : null,
                              decoration: new InputDecoration(
                                  hintText: 'Title your find',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  prefixIcon: Icon(Icons.email,
                                      color: Theme.of(context).accentColor)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            new TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (imageUrl) =>
                                  findsRequestModel.description = imageUrl,
                              validator: (input) => input.length < 10
                                  ? "Please add a bit more "
                                  : null,
                              decoration: new InputDecoration(
                                hintText: 'A good description here',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                prefixIcon: Icon(Icons.text_format,
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            new TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (input) =>
                                  findsRequestModel.status = input,
                              decoration: new InputDecoration(
                                hintText: 'Status 1/0',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                prefixIcon: Icon(Icons.publish_rounded,
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            new TextFormField(
                              initialValue: "${latitudeData}",
                              keyboardType: TextInputType.text,
                              onSaved: (input) =>
                                  findsRequestModel.latitude = latitudeData,
                              decoration: new InputDecoration(
                                hintText: "${latitudeData}",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                prefixIcon: Icon(Icons.location_on,
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            new TextFormField(
                              initialValue: "${longitudeData}",
                              keyboardType: TextInputType.text,
                              onSaved: (input) =>
                                  findsRequestModel.longitude = longitudeData,
                              decoration: new InputDecoration(
                                hintText: "$longitudeData",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                prefixIcon: Icon(Icons.location_on,
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            new TextFormField(
                              initialValue: imageUrl,
                              keyboardType: TextInputType.text,
                              onSaved: (input) =>
                                  findsRequestModel.primary_art = imageUrl,
                              // validator: (input) => input.length < 10
                              //     ? "Please add a bit more "
                              //     : null,
                              decoration: new InputDecoration(
                                hintText: imageUrl,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                prefixIcon: Icon(Icons.picture_in_picture,
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            new TextFormField(
                              keyboardType: TextInputType.number,
                              onSaved: (input) =>
                                  findsRequestModel.height = int.parse(input),
                              decoration: new InputDecoration(
                                hintText: 'Height',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                prefixIcon: Icon(Icons.vertical_align_top,
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            new TextFormField(
                              keyboardType: TextInputType.number,
                              onSaved: (input) =>
                                  findsRequestModel.width = int.parse(input),
                              decoration: new InputDecoration(
                                hintText: 'Width',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                prefixIcon: Icon(Icons.horizontal_rule,
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            new TextFormField(
                              keyboardType: TextInputType.number,
                              onSaved: (input) =>
                                  findsRequestModel.live = int.parse(input),
                              decoration: new InputDecoration(
                                hintText: 'Live 1/0',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                prefixIcon: Icon(Icons.live_help,
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            new TextFormField(
                              keyboardType: TextInputType.text,
                              onSaved: (input) => findsRequestModel.created_by =
                                  int.parse(profileId),
                              decoration: new InputDecoration(
                                hintText: '$profileId',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                prefixIcon: Icon(Icons.person_pin,
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            FlatButton(
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 80,
                              ),
                              onPressed: () {
                                if (validateAndSave()) {
                                  print(findsRequestModel.toJson());

                                  setState(() {
                                    isApiCallProcess = true;
                                  });

                                  APIService apiService = new APIService();
                                  apiService
                                      .addNewMyfinds(findsRequestModel)
                                      .then((value) async {
                                    setState(() {
                                      isApiCallProcess = false;
                                    });

                                    final snackBar =
                                        SnackBar(content: Text('here'));
                                    scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()),
                                    );
                                  });
                                }
                              },
                              child: Text(
                                "Add new Find",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Theme.of(context).accentColor,
                              shape: StadiumBorder(),
                            ),
                          ],
                        )))
              ],
            )
          ],
        ),
      ),
    );
  }

  var imageUrl;
  bool isloading = false;

  Future uploadImage() async {
    const url = "https://api.cloudinary.com/v1_1/defb2mzmx/upload";
    // var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      isloading = true;
    });

    Dio dio = Dio();
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(
        image.path,
      ),
      "upload_preset": "choosday",
      "cloud_name": "defb2mzmx",
    });
    try {
      Response response = await dio.post(url, data: formData);

      final imageData = jsonDecode(response.toString());
      print(imageData['secure_url']);

      setState(() {
        isloading = false;
        imageUrl = imageData['secure_url'];
      });
    } catch (e) {
      print(e);
    }
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
