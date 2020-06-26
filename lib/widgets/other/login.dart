import 'dart:convert';

import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';
import 'package:devbook_new/home.dart';
import 'package:devbook_new/models/get/firebase.dart';
import 'package:devbook_new/models/get/user.dart';
import 'package:devbook_new/providers/user_provider.dart';
import 'package:devbook_new/widgets/login/login_form.dart';
import 'package:devbook_new/widgets/other/logo.dart';
import 'package:devbook_new/widgets/other/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // final FirebaseAuth _firebaseAuth = FirebaseAuth();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //String apiUrl = "http://10.0.2.2:3000";

  Future<String> currentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future<User> login(String _email, String _password) async {
    final http.Response response = await http.post(
      Constants.api_url + "/users/login",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{
          'email': _email.trim(),
          'password': _password,
        },
      ),
    );

    if (response.statusCode == 200) {
      try {
        var firebase = Firebase();

        await SharedPreferenceHelper.setUser(_email.trim());
        await SharedPreferenceHelper.setPassword(_password);

        await FirebaseAuth.instance.signOut();

        AuthCredential credential = EmailAuthProvider.getCredential(
            email: _email.trim(), password: _password);

        FirebaseUser signIn =
            (await _auth.signInWithCredential(credential)).user;

        firebase.setUser(signIn);

        print("Login sucess. Email " + signIn.email);

        return User.fromJson(json.decode(response.body), signIn.uid);
      } catch (e) {
        throw Future.error("Failed to login");
      }
    } else {
      throw Future.error("Failed to login");
    }
  }

  bool _isCurrent = false;

  bool clickedLogin = false;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => SystemNavigator.pop(),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void submitForm() async {
    if (_fbKey.currentState.saveAndValidate()) {
      setState(() {
        clickedLogin = true;
      });
      login(_fbKey.currentState.value['email'],
              _fbKey.currentState.value['password'])
          .then(
        (user) {
          setState(() {
            clickedLogin = false;
            SharedPreferenceHelper.setAuthToken(user.token);
            SharedPreferenceHelper.setUID(user.uid);
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new Home(),
            ));
          });
        },
        onError: (error) {
          setState(() {
            clickedLogin = false;
          });
          _scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text("Failed to login")));
        },
      );

      //Navigator.pop(context);
    }
  }

  Future<void> errorHandler() {
    String providerMessage =
        Provider.of<UserProvider>(context, listen: false).getMessage();

    if (providerMessage != null && providerMessage.length != 0) {
      showInSnackBar(providerMessage);
      Provider.of<UserProvider>(context, listen: false).setMessage("");
    }
  }

  void showInSnackBar(String value) {
    if (_scaffoldKey != null)
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    var padding = MediaQuery.of(context).padding; //Safe Area
    double screenHeight = MediaQuery.of(context).size.height - padding.top;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blueGrey, Colors.grey],
              ),
            ),
            child: Center(
                child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Logo(MainAxisAlignment.center),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  FormBuilder(
                    key: _fbKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          margin: EdgeInsets.only(bottom: 5),
                          child: FormBuilderTextField(
                            attribute: "email",
                            initialValue: "",
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "Mail Address",
                              errorStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.grey),
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 10),
                              ),
                            ),
                            validators: [
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email(),
                              FormBuilderValidators.minLength(1),
                              FormBuilderValidators.maxLength(24),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          margin: EdgeInsets.only(bottom: 5),
                          child: FormBuilderTextField(
                            attribute: "password",
                            obscureText: true,
                            initialValue: "",
                            maxLines: 1,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "Password",
                              errorStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.grey),
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 10),
                              ),
                            ),
                            validators: [
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(1),
                              FormBuilderValidators.maxLength(24),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              height: 50,
                              child: RaisedButton(
                                elevation: 3,
                                color: Colors.blueGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                      color: Colors.grey[600], width: 1),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new Register(),
                                  ));
                                },
                                child: Text(
                                  "REGISTER",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              height: 50,
                              child: RaisedButton(
                                elevation: 3,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                      color: Colors.grey[600], width: 1),
                                ),
                                onPressed: () {
                                  if (Provider.of<UserProvider>(context,
                                              listen: false)
                                          .isLoading() ==
                                      false) submitForm();
                                },
                                child: clickedLogin
                                    ? CircularProgressIndicator()
                                    : Text(
                                        "LOGIN",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))),
      ),
    );
  }
}
