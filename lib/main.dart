import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';
import 'package:devbook_new/home.dart';
import 'package:devbook_new/providers/event_list_provider.dart';
import 'package:devbook_new/providers/event_provider.dart';
import 'package:devbook_new/providers/hashtag_list_provider.dart';
import 'package:devbook_new/providers/post_list_provider.dart';
import 'package:devbook_new/providers/post_provider.dart';
import 'package:devbook_new/providers/profile_list_provider.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:devbook_new/providers/user_provider.dart';
import 'package:devbook_new/requests/auth.dart';
import 'package:devbook_new/widgets/other/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'data/constants.dart';

AuthService appAuth = new AuthService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set default home.
  Widget _defaultHome = new Login();

  // Get result of the login function.
  //await SharedPreferenceHelper.setAuthToken("1111");

  await SharedPreferenceHelper.getAuthToken.then((value) async {
    final http.Response response = await http.post(
      Constants.api_url + "/users/auth",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $value',
      },
    );

    if (response.statusCode == 200) {
      _defaultHome = Home();
    } else {
      await SharedPreferenceHelper.setAuthToken("");
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
