import 'package:devbook_new/providers/post_list_provider.dart';
import 'package:devbook_new/providers/post_provider.dart';
import 'package:devbook_new/widgets/post/post_header.dart';
import 'package:devbook_new/widgets/post/post_list.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../CustomCircleAvatar.dart';
import 'comment_list.dart';

class PostForCommentWidget extends StatelessWidget {
  final String id;
  final String profileImageUrl;
  final String userName;
  final String message;
  final String date;
  final int like;
  final int commentCount;
  final bool owner;

  final bool isLiked;
  final bool isDisliked;

  final String profileID;

  final int readers;
  final int listIndex;

  PostForCommentWidget(
    this.id,
    this.owner,
    this.userName,
    this.profileImageUrl,
    this.message,
    this.date,
    this.like,
    this.commentCount,
    this.isLiked,
    this.isDisliked,
    this.profileID,
    this.readers,
    this.listIndex,
  );

  @override
  Widget build(BuildContext context) {
    String text = this.message;
    var splitText = text.split(" ");

    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            children: <Widget>[
              PostHeader(50, this.profileID, this.profileImageUrl,
                  this.userName, this.date, this.owner),
              Divider(
                height: 1,
                thickness: 2,
                color: Colors.grey[500],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            for (int i = 0; i < splitText.length; i++)
                              if (splitText[i][0] == "#")
                                TextSpan(
                                  text: "${splitText[i]} ",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                )
                              else
                                TextSpan(
                                  text: "${splitText[i]} ",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 1,
                thickness: 2,
                color: Colors.grey[500],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Provider.of<PostProvider>(context, listen: false)
                            .likeRequest(this.id, context, listIndex);
                        Provider.of<PostListProvider>(context, listen: false)
                            .setFetchAgain(true);
                      },
                      child: Icon(
                        Icons.thumb_up,
                        color: this.isLiked ? Colors.green : Colors.grey[500],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                        border: new Border.all(
                          color: Colors.grey[500],
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        this.like.toString(),
                        style: TextStyle(
                            fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Provider.of<PostProvider>(context, listen: false)
                            .dislikeRequest(this.id, context, listIndex);
                        Provider.of<PostListProvider>(context, listen: false)
                            .setFetchAgain(true);
                      },
                      child: Icon(
                        Icons.thumb_down,
                        //color: Colors.red,
                        color: this.isDisliked ? Colors.red : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        right: 5,
                      ),
                      child: Text(
                        "Readers: (${this.readers})",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
