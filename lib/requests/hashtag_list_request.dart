import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';
import 'package:devbook_new/models/get/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HashtagListRequest {
  Future<http.Response> fetchHashtagAll(int page, String hashtag) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    if (hashtag.length == 0) {
      return http.get(Constants.api_url + "/hashtags?page=$page",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${token.toString()}',
          });
    } else {
      return http.get(Constants.api_url + "/hashtags/$hashtag?page=$page",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${token.toString()}',
          });
    }
  }
}
