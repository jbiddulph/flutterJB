import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterjb/pages/login.dart';
import 'package:flutterjb/api/api_service.dart';
import 'package:flutterjb/model/register_model.dart';

import '../progressHUD.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;
  RegisterRequestModel registerRequestModel;
  bool isApiCallProcess = false;

  @override 
  void initState() {
    super.initState();
    registerRequestModel = new RegisterRequestModel();
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
                        'Register for an account', 
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      SizedBox(height: 20,),
                      new TextFormField(
                        keyboardType: TextInputType.name,
                        onSaved: (input) => registerRequestModel.name = input,
                        decoration: new InputDecoration(
                          hintText: 'Username',
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
                               Icons.face, 
                               color: Theme.of(context).accentColor)
                        )  
                      ,),
                      SizedBox(height: 20,),
                      new TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => registerRequestModel.email = input,
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
                        onSaved: (input) => registerRequestModel.password = input,
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
                      SizedBox(height:20,),
                      new TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => registerRequestModel.password_confirmation = input,
                        validator: (input)=> input.length < 3 
                        ? "Password should be more than 3 characters " 
                        : null,
                        obscureText: hidePassword,
                        decoration: new InputDecoration(
                          hintText: 'Confirm Password',
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
                              print(registerRequestModel.toJson());

                              setState(() {
                                isApiCallProcess = true;
                              });

                              APIService apiService = new APIService();
                              apiService.register(registerRequestModel).then((value) {
                                if (value != null) {
                                  setState(() {
                                    isApiCallProcess = false;
                                  });

                                  if (value.token.isNotEmpty) {
                                    final snackBar = SnackBar(
                                        content: Text('User created'));
                                    scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => LoginPage()),
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
                      child: Text("Register", style: TextStyle(color: Colors.white),),
                      color: Theme.of(context).accentColor,
                      shape: StadiumBorder(),
                      ),
                      RaisedButton(
                        child: Text('Login'),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/login');
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