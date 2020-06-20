import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';

class User {
  String sId;
  String name;
  String email;
  String photoUrl;
  String token;

  User({this.sId, this.name, this.email, this.photoUrl, this.token});

  SharedPreferenceHelper sharedPreferenceHelper;

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    photoUrl = json['photoUrl'];
    token = json['token'];
    //sharedPreferenceHelper.saveAuthToken(token);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['photoUrl'] = this.photoUrl;
    data['token'] = this.token;
    return data;
  }
}
