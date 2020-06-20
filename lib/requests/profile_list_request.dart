import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';
import 'package:devbook_new/models/get/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileListRequest {
  Future<http.Response> fetchProfileAll(int page, String search) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    if (search != null && search.length > 0) {
      return http.get(
          Constants.api_url + "/profile/all?search=$search&page=$page",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${token.toString()}',
          });
    } else {
      return http.get(Constants.api_url + "/profile/all?page=$page",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${token.toString()}',
          });
    }
  }
}
