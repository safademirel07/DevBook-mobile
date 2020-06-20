import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';
import 'package:devbook_new/models/get/profile.dart';
import 'package:devbook_new/models/get/user.dart';
import 'package:devbook_new/requests/profile_request.dart';
import 'package:devbook_new/requests/user_request.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  Profile profile;
  String errorMessage;
  bool loading = false;

  bool isChangedLoginStatus = false;

  bool logout = false;

  bool createProfile = false;

  Future<bool> loginRequest(String email, String password) async {
    setLoading(true);

    UserRequest().loginRequest(email, password).then((data) {
      if (data.statusCode == 200) {
        User user = User.fromJson(json.decode(data.body));
        SharedPreferenceHelper.setAuthToken(user.token);
        setChangedLoginStatus(true);
        setLoading(false);
        return true;
      } else {
        setMessage("Invalid email or password.");
        setLoading(false);
        return false;
      }
    });
  }

  Future<bool> logoutRequest() async {
    setLoading(true);

    UserRequest().logoutRequest().then((data) {
      if (data != null) {
        SharedPreferenceHelper.setAuthToken("");
        setLogout(true);
        setLoading(false);
      }
    });
  }

  bool getLogout() {
    return logout;
  }

  void setLogout(bool value) {
    logout = value;
    notifyListeners();
  }

  bool getChangedLoginStatus() {
    return isChangedLoginStatus;
  }

  void setChangedLoginStatus(bool value) {
    isChangedLoginStatus = value;
    notifyListeners();
  }

  void setCreateProfile(bool value) {
    createProfile = true;
    notifyListeners();
  }

  bool getCreateProfile() {
    return createProfile;
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  bool isLoading() {
    return loading;
  }

  void setProfile(value) {
    profile = value;
    notifyListeners();
  }

  Profile getProfile() {
    return profile;
  }

  void setMessage(value) {
    errorMessage = value;
    notifyListeners();
  }

  String getMessage() {
    return errorMessage;
  }

  bool isProfile() {
    return profile != null ? true : false;
  }
}
