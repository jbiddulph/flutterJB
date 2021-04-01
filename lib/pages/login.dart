import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterjb/api/api_service.dart';
import 'package:flutterjb/model/login_model.dart';
import 'package:flutterjb/pages/home.dart';
import 'package:flutterjb/pages/register.dart';
// import 'package:flutterjb/services/Storage.dart';

import '../progressHUD.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;
  LoginRequestModel loginRequestModel;
  bool isApiCallProcess = false;
  final storage = new FlutterSecureStorage();

  @override 
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel();
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
                        'Login', 
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      SizedBox(height: 20,),
                      new TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => loginRequestModel.email = input,
                        validator: (input)=> !input.contains("@") 
                        ? "Email id should be valid " 
                        : null,
                        decoration: new InputDecoration(
                          hintText: 'Email Address',
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
                        onSaved: (input) => loginRequestModel.password = input,
                        validator: (input)=> input.length < 3 
                        ? "Password should be more than 3 characters " 
                        : null,
                        obscureText: hidePassword,
                        decoration: new InputDecoration(
                          hintText: 'Password',
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
                               Icons.lock, 
                               color: Theme.of(context).accentColor),
                              suffixIcon: IconButton(
                                onPressed: (){
                                  setState((){
                                    hidePassword = !hidePassword;
                                  });
                                }, 
                                color: Theme.of(context).accentColor.withOpacity(0.4),
                                icon: Icon(
                                  hidePassword 
                                  ? Icons.visibility_off 
                                  : Icons.visibility,
                                ),
                              ),
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
                              print(loginRequestModel.toJson());

                              setState(() {
                                isApiCallProcess = true;
                              });
                                  
                              APIService apiService = new APIService();
                              apiService.login(loginRequestModel).then((value) async {
                                if (value != null) {
                                  setState(() {
                                    isApiCallProcess = false;
                                  });
                                  String newToken;
                                  if (value.token != null) {
                                    await storage.write(key: 'token', value: value.token); 
                                    String newToken = await storage.read(key: 'token');
                                    
                                    final snackBar = SnackBar(
                                        content: Text(newToken));
                                    scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => Home()),
                                        );
                                  } else {
                                    final snackBar =
                                        SnackBar(content: Text(value.error));
                                    scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  }
                                }
                              });

                        }
                      },
                      child: Text("Login", style: TextStyle(color: Colors.white),),
                      color: Theme.of(context).accentColor,
                      shape: StadiumBorder(),
                      ),
                      RaisedButton(
                        child: Text('Register'),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/register');
                        }
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