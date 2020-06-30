import 'package:devbook_new/models/get/event.dart';
import 'package:devbook_new/providers/event_list_provider.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:devbook_new/widgets/event/add_event.dart';
import 'package:devbook_new/widgets/event/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EventList extends StatefulWidget {
  String search;

  EventList(this.search);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  initState() {
    super.initState();
    Future.microtask(() => {
          Provider.of<EventListProvider>(context, listen: false)
              .setFetchAgain(false),
          Provider.of<EventListProvider>(context, listen: false)
              .fetchEventAll(widget.search)
        });
  }

  @override
  void didChangeDependencies() {
    if (Provider.of<EventListProvider>(context, listen: false)
        .getFetchAgain()) {
      Future.microtask(() => {
            Provider.of<EventListProvider>(context, listen: false)
                .setFetchAgain(false),
            Provider.of<EventListProvider>(context, listen: false)
                .fetchEventAll(widget.search)
          });
    }

    Future.microtask(() => {errorHandler()});

    super.didChangeDependencies();
  }

  Future<void> errorHandler() {
    String providerMessage =
        Provider.of<EventListProvider>(context, listen: false).getMessage();

    if (providerMessage != null && providerMessage.length != 0) {
      showInSnackBar(providerMessage);
      Provider.of<EventListProvider>(context, listen: false).setMessage("");
    }
  }

  Future<void> refreshEvents() {
    return Provider.of<EventListProvider>(context, listen: false)
        .fetchEventAll(widget.search);
  }

  Future<void> loadMoreEvent() {
    return Provider.of<EventListProvider>(context, listen: false)
        .fetchEventMore(widget.search);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _addPostModal(BuildContext ctx) {
    if (!Provider.of<ProfileProvider>(context, listen: false).isProfile()) {
      showInSnackBar("You must create a profil first.");
      return;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      elevation: 5,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddEvent(),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  bool calendarForm = false;

  Card Search() {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _searchController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(24),
                  ],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.length > 24) {
                      return "Search length should be less than 24";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter a search term'),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5, bottom: 5, top: 5),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(color: Colors.grey[600], width: 1),
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.search),
                ],
              ),
              color: Colors.white,
              textColor: Colors.black,
              onPressed: () {
                submitForm(false);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5, bottom: 5, top: 5),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(color: Colors.grey[600], width: 1),
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.clear),
                ],
              ),
              color: Colors.white,
              textColor: Colors.black,
              onPressed: () {
                submitForm(true);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(color: Colors.grey[600], width: 1),
              ),
              child: Row(
                children: <Widget>[FaIcon(FontAwesomeIcons.calendar)],
              ),
              color: Colors.white,
              textColor: Colors.black,
              onPressed: () {
                setState(() {
                  calendarForm = !calendarForm;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void submitForm(bool all) async {
    if (all) {
      Provider.of<EventListProvider>(context, listen: false).fetchEventAll("");
      setState(() {
        _searchController.text = "";
      });
    } else {
      if (_formKey.currentState.validate()) {
        String search = _searchController.text;

        FocusScope.of(context).unfocus();

        Provider.of<EventListProvider>(context, listen: false)
            .fetchEventAll(search);
      }
    }
  }

  List _selectedEvents;
  DateTime _selectedDay;

  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    print(_selectedEvents);
  }

  final Map<DateTime, List> _events = {};

  Widget CalendarWidget() {
    List<Event> events = Provider.of<EventListProvider>(context).getEvents();
    setState(() {
      _events.clear();
      events.asMap().forEach((index, event) {
        List<String> dateString = event.date.split(" ")[0].split(".");
        String timeString = event.date.split(" ")[1];
        String parseString = dateString[2] + dateString[1] + dateString[0];
        // " " +
        // timeString +
        // ":00";
        DateTime parsedDate = DateTime.parse(parseString);

        List listAtDate = _events[parsedDate];

        if (listAtDate == null) _events[parsedDate] = new List();

        print("index ne " + index.toString());

        _events[parsedDate]
            .add({'name': event.title, "isDone": false, 'index': index});
      });
    });

    print(_events);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Search(),
        Container(
          child: Calendar(
            startOnMonday: true,
            isExpanded: true,
            weekDays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
            events: _events,
            onRangeSelected: (range) =>
                print("Range is ${range.from}, ${range.to}"),
            onDateSelected: (date) => _handleNewDate(date),
            isExpandable: true,
            eventDoneColor: Colors.green,
            selectedColor: Colors.grey,
            todayColor: Colors.yellow,
            eventColor: Colors.white,
            bottomBarColor: Colors.white,
            dayOfWeekStyle: TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
        _buildEventList()
      ],
    );
  }

  Widget _buildEventList() {
    if (_selectedEvents == null) {
      return Text("Not selected.");
    } else {
      List<Event> events = Provider.of<EventListProvider>(context).getEvents();

      return Expanded(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) => Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.5, color: Colors.black12),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
            child: InkWell(
                child: EventSummary(events[(_selectedEvents[index]['index'])])),
          ),
          itemCount: _selectedEvents.length,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    List<Event> events = Provider.of<EventListProvider>(context).getEvents();

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blueGrey, Colors.grey],
          ),
        ),
        child: Provider.of<EventListProvider>(context).isLoading()
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Provider.of<EventListProvider>(context).anyEvent()
                ? calendarForm
                    ? CalendarWidget()
                    : Column(
                        children: <Widget>[
                          Search(),
                          _createEventListView(events),
                        ],
                      )
                : Column(
                    children: <Widget>[
                      Search(),
                      Center(
                        child: Text("No events to show. ",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_addPostModal(context)},
        tooltip: "Add a Post",
        backgroundColor: Colors.green,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _createEventListView(List<Event> events) {
    int count = events == null ? 0 : events.length;
    if (count == 0) {
      return Text("There is no event to show.");
    } else {
      return Expanded(
        flex: 1,
        child: RefreshIndicator(
          onRefresh: refreshEvents,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!Provider.of<EventListProvider>(context, listen: false)
                      .isLoadingMore() &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                loadMoreEvent();
              }
            },
            child: ListView.builder(
              padding: EdgeInsets.zero,
              addAutomaticKeepAlives: true,
              itemCount: count,
              itemBuilder: (context, index) {
                return InkWell(child: EventSummary(events[index]));
              },
            ),
          ),
        ),
      );
    }
  }
}
