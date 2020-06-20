import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';
import 'package:devbook_new/models/get/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventRequest {
  Future<http.Response> fetchEvent(String id) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http
        .get(Constants.api_url + "/event/${id}", headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${token.toString()}',
    });
  }

  Future<http.Response> participationEvent(String id) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.post(
      Constants.api_url + "/event/participation/${id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
    );
  }

  Future<http.Response> maybeEvent(String id) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.post(
      Constants.api_url + "/event/maybe/${id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
    );
  }

  Future<http.Response> addEvent(Event event) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.post(
      Constants.api_url + "/event",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
      body: json.encode(event.toJson()),
    );
  }

  Future<http.Response> removeEvent(String id) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.delete(
      Constants.api_url + "/event/" + id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
    );
  }
}
