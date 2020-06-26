import 'package:devbook_new/models/get/hashtag.dart';
import 'package:devbook_new/models/get/message.dart';
import 'package:devbook_new/requests/hashtag_list_request.dart';
import 'package:devbook_new/requests/message_list_request.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class MessageListProvider with ChangeNotifier {
  List<Message> _message;

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

  Future<void> fetchMessageAll() async {
    setLoading(true);
    try {
      page = 1;
      MessageListRequest().fetchMessagesAll(page).then((data) {
        if (data.statusCode == 200) {
          List<Message> messages = (json.decode(data.body)["messages"] as List)
              .map((data) => Message.fromJson(data))
              .toList();
          setMessages(messages);
          setMessage("");
        } else {
          Map<String, dynamic> result = json.decode(data.body);
          setMessage(result["error"]);
        }
      });
    } catch (e) {}
  }

  Future<void> fetchMessageMore() async {
    setLoadingMore(true);

    try {
      MessageListRequest().fetchMessagesAll(page + 1).then((data) {
        if (data.statusCode == 200) {
          List<Message> messages = (json.decode(data.body)["messages"] as List)
              .map((data) => Message.fromJson(data))
              .toList();

          if (messages.length > 0) {
            ++page;
          }

          _message.addAll(messages);
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

  Future<bool> addMessage(Message message) async {
    setAdding(true);

    MessageListRequest().addMessage(message).then((data) {
      if (data.statusCode == 200) {
        setAdding(false);

        Message messageNew = Message.fromJson(json.decode(data.body));

        int messageIndex = getMessageIndex(messageNew.sId);

        if (messageIndex > -1) {
          _message[messageIndex] = messageNew;
        } else {
          _message.add(messageNew);
        }
        return true;
      } else {
        setAdding(false);
        return false;
      }
    });
  }

  int getMessageIndex(String id) {
    return _message.indexWhere((message) => message.sId == id);
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

  void setMessages(value) {
    _message = value;
    setLoading(false);
    notifyListeners();
  }

  List<Message> getMessages() {
    return _message;
  }

  void setMessage(value) {
    errorMessage = value;
    setLoading(false);
    notifyListeners();
  }

  String getMessage() {
    return errorMessage;
  }

  bool anyMessage() {
    return _message != null ? _message.length == 0 ? false : true : false;
  }

  int hashtagLength() {
    return _message != null ? _message.length : 0;
  }
}
