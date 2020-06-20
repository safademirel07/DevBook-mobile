import 'package:devbook_new/widgets/post/post_list.dart';
import 'package:devbook_new/widgets/profile/profile_list.dart';
import 'package:devbook_new/widgets/profile/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:random_color/random_color.dart';

import '../CustomCircleAvatar.dart';

class HashtagSummary extends StatelessWidget {
  final String hashtag;
  final int count;
  final String id;
  final Color color;
  HashtagSummary(this.id, this.hashtag, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PostList(this.hashtag, "")),
          );
        },
        child: Row(
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.all(10.0),
              width: 50.0,
              height: 50.0,
              child: CircleAvatar(
                  backgroundColor: color,
                  child: FaIcon(FontAwesomeIcons.hashtag)),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    hashtag.substring(1),
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    "Mention Times " + count.toString(),
                    style: new TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                        color: Colors.black),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
