import 'package:devbook_new/providers/post_list_provider.dart';
import 'package:devbook_new/providers/post_provider.dart';
import 'package:devbook_new/widgets/post/post_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../CustomCircleAvatar.dart';

class CommentWidget extends StatelessWidget {
  final String id;
  final String profileName;
  final String profileImageUrl;
  final String text;
  final String profileID;
  final String date;
  final bool isMine;

  CommentWidget(this.id, this.profileID, this.profileName, this.profileImageUrl,
      this.text, this.date, this.isMine);

  @override
  Widget build(BuildContext context) {
    return isMine
        ? Dismissible(
            key: UniqueKey(),
            confirmDismiss: (DismissDirection direction) async {
              final bool res = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm"),
                    content: const Text(
                        "Are you sure you wish to delete this comment?"),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () => {
                                Provider.of<PostProvider>(context,
                                        listen: false)
                                    .removeComment(this.id),
                                Navigator.of(context).pop(true),
                              },
                          child: const Text("DELETE")),
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("CANCEL"),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (_) {},
            child: Card(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  PostHeader(50, this.profileID, this.profileImageUrl,
                      this.profileName, this.date, this.isMine),
                  Container(
                    child: Divider(
                      height: 1,
                      thickness: 2,
                      color: Colors.grey[500],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            this.text,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Card(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            color: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                PostHeader(50, this.profileID, this.profileImageUrl,
                    this.profileName, this.date, this.isMine),
                Container(
                  child: Divider(
                    height: 1,
                    thickness: 2,
                    color: Colors.grey[500],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          this.text,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
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
