import 'package:devbook_new/models/get/profile.dart';
import 'package:devbook_new/models/get/user.dart';
import 'package:devbook_new/requests/profile_list_request.dart';
import 'package:devbook_new/requests/profile_request.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class ProfileListProvider with ChangeNotifier {
  List<Profile> _profiles = [];
  String errorMessage;
  bool loading = true;
  bool adding = false;

  bool loadingMore = false;

  int page = 1;

  Future<void> fetchProfileAll(String search) async {
    setLoading(true);
    page = 1;
    ProfileListRequest().fetchProfileAll(page, search).then((data) {
      if (data.statusCode == 200) {
        List<Profile> profiles = (json.decode(data.body)['profiles'] as List)
            .map((data) => Profile.fromJson(data))
            .toList();
        setProfiles(profiles);
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setMessage("hata olustu");
      }
    });
    setLoading(false);
    //return isProfile();
  }

  Future<void> fetchProfileMore(String search) async {
    setLoadingMore(true);

    try {
      ProfileListRequest().fetchProfileAll(page + 1, search).then((data) {
        if (data.statusCode == 200) {
          ++page;
          List<Profile> profiles = (json.decode(data.body)['profiles'] as List)
              .map((data) => Profile.fromJson(data))
              .toList();

          _profiles.addAll(profiles);
          setMessage("");
          setLoadingMore(false);

          notifyListeners();
        } else {
          Map<String, dynamic> result = json.decode(data.body);
          setLoadingMore(false);

          setMessage(result["error"]);
        }
      });
    } catch (e) {}
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  bool isLoadingMore() {
    return loadingMore;
  }

  void setLoadingMore(value) {
    loadingMore = value;
    notifyListeners();
  }

  void setAdding(value) {
    adding = value;
    notifyListeners();
  }

  bool isLoading() {
    return loading;
  }

  void setProfiles(value) {
    _profiles = value;
    notifyListeners();
  }

  List<Profile> getProfiles() {
    return _profiles;
  }

  void setMessage(value) {
    errorMessage = value;
    notifyListeners();
  }

  String getMessage() {
    return errorMessage;
  }

  bool anyProfile() {
    return _profiles != null ? _profiles.length == 0 ? false : true : false;
  }

  int profileLength() {
    return _profiles != null ? _profiles.length : 0;
  }
}
