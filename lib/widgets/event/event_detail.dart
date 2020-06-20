import 'dart:async';

import 'package:devbook_new/data/MapUtils.dart';
import 'package:devbook_new/models/get/event.dart';
import 'package:devbook_new/providers/event_provider.dart';
import 'package:devbook_new/widgets/profile/biography.dart';
import 'package:devbook_new/widgets/profile/profile_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:devbook_new/models/get/profile.dart';

class EventDetailWidget extends StatefulWidget {
  final String id;
  EventDetailWidget(this.id);

  @override
  _EventDetailWidgetState createState() => _EventDetailWidgetState(this.id);
}

class _EventDetailWidgetState extends State<EventDetailWidget> {
  final String id;
  _EventDetailWidgetState(this.id);

  @override
  void dispose() {
    super.dispose();
  }

  var _isInit = true;
  var _isLoading = false;

  Future<Profile> _future;

  initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<EventProvider>(context, listen: false).fetchEvent(this.id));
  }

  @override
  void didChangeDependencies() {
    Future.microtask(() => {checkStatus()});

    super.didChangeDependencies();
  }

  Future<void> checkStatus() {}

  Future<void> refreshEvent() {
    return Provider.of<EventProvider>(context, listen: false)
        .fetchEvent(this.id);
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    double screenHeight = MediaQuery.of(context).size.height;

    Event event = Provider.of<EventProvider>(context).getEvent();

    bool isMine = this.id.length == 0 ? true : false;

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey, Colors.grey],
            ),
          ),
          child: Provider.of<EventProvider>(context).isEvent()
              ? eventBuilder(event, isMine, _scrollController, screenHeight)
              : Center(child: CircularProgressIndicator())),
    );
  }

  void eventStatus(bool going) {
    if (going) {
      Provider.of<EventProvider>(context, listen: false)
          .participationRequest(widget.id);
    } else {
      Provider.of<EventProvider>(context, listen: false)
          .maybeRequest(widget.id);
    }
  }

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Widget eventBuilder(Event event, bool isMine,
      ScrollController scrollController, double screenHeight) {
    Set<Marker> _markers = {
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(
          double.parse(event.latitude),
          double.parse(event.longitude),
        ),
        infoWindow: InfoWindow(title: event.title, snippet: 'Event Location'),
      ),
    };
    return RefreshIndicator(
      onRefresh: refreshEvent,
      child: SingleChildScrollView(
        controller: scrollController,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      child: Material(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          initiallyExpanded: true,
                          title: Text(
                            "Details",
                            style: TextStyle(color: Colors.black),
                          ),
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              margin: EdgeInsets.only(bottom: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Card(
                                    color: Colors.grey[300],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 8, bottom: 8, top: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Text(
                                                event.title,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                        text: "Description: ",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      new TextSpan(
                                                        text: event.description,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                "Date: ",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              InkWell(
                                                child: Flexible(
                                                  child: Text(
                                                    event.date,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                onTap: () => print("safa"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 10, bottom: 5),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(
                                          color: Colors.grey[600], width: 1),
                                    ),
                                    child: Text("I'm Going"),
                                    color: event.isParticipant
                                        ? Colors.black
                                        : Colors.white,
                                    textColor: event.isParticipant
                                        ? Colors.white
                                        : Colors.black,
                                    onPressed: () {
                                      eventStatus(true);
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10, bottom: 5),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(
                                          color: Colors.grey[600], width: 1),
                                    ),
                                    child: Text("I'm Interested"),
                                    color: event.isMaybe
                                        ? Colors.black
                                        : Colors.white,
                                    textColor: event.isMaybe
                                        ? Colors.white
                                        : Colors.black,
                                    onPressed: () {
                                      eventStatus(false);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      child: Material(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            "Going (" + event.participantCount.toString() + ")",
                            style: TextStyle(color: Colors.black),
                          ),
                          children: <Widget>[
                            if (event.participants == null ||
                                event.participants.length == 0)
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(
                                    "There is no one going to this event."),
                              )
                            else
                              for (int i = 0;
                                  i < event.participants.length;
                                  i++)
                                ProfileSummary(
                                    event.participants[i].profileID,
                                    event.participants[i].profileImage,
                                    event.participants[i].profileName,
                                    event.participants[i].profileJob),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      child: Material(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            "Interested (" + event.maybeCount.toString() + ")",
                            style: TextStyle(color: Colors.black),
                          ),
                          children: <Widget>[
                            if (event.maybes == null ||
                                event.maybes.length == 0)
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(
                                    "There is no one interested in this event."),
                              )
                            else
                              for (int i = 0; i < event.maybes.length; i++)
                                ProfileSummary(
                                    event.maybes[i].profileID,
                                    event.maybes[i].profileImage,
                                    event.maybes[i].profileName,
                                    event.maybes[i].profileJob),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      child: Material(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            "Location",
                            style: TextStyle(color: Colors.black),
                          ),
                          children: <Widget>[
                            SizedBox(
                                width: MediaQuery.of(context)
                                    .size
                                    .width, // or use fixed size like 200
                                height: 200,
                                child: GoogleMap(
                                  markers: _markers,
                                  mapType: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                        double.parse(event.latitude),
                                        double.parse(event.longitude),
                                      ),
                                      zoom: 15),
                                )),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              child: InkWell(
                                child: Center(child: Text("Open in Maps")),
                                onTap: () {
                                  MapUtils.openMap(double.parse(event.latitude),
                                      double.parse(event.longitude));
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
