import 'package:devbook_new/models/get/event.dart';
import 'package:devbook_new/requests/event_list_request.dart';
import 'package:devbook_new/requests/event_request.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class EventListProvider with ChangeNotifier {
  List<Event> _events;
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

  Future<void> fetchEventAll(String search) async {
    setLoading(true);
    try {
      page = 1;
      EventListRequest().fetchEventAll(page, search).then((data) {
        if (data.statusCode == 200) {
          List<Event> events = (json.decode(data.body)['events'] as List)
              .map((data) => Event.fromJson(data))
              .toList();
          setEvents(events);
          setMessage("");
        } else {
          Map<String, dynamic> result = json.decode(data.body);
          setMessage(result["error"]);
        }
      });
    } catch (e) {}
  }

  Future<void> fetchEventMore(String search) async {
    setLoadingMore(true);

    try {
      EventListRequest().fetchEventAll(page + 1, search).then((data) {
        if (data.statusCode == 200) {
          List<Event> events = (json.decode(data.body)['events'] as List)
              .map((data) => Event.fromJson(data))
              .toList();

          if (events.length > 0) ++page;

          _events.addAll(events);
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

  Future<bool> addEvent(Event event) async {
    setAdding(true);

    EventRequest().addEvent(event).then((data) {
      if (data.statusCode == 201) {
        setAdding(false);
        _events.add(Event.fromJson(json.decode(data.body)));
        fetchEventAll("");
        return true;
      } else {
        setAdding(false);
        return false;
      }
    });
  }

  Future<bool> removeEvent(String id) async {
    setAdding(true);

    EventRequest().removeEvent(id).then((data) {
      if (data.statusCode == 200) {
        setAdding(false);
        _events.removeAt(getEventIndex(id));
        return true;
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setAdding(false);
        return false;
      }
    });
    return false;
  }

  int getEventIndex(String id) {
    return _events.indexWhere((post) => post.sId == id);
  }

  Future<bool> participationRequest(String id) async {
    setAdding(true);

    EventRequest().participationEvent(id).then((data) {
      if (data.statusCode == 200) {
        setAdding(false);
        int eventIndex = getEventIndex(id);

        Event returnData = Event.fromJson(json.decode(data.body));
        _events[eventIndex].participantCount = returnData.participantCount;
        _events[eventIndex].maybeCount = returnData.maybeCount;
        _events[eventIndex].isMaybe = returnData.isMaybe;
        _events[eventIndex].isParticipant = returnData.isParticipant;

        return true;
      } else {
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
        int eventIndex = getEventIndex(id);

        Event returnData = Event.fromJson(json.decode(data.body));
        _events[eventIndex].participantCount = returnData.participantCount;
        _events[eventIndex].maybeCount = returnData.maybeCount;
        _events[eventIndex].isMaybe = returnData.isMaybe;
        _events[eventIndex].isParticipant = returnData.isParticipant;
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

  void setEvents(value) {
    _events = value;
    setLoading(false);
    notifyListeners();
  }

  List<Event> getEvents() {
    return _events;
  }

  void setMessage(value) {
    errorMessage = value;
    setLoading(false);
    notifyListeners();
  }

  String getMessage() {
    return errorMessage;
  }

  bool anyEvent() {
    return _events != null ? _events.length == 0 ? false : true : false;
  }

  int eventLength() {
    return _events != null ? _events.length : 0;
  }
}
