import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterjb/api/api_service.dart';
import 'package:flutterjb/model/artwork_model.dart';

import '../progressHUD.dart';
import 'home.dart';

class ArtworkNew extends StatefulWidget {
  @override
  _ArtworkNewState createState() => _ArtworkNewState();
}


class _ArtworkNewState extends State<ArtworkNew> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  ArtworkRequestModel artworkRequestModel;
  bool isApiCallProcess = false;
  final storage = new FlutterSecureStorage();

  @override 
  void initState() {
    super.initState();
    artworkRequestModel = new ArtworkRequestModel();
  }
  
  @override
  Widget build(BuildContext context) {
    return progressHUD(child: _uiSetup(context),
    inAsyncCall: isApiCallProcess,
    opacity: 0.3,
    );
  }
  
  @override
  Widget _uiSetup(BuildContext context) {
    return Scaffold( 
      appBar: new AppBar(
        title: new Text('Add new Artworx'), 
        backgroundColor: Colors.redAccent,),
      key: scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                margin: EdgeInsets.symmetric(vertical:85, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.2),
                    offset: Offset(0,10),
                    blurRadius: 20)
                  ]
                ),
                child: Form(
                  key: globalFormKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 25),
                      Text(
                        'Add new artwork', 
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      SizedBox(height: 20,),
                      new TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => artworkRequestModel.title = input,
                        validator: (input)=> input.isEmpty 
                        ? "Please enter a title " 
                        : null,
                        decoration: new InputDecoration(
                          hintText: 'Title your artwork',
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
                             prefixIcon: Icon(
                               Icons.email, 
                               color: Theme.of(context).accentColor)
                        )  
                      ,),
                      SizedBox(height:20,),
                      new TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => artworkRequestModel.description = input,
                        validator: (input)=> input.length < 10 
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
                             prefixIcon: Icon(
                               Icons.text_format, 
                               color: Theme.of(context).accentColor),
                        ),
                      ),
                      SizedBox(height:20,),
                      new TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => artworkRequestModel.status = input,
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
                             prefixIcon: Icon(
                               Icons.publish_rounded, 
                               color: Theme.of(context).accentColor),
                        ),
                      ),
                      SizedBox(height:20,),
                      new TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => artworkRequestModel.primary_art = input,
                        validator: (input)=> input.length < 10 
                        ? "Please add a bit more " 
                        : null,
                        decoration: new InputDecoration(
                          hintText: 'Artwork URL',
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
                             prefixIcon: Icon(
                               Icons.picture_in_picture,
                               color: Theme.of(context).accentColor),
                        ),
                      ),
                      SizedBox(height:20,),
                      new TextFormField(
                        keyboardType: TextInputType.number,
                        onSaved: (input) => artworkRequestModel.height = int.parse(input),
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
                             prefixIcon: Icon(
                               Icons.vertical_align_top,
                               color: Theme.of(context).accentColor),
                        ),
                      ),
                      SizedBox(height:20,),
                      new TextFormField(
                        keyboardType: TextInputType.number,
                        onSaved: (input) => artworkRequestModel.width = int.parse(input),
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
                             prefixIcon: Icon(
                               Icons.horizontal_rule, 
                               color: Theme.of(context).accentColor),
                        ),
                      ),
                      SizedBox(height:20,),
                      new TextFormField(
                        keyboardType: TextInputType.number,
                        onSaved: (input) => artworkRequestModel.cost = int.parse(input),
                        decoration: new InputDecoration(
                          hintText: 'Cost',
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
                             prefixIcon: Icon(
                               Icons.horizontal_rule, 
                               color: Theme.of(context).accentColor),
                        ),
                      ),
                      SizedBox(height:20,),
                      new TextFormField(
                        keyboardType: TextInputType.number,
                        onSaved: (input) => artworkRequestModel.live = int.parse(input),
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
                             prefixIcon: Icon(
                               Icons.live_help, 
                               color: Theme.of(context).accentColor),
                        ),
                      ),
                      SizedBox(height:20,),
                      new TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => artworkRequestModel.created_by =  int.parse(input),
                        decoration: new InputDecoration(
                          hintText: 'Created_By',
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
                             prefixIcon: Icon(
                               Icons.person_pin, 
                               color: Theme.of(context).accentColor),
                        ),
                      ),  
                      SizedBox(
                        height: 30,
                        ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(
                          vertical:12, horizontal:80,
                        ),
                      
                      onPressed: () {
                        if (validateAndSave()) {
                              print(artworkRequestModel.toJson());

                              setState(() {
                                isApiCallProcess = true;
                              });
                                  
                              APIService apiService = new APIService();
                              apiService.addNewArtwork(artworkRequestModel).then((value) async {
                                if (value != null) {
                                  setState(() {
                                    isApiCallProcess = false;
                                  });
                                  
                                  if (value != null) {
                                    final snackBar = SnackBar(
                                        content: Text('here'));
                                      scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => Home()),
                                        );
                                  } else {
                                    final snackBar =
                                        SnackBar(content: Text('There has been an error'));
                                    scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  }
                                }
                              });

                        }
                      },
                      child: Text("Add new Artwork", style: TextStyle(color: Colors.white),),
                      color: Theme.of(context).accentColor,
                      shape: StadiumBorder(),
                      ),
                    ],
                  )
                )
              )
            ],)
          ],
        ),
      ),
    );
  }
  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    } else {
      return false;
    }
  }
}