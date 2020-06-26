import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';
import 'package:http/http.dart' as http;

class EventListRequest {
  Future<http.Response> fetchEventAll(int page, String search) async {
    dynamic token = await SharedPreferenceHelper.getAuthToken;

    if (search.length == 0) {
      return http.get(Constants.api_url + "/event/all?page=$page",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${token.toString()}',
          });
    } else {
      return http.get(Constants.api_url + "/event/all/$search?page=$page",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${token.toString()}',
          });
    }
  }
}
