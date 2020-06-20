import 'package:devbook_new/models/get/event.dart';
import 'package:devbook_new/models/get/post.dart';
import 'package:devbook_new/requests/event_request.dart';
import 'package:devbook_new/requests/post_request.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class EventProvider with ChangeNotifier {
  Event _event;
  String errorMessage;
  bool loading = true;
  bool adding = false;

  Future<void> fetchEvent(String id) async {
    setLoading(true);

    _event = null;

    EventRequest().fetchEvent(id).then((data) {
      if (data.statusCode == 200) {
        setEvent(Event.fromJson(json.decode(data.body)));
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setMessage("hata olustu");
      }
    });
    setLoading(false);
  }

  Future<bool> participationRequest(String id) async {
    setAdding(true);

    EventRequest().participationEvent(id).then((data) {
      if (data.statusCode == 200) {
        setAdding(false);
        Event returnData = Event.fromJson(json.decode(data.body));
        _event.participantCount = returnData.participantCount;
        _event.maybeCount = returnData.maybeCount;
        _event.isMaybe = returnData.isMaybe;
        _event.isParticipant = returnData.isParticipant;
        _event.participants = returnData.participants;
        _event.maybes = returnData.maybes;
        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  Future<bool> maybeRequest(String id) async {
    setAdding(true);

    EventRequest().maybeEvent(id).then((data) {
      if (data.statusCode == 200) {
        setAdding(false);
        Event returnData = Event.fromJson(json.decode(data.body));
        _event.participantCount = returnData.participantCount;
        _event.maybeCount = returnData.maybeCount;
        _event.isMaybe = returnData.isMaybe;
        _event.isParticipant = returnData.isParticipant;
        _event.participants = returnData.participants;
        _event.maybes = returnData.maybes;
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

  void setEvent(value) {
    _event = value;
    notifyListeners();
  }

  Event getEvent() {
    return _event;
  }

  void setMessage(value) {
    errorMessage = value;
    notifyListeners();
  }

  String getMessage() {
    return errorMessage;
  }

  bool isEvent() {
    return _event != null ? true : false;
  }

  int eventLength() {
    return _event != null ? 1 : 0;
  }
}
