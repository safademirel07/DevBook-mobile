import 'package:devbook_new/models/get/post.dart';
import 'package:devbook_new/providers/post_list_provider.dart';
import 'package:devbook_new/providers/post_provider.dart';
import 'package:devbook_new/widgets/post/add_comment.dart';
import 'package:devbook_new/widgets/post/post_for_comment.dart';
import 'package:devbook_new/widgets/post/post_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'comment.dart';
import 'post.dart';

class CommentList extends StatefulWidget {
  final String id;
  final int listIndex;

  CommentList(this.id, this.listIndex);

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  initState() {
    super.initState();
    Future.microtask(() => Provider.of<PostProvider>(context, listen: false)
        .fetchPost(widget.id, context, widget.listIndex));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> refreshPost() {
    return Future.microtask(() =>
        Provider.of<PostProvider>(context, listen: false)
            .fetchPost(widget.id, context, widget.listIndex));
  }

  void _addCommentModal(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      elevation: 5,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddComment(widget.id),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  Color gradientStart =
      Colors.deepPurple[700]; //Change start gradient color here
  Color gradientEnd = Colors.purple[500]; //Change end gradient color here
/*
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
  */

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    Post post = Provider.of<PostProvider>(context).getPost();

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_addCommentModal(context)},
        tooltip: "Add a Comment",
        backgroundColor: Colors.green,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey, Colors.grey],
            ),
          ),
          child: Provider.of<PostProvider>(context).isPost()
              ? RefreshIndicator(
                  onRefresh: refreshPost,
                  child: commentBuilder(post, context, widget.listIndex))
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}

Widget commentBuilder(Post post, BuildContext context, int index) {
  return ListView(
    children: <Widget>[
      PostForCommentWidget(
          post.sId,
          post.isMine,
          post.profileName,
          post.profileImage,
          post.text,
          post.date,
          post.like,
          post.commentLength,
          post.isLiked,
          post.isDisliked,
          post.profile,
          post.readers,
          index),
      for (int i = 0; i < post.comments.length; i++)
        CommentWidget(
          post.comments[i].sId,
          post.comments[i].profile,
          post.comments[i].profileName,
          post.comments[i].profileImage,
          post.comments[i].text,
          post.comments[i].date,
          post.comments[i].isMine,
        ),
    ],
  );
}
