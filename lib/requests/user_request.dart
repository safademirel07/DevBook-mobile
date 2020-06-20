import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';
import 'package:devbook_new/models/get/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserRequest {
  Future<http.Response> loginRequest(String email, String password) {
    return http.post(
      Constants.api_url + "/users/login",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{'email': email, 'password': password},
      ),
    );
  }

  Future<http.Response> registerRequest(
      String name, String email, String password, String password2) {
    return http.post(
      Constants.api_url + "/users/login",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'name': name,
          'email': email,
          'password': password,
          'password2': password2
        },
      ),
    );
  }

  Future<http.Response> logoutRequest() async {
    final token = await SharedPreferenceHelper.getAuthToken;

    if (token == null || token.toString().length == 0) {
      return null;
    }

    return http.post(
      Constants.api_url + "/users/logout",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
    );
  }
}
