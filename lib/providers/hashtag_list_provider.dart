import 'package:devbook_new/models/get/hashtag.dart';
import 'package:devbook_new/requests/hashtag_list_request.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class HashtagListProvider with ChangeNotifier {
  List<Hashtag> _hashtag;

  String errorMessage;
  bool loading = true;
  bool adding = false;

  bool loadingMore = false;

  bool fetchAgain = false;

  int page = 1;

  void setFetchAgain(bool value) {
    fetchAgain = value;
  }

  bool getFetchAgain() {
    return fetchAgain;
  }

  Future<void> fetchHashtagAll(String hashtag) async {
    setLoading(true);
    try {
      page = 1;
      HashtagListRequest().fetchHashtagAll(page, hashtag).then((data) {
        if (data.statusCode == 200) {
          List<Hashtag> hashtags = (json.decode(data.body) as List)
              .map((data) => Hashtag.fromJson(data))
              .toList();
          setHashtags(hashtags);
          setMessage("");
        } else {
          Map<String, dynamic> result = json.decode(data.body);
          setMessage(result["error"]);
        }
      });
    } catch (e) {}
  }

  Future<void> fetchHashtagMore(String hashtag) async {
    setLoadingMore(true);

    try {
      HashtagListRequest().fetchHashtagAll(page + 1, hashtag).then((data) {
        if (data.statusCode == 200) {
          List<Hashtag> hashtags = (json.decode(data.body) as List)
              .map((data) => Hashtag.fromJson(data))
              .toList();

          if (hashtags.length > 0) {
            ++page;
          }

          _hashtag.addAll(hashtags);
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

  int getHashtagIndex(String id) {
    return _hashtag.indexWhere((hashtag) => hashtag.sId == id);
  }

  void setLoadingMore(value) {
    loadingMore = value;
    notifyListeners();
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  void setAdding(value) {
    adding = value;
    notifyListeners();
  }

  bool isLoading() {
    return loading;
  }

  bool isLoadingMore() {
    return loadingMore;
  }

  void setHashtags(value) {
    _hashtag = value;
    setLoading(false);
    notifyListeners();
  }

  List<Hashtag> getHashtags() {
    return _hashtag;
  }

  void setMessage(value) {
    errorMessage = value;
    setLoading(false);
    notifyListeners();
  }

  String getMessage() {
    return errorMessage;
  }

  bool anyHashtag() {
    return _hashtag != null ? _hashtag.length == 0 ? false : true : false;
  }

  int hashtagLength() {
    return _hashtag != null ? _hashtag.length : 0;
  }
}
