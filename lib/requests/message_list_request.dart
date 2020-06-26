import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';
import 'package:devbook_new/models/get/message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MessageListRequest {
  Future<http.Response> fetchMessagesAll(int page) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.get(Constants.api_url + "/messaging/all?page=$page",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${token.toString()}',
        });
  }

  Future<http.Response> addMessage(Message message) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    return http.post(
      Constants.api_url + "/messaging",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${token.toString()}',
      },
      body: json.encode(message.toJson()),
    );
  }
}
