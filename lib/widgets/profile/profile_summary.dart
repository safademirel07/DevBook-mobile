import 'package:devbook_new/widgets/profile/profile_widget.dart';
import 'package:flutter/material.dart';

import '../CustomCircleAvatar.dart';

class ProfileSummary extends StatelessWidget {
  final String userName;
  final String profilePhoto;
  final String job;
  final String id;

  ProfileSummary(this.id, this.profilePhoto, this.userName, this.job);

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
            MaterialPageRoute(builder: (context) => ProfileWidget(this.id)),
          );
        },
        child: Row(
          children: <Widget>[
            Container(
              margin: new EdgeInsets.all(10.0),
              child: CustomCircleAvatar(
                animationDuration: 300,
                radius: 50.0,
                imagePath: this.profilePhoto != null
                    ? this.profilePhoto.length == 0
                        ? 'https://s3.amazonaws.com/37assets/svn/765-default-avatar.png'
                        : this.profilePhoto
                    : 'https://s3.amazonaws.com/37assets/svn/765-default-avatar.png',
              ),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    userName,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    job,
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
