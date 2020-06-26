import 'package:devbook_new/models/get/post.dart';
import 'package:devbook_new/requests/post_list_request.dart';
import 'package:devbook_new/requests/post_request.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class PostListProvider with ChangeNotifier {
  List<Post> _posts;
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

  Future<void> fetchPostAll(String hashtag, int sort, String search) async {
    setLoading(true);
    try {
      page = 1;
      _posts = null;
      PostListRequest().fetchPostAll(page, hashtag, sort, search).then((data) {
        if (data.statusCode == 200) {
          List<Post> posts = (json.decode(data.body)['posts'] as List)
              .map((data) => Post.fromJson(data))
              .toList();
          setPosts(posts);
          setMessage("");
        } else {
          Map<String, dynamic> result = json.decode(data.body);
          setMessage(result["error"]);
        }
      });
    } catch (e) {}
  }

  Future<void> fetchPostMore(String hashtag, int sort, String search) async {
    setLoadingMore(true);

    try {
      PostListRequest()
          .fetchPostAll(page + 1, hashtag, sort, search)
          .then((data) {
        if (data.statusCode == 200) {
          List<Post> posts = (json.decode(data.body)['posts'] as List)
              .map((data) => Post.fromJson(data))
              .toList();

          if (posts.length > 0) ++page;

          _posts.addAll(posts);
          //setPosts(posts);
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

  Future<bool> addPost(
      String message, String hashtag, int sort, String search) async {
    setAdding(true);

    PostRequest().addPost(message).then((data) {
      if (data.statusCode == 201) {
        setAdding(false);
        _posts.add(Post.fromJson(json.decode(data.body)));
        fetchPostAll(hashtag, sort, search);
        return true;
      } else {
        setAdding(false);
        return false;
      }
    });
  }

  Future<bool> removePost(String id) async {
    setAdding(true);

    PostRequest().removePost(id).then((data) {
      if (data.statusCode == 200) {
        setAdding(false);
        _posts.removeAt(getPostIndex(id));
        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  void changePost(int index, Post newPost) {
    Post post = _posts[index];

    if (post != null) {
      post.readers = newPost.readers;
      post.like = newPost.like;
      post.isLiked = newPost.isLiked;
      post.isDisliked = newPost.isDisliked;
      _posts[index] = post;
      notifyListeners();
    }
  }

  int getPostIndex(String id) {
    return _posts.indexWhere((post) => post.sId == id);
  }

  Future<bool> likeRequest(String id) async {
    setAdding(true);

    PostRequest().likePost(id).then((data) {
      if (data.statusCode == 200) {
        setAdding(false);
        int postIndex = getPostIndex(id);

        Post returnData = Post.fromJson(json.decode(data.body));
        _posts[postIndex].like = returnData.like;
        _posts[postIndex].isLiked = returnData.isLiked;
        _posts[postIndex].isDisliked = returnData.isDisliked;

        return true;
      } else {
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  Future<bool> dislikeRequest(String id) async {
    setAdding(true);

    PostRequest().dislikePost(id).then((data) {
      if (data.statusCode == 200) {
        setAdding(false);
        int postIndex = getPostIndex(id);
        Post returnData = Post.fromJson(json.decode(data.body));
        _posts[postIndex].like = returnData.like;
        _posts[postIndex].isLiked = returnData.isLiked;
        _posts[postIndex].isDisliked = returnData.isDisliked;
        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
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

  void setPosts(value) {
    _posts = value;
    setLoading(false);
    notifyListeners();
  }

  List<Post> getPosts() {
    return _posts;
  }

  void setMessage(value) {
    errorMessage = value;
    setLoading(false);
    notifyListeners();
  }

  String getMessage() {
    return errorMessage;
  }

  bool anyPost() {
    return _posts != null ? _posts.length == 0 ? false : true : false;
  }

  int postLength() {
    return _posts != null ? _posts.length : 0;
  }
}
