import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devbook_new/models/get/firebase.dart';
import 'package:devbook_new/models/get/profile.dart';
import 'package:devbook_new/widgets/chat/chat.dart';
import 'package:devbook_new/widgets/post/post_list.dart';
import 'package:devbook_new/widgets/profile/profile_list.dart';
import 'package:devbook_new/widgets/profile/profile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:random_color/random_color.dart';

import '../CustomCircleAvatar.dart';

class MessageSummary extends StatelessWidget {
  final Profile peerProfile;
  final String lastMessage;
  final String lastMessageDate;
  final String pairID;
  MessageSummary(
      this.peerProfile, this.lastMessage, this.lastMessageDate, this.pairID);

  final FirebaseUser user = Firebase().getUser();

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
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Chat(
              peerProfile: peerProfile,
            ),
          ));
        },
        child: Row(
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.all(10.0),
              width: 50.0,
              height: 50.0,
              child: CustomCircleAvatar(
                animationDuration: 300,
                radius: 50,
                imagePath: (peerProfile.profilePhoto == null ||
                        peerProfile.profilePhoto.length == 0)
                    ? 'https://s3.amazonaws.com/37assets/svn/765-default-avatar.png'
                    : peerProfile.profilePhoto,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: new Text(
                      peerProfile.handler,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection('messages')
                                  .document(pairID)
                                  .collection(pairID)
                                  .orderBy('timestamp', descending: true)
                                  .limit(1)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return new Text("");
                                }
                                return Text(
                                  snapshot.data.documents[0]['content'],
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.left,
                                  style: (snapshot.data.documents[0]["read"] ==
                                              0 &&
                                          snapshot.data.documents[0]
                                                  ['idFrom'] !=
                                              user.email)
                                      ? TextStyle(fontWeight: FontWeight.bold)
                                      : TextStyle(),
                                );
                              }),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          lastMessageDate,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
