import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';
import 'package:devbook_new/models/get/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PostListRequest {
  Future<http.Response> fetchPostAll(
      int page, String hashtag, int sort, String search) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    if (hashtag.length == 0) {
      return http.get(
          Constants.api_url + "/post/all?page=$page&sort=$sort&search=$search",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${token.toString()}',
          });
    } else {
      hashtag = hashtag.substring(1);
      return http.get(
          Constants.api_url +
              "/post/all/$hashtag?page=$page&sort=$sort&search=$search",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${token.toString()}',
          });
    }
  }
}
