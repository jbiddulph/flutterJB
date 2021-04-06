import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterjb/api/api_service.dart';
import 'package:flutterjb/model/login_model.dart';
import '../progressHUD.dart';
import 'artwork.dart';
import 'artwork_new.dart';

String newToken;


class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  LoginRequestModel loginRequestModel;
  bool isApiCallProcess = false;
  final storage = new FlutterSecureStorage();
  
  @override 
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel();
    print(newToken);
  }

  @override
  Widget build(BuildContext context) {
    return progressHUD(child: _uiSetup(context),
    inAsyncCall: isApiCallProcess,
    opacity: 0.3,
    );
  }
  
  
  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Artworx'), 
        backgroundColor: Colors.redAccent,),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text('John Biddulph'), 
              accountEmail: new Text('john.mbiddulph@gmail.com'),
              currentAccountPicture: new GestureDetector(
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage('https://avatars.githubusercontent.com/u/289873?s=400&u=3a21c717d2d2b5a5dbb7c5cf30c660840fee7043&v=4'),
                )
              ),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: new NetworkImage('https://images.unsplash.com/photo-1557682224-5b8590cd9ec5?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8N3x8fGVufDB8fHw%3D&w=1000&q=80')
                ),
              ),),
            new ListTile(
              title: new Text('Page One'),
              trailing: new Icon(Icons.arrow_upward),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ArtworkPage('Artwork')));
              },
            ),
            new ListTile(
              title: new Text('Add New Artwork'),
              trailing: new Icon(Icons.surround_sound),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ArtworkNew()));
              },
            ),
            new ListTile(
              title: new Text('Page Three'),
              trailing: new Icon(Icons.person_add),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ArtworkPage('Third Page')));
              },
            ),
            new Divider(),
            new ListTile(
              title: new Text('Close'),
              trailing: new Icon(Icons.close),
              onTap: () => Navigator.of(context).pop(),
            ),
          ]
        )
      ),
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
                        'HomePage', 
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      SizedBox(
                        height: 30,
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