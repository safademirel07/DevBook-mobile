import 'package:devbook_new/widgets/profile/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../CustomCircleAvatar.dart';

class PostHeader extends StatelessWidget {
  final String profileID;
  final double imageRadius;
  final String imageUrl;
  final String name;
  final String date;
  final bool owner;

  const PostHeader(this.imageRadius, this.profileID, this.imageUrl, this.name,
      this.date, this.owner);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => ProfileWidget(this.profileID)),
        );
      },
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10.0),
            child: CustomCircleAvatar(
              animationDuration: 300,
              radius: imageRadius,
              imagePath: (imageUrl == null || imageUrl.length == 0)
                  ? 'https://s3.amazonaws.com/37assets/svn/765-default-avatar.png'
                  : imageUrl,
            ),
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
                          child: new Text(
                            name,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    if (owner)
                      Column(
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              margin: const EdgeInsets.only(top: 4, right: 8),
                              child: Icon(
                                FontAwesomeIcons.ellipsisH,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: new Text(
                    date,
                    style: new TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 13.0,
                        color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
