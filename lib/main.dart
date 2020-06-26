import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';
import 'package:devbook_new/home.dart';
import 'package:devbook_new/models/get/firebase.dart';
import 'package:devbook_new/providers/event_list_provider.dart';
import 'package:devbook_new/providers/event_provider.dart';
import 'package:devbook_new/providers/hashtag_list_provider.dart';
import 'package:devbook_new/providers/message_list_provider.dart';
import 'package:devbook_new/providers/post_list_provider.dart';
import 'package:devbook_new/providers/post_provider.dart';
import 'package:devbook_new/providers/profile_list_provider.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:devbook_new/providers/user_provider.dart';
import 'package:devbook_new/requests/auth.dart';
import 'package:devbook_new/widgets/other/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'data/constants.dart';

AuthService appAuth = new AuthService();

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set default home.
  Widget _defaultHome = new Login();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  await SharedPreferenceHelper.getAuthToken.then((value) async {
    final http.Response response = await http.post(
      Constants.api_url + "/users/auth",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $value',
      },
    );

    if (response.statusCode == 200) {
      String uid = "";

      await Future.wait([
        SharedPreferenceHelper.getUser,
        SharedPreferenceHelper.getPassword
      ]).then((value) async {
        var firebase = Firebase();

        AuthCredential credential = EmailAuthProvider.getCredential(
            email: value[0].trim(), password: value[1]);

        FirebaseUser firebaseUser =
            (await _auth.signInWithCredential(credential)).user;

        if (firebaseUser.uid == null || firebaseUser.uid.length <= 0) {
          await SharedPreferenceHelper.setAuthToken("");
          await SharedPreferenceHelper.setUID("");
          await SharedPreferenceHelper.setPassword("");
          await SharedPreferenceHelper.setUser("");
          _defaultHome = Login();
        } else {
          print("Auth success. Email: " + firebaseUser.email);

          firebase.setUser(firebaseUser);

          uid = firebaseUser.uid;
        }
      });
      if (uid.length > 0) {
        _defaultHome = Home();
      }
    } else {
      await SharedPreferenceHelper.setAuthToken("");
      await SharedPreferenceHelper.setUID("");
      await SharedPreferenceHelper.setPassword("");
      await SharedPreferenceHelper.setUser("");
      _defaultHome = Login();
    }
  });
  //test
  // Run app!
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileListProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostListProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HashtagListProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => EventListProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => EventProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MessageListProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'DevBook',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.grey,
          fontFamily: "OpenSans",
        ),
        home: _defaultHome,
        routes: <String, WidgetBuilder>{
          // Set routes for using the Navigator.
          '/home': (BuildContext context) => new Home(),
          '/login': (BuildContext context) => new Login()
        },
        //loggedIn == true ? Home() : Login(),
      ),
    ),
  );
}
