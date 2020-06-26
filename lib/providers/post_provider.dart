import 'package:devbook_new/models/get/post.dart';
import 'package:devbook_new/providers/post_list_provider.dart';
import 'package:devbook_new/requests/post_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class PostProvider with ChangeNotifier {
  Post _post;
  String errorMessage;
  bool loading = true;
  bool adding = false;

  Future<void> fetchPost(String id, BuildContext context, int listIndex) async {
    setLoading(true);

    _post = null;

    PostRequest().fetchPost(id).then((data) {
      if (data.statusCode == 200) {
        setPost(Post.fromJson(json.decode(data.body)));
        Provider.of<PostListProvider>(context, listen: false)
            .changePost(listIndex, Post.fromJson(json.decode(data.body)));
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setMessage("hata olustu");
      }
    });
    setLoading(false);
  }

  Future<bool> likeRequest(
      String id, BuildContext context, int listIndex) async {
    setAdding(true);

    PostRequest().likePost(id).then((data) {
      if (data.statusCode == 200) {
        setAdding(false);
        Post returnData = Post.fromJson(json.decode(data.body));
        _post.like = returnData.like;
        _post.isLiked = returnData.isLiked;
        _post.isDisliked = returnData.isDisliked;
        Provider.of<PostListProvider>(context, listen: false)
            .changePost(listIndex, returnData);

        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  Future<bool> dislikeRequest(
      String id, BuildContext context, int listIndex) async {
    setAdding(true);

    PostRequest().dislikePost(id).then((data) {
      if (data.statusCode == 200) {
        setAdding(false);
        Post returnData = Post.fromJson(json.decode(data.body));
        _post.like = returnData.like;
        _post.isLiked = returnData.isLiked;
        _post.isDisliked = returnData.isDisliked;
        Provider.of<PostListProvider>(context, listen: false)
            .changePost(listIndex, returnData);

        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  int getCommentIndex(String id) {
    return _post.comments.indexWhere((post) => post.sId == id);
  }

  Future<bool> removeComment(String id) async {
    setAdding(true);

    PostRequest().removeComment(id).then((data) {
      if (data.statusCode == 200) {
        setAdding(false);
        _post.comments.removeAt(getCommentIndex(id));
        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  Future<bool> addComment(String id, String message) async {
    setAdding(true);

    PostRequest().addComment(id, message).then((data) {
      if (data.statusCode == 201) {
        setAdding(false);
        _post.comments.add(Comment.fromJson(json.decode(data.body)));
        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
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

  void setPost(value) {
    _post = value;
    notifyListeners();
  }

  Post getPost() {
    return _post;
  }

  void setMessage(value) {
    errorMessage = value;
    notifyListeners();
  }

  String getMessage() {
    return errorMessage;
  }

  bool isPost() {
    return _post != null ? true : false;
  }

  int postLength() {
    return _post != null ? 1 : 0;
  }
}
