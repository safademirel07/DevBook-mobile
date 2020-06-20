import 'package:devbook_new/models/get/event.dart';
import 'package:devbook_new/widgets/event/event_detail.dart';
import 'package:devbook_new/widgets/post/post_list.dart';
import 'package:devbook_new/widgets/profile/profile_list.dart';
import 'package:devbook_new/widgets/profile/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:random_color/random_color.dart';

import '../CustomCircleAvatar.dart';

class EventSummary extends StatelessWidget {
  final Event event;
  EventSummary(this.event);

  @override
  Widget build(BuildContext context) {
    int titleLength = this.event.title.length;

    if (titleLength > 36) titleLength = 36;

    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => EventDetailWidget(this.event.sId)),
          );
        },
        child: Row(
          children: <Widget>[
            Container(
              margin: new EdgeInsets.all(10.0),
              width: 50.0,
              height: 50.0,
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: FaIcon(FontAwesomeIcons.calendarAlt)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              event.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      this.event.location,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      this.event.date,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
