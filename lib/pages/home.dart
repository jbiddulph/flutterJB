import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterjb/model/login_model.dart';
import 'package:flutterjb/utils/user_secure_storage.dart';
import '../progressHUD.dart';
import 'myfinds/myfinds.dart';
import 'myfinds/myfinds_new.dart';

final _storage = FlutterSecureStorage();

String newToken;

String profileCreatedAt;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String profileName;
  String profileEmail;
  String profileId;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  LoginRequestModel loginRequestModel;
  bool isApiCallProcess = false;
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel();
    init();
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
  }

  @override
  Widget build(BuildContext context) {
    return progressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    //     var circleAvatar = new CircleAvatar(
//             backgroundImage:
//             final Widget networkSvg = SvgPicture.network(
//   'http://tinygraphs.com/labs/isogrids/hexa/albert?theme=frogideas&numcolors=4&size=220&fmt=svg',
// ));
    return Scaffold(
      appBar: new AppBar(
        title: const Text('LookWhatFound.Me',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: new Drawer(
          child: new ListView(children: <Widget>[
        new UserAccountsDrawerHeader(
          // controller: accountName,
          accountName:
              new Text('$profileName', style: TextStyle(color: Colors.white)),
          accountEmail:
              new Text('$profileEmail', style: TextStyle(color: Colors.white)),
          currentAccountPicture: new GestureDetector(
              child: new CircleAvatar(
            backgroundImage: new NetworkImage(
                'https://avatars.githubusercontent.com/u/289873?s=400&u=3a21c717d2d2b5a5dbb7c5cf30c660840fee7043&v=4'),
          )),
          decoration: new BoxDecoration(
            image: new DecorationImage(
                fit: BoxFit.cover,
                image: new NetworkImage(
                    'https://images.unsplash.com/photo-1557682224-5b8590cd9ec5?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8N3x8fGVufDB8fHw%3D&w=1000&q=80')),
          ),
        ),
        new ListTile(
          title: new Text('My Finds',
              style: TextStyle(color: Colors.redAccent, fontSize: 18)),
          trailing: new Icon(Icons.arrow_upward),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new MyfindsPage('My Finds')));
          },
        ),
        new ListTile(
          title: new Text('Add New Find',
              style: TextStyle(color: Colors.redAccent, fontSize: 18)),
          trailing: new Icon(Icons.surround_sound),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new MyfindsNew()));
          },
        ),
        new ListTile(
          title: new Text('Page Three',
              style: TextStyle(color: Colors.redAccent, fontSize: 18)),
          trailing: new Icon(Icons.person_add),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new MyfindsPage('Third Page')));
          },
        ),
        new Divider(),
        new ListTile(
          title: new Text('Logout'),
          trailing: new Icon(Icons.logout),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new MyfindsPage('Third Page')));
          },
        ),
        new ListTile(
          title: new Text('Close'),
          trailing: new Icon(Icons.close),
          onTap: () => Navigator.of(context).pop(),
        ),
      ])),
      key: scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
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
                              'HomePage',
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            SizedBox(
                              height: 30,
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
