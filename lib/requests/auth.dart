import 'dart:async';
import 'dart:math';

import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';

class AuthService {
  // Login
  Future<bool> login() async {
    await SharedPreferenceHelper.getAuthToken.then((value) {
      return Future.value(true);
    }, onError: (errorValue) {
      return Future.value(false);
    }).catchError((onError) {
      return Future.value(true);
    });
  }

  // Logout
  Future<void> logout() async {
    // Simulate a future for response after 1 second.
    return await new Future<void>.delayed(new Duration(seconds: 1));
  }
}
