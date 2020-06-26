import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devbook_new/models/get/firebase.dart';
import 'package:devbook_new/models/get/message.dart';
import 'package:devbook_new/models/get/profile.dart';
import 'package:devbook_new/providers/event_list_provider.dart';
import 'package:devbook_new/providers/message_list_provider.dart';
import 'package:devbook_new/widgets/profile/profile_summary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  final Profile peerProfile;
  const Chat({Key key, this.peerProfile}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  final FirebaseUser user = Firebase().getUser();

  var listMessage;
  String groupChatId;

  bool isLoading;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String getGroupChatID() {
    String myID = user.email;
    String peerID = widget.peerProfile.email;

    if (myID.hashCode <= peerID.hashCode) {
      return '$myID-$peerID';
    } else {
      return '$peerID-$myID';
    }
  }

  @override
  void initState() {
    super.initState();

    groupChatId = getGroupChatID();

    isLoading = false;
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      DateTime time = DateTime.now();

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': user.email,
            'idTo': widget.peerProfile.email,
            'timestamp': time.millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type,
            'read': 0,
          },
        );

        Message message = new Message();
        message.date = time.toString();
        message.lastMessage = content;
        message.peerProfile = widget.peerProfile;
        message.pairID = groupChatId;
        Provider.of<MessageListProvider>(context, listen: false)
            .addMessage(message);
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Type your message...');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] != user.email) {
      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(document['timestamp']);

      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(
          documentReference,
          {
            'read': 1,
          },
        );
      });
    }

    if (document['idFrom'] == user.email) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Flexible(
                  child: Text(
                    document["content"],
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        DateFormat('kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(document['timestamp']),
                          ),
                        ),
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    FaIcon(
                      (document['read'] == 0
                          ? FontAwesomeIcons.check
                          : FontAwesomeIcons.checkDouble),
                      size: 18,
                      color:
                          (document['read'] == 0 ? Colors.grey : Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
            width: 220.0,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          ),
        ],
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: widget.peerProfile.profilePhoto,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        document['content'],
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            DateFormat('kk:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(document['timestamp']),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
                  width: 220.0,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                ),
              ],
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == user.email) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != user.email) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 8),
              child: TextField(
                onSubmitted: (value) =>
                    onSendMessage(textEditingController.text, 0),
                style: TextStyle(color: Colors.blue, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Colors.blue,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                ProfileSummary(
                    widget.peerProfile.sId,
                    widget.peerProfile.profilePhoto,
                    widget.peerProfile.handler,
                    widget.peerProfile.location,
                    true),

                // List of messages
                buildListMessage(),

                // Input content
                buildInput(),
              ],
            ),

            // Loading
            buildLoading()
          ],
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}
