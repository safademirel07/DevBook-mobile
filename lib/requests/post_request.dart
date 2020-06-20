import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';
import 'package:devbook_new/models/get/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PostRequest {
  Future<http.Response> fetchPost(String id) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http
        .get(Constants.api_url + "/post/${id}", headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${token.toString()}',
    });
  }

  Future<http.Response> likePost(String id) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.post(
      Constants.api_url + "/post/like/${id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
    );
  }

  Future<http.Response> dislikePost(String id) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.post(
      Constants.api_url + "/post/dislike/${id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
    );
  }

  Future<http.Response> removeComment(String id) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.delete(
      Constants.api_url + "/comment/" + id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
    );
  }

  Future<http.Response> addComment(String id, String message) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.post(
      Constants.api_url + "/comment/" + id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
      body: jsonEncode(<String, String>{
        'text': message,
      }),
    );
  }

  Future<http.Response> addPost(String post) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.post(
      Constants.api_url + "/post",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
      body: jsonEncode(<String, String>{
        'text': post,
      }),
    );
  }

  Future<http.Response> removePost(String id) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.delete(
      Constants.api_url + "/post/" + id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
    );
  }
}
