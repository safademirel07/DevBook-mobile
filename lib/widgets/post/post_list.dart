import 'dart:ffi';

import 'package:devbook_new/models/get/post.dart';
import 'package:devbook_new/providers/post_list_provider.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:devbook_new/widgets/post/add_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'post.dart';

class PostList extends StatefulWidget {
  final String hashtag;
  final String search;

  const PostList(this.hashtag, this.search);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  initState() {
    super.initState();
    Future.microtask(() => {
          Provider.of<PostListProvider>(context, listen: false)
              .setFetchAgain(false),
          Provider.of<PostListProvider>(context, listen: false)
              .fetchPostAll(widget.hashtag, selectedSort, widget.search)
        });
  }

  @override
  void didChangeDependencies() {
    if (Provider.of<PostListProvider>(context, listen: false).getFetchAgain()) {
      Future.microtask(() => {
            Provider.of<PostListProvider>(context, listen: false)
                .setFetchAgain(false),
            Provider.of<PostListProvider>(context, listen: false)
                .fetchPostAll(widget.hashtag, selectedSort, widget.search)
          });
    }

    Future.microtask(() => {errorHandler()});

    super.didChangeDependencies();
  }

  Future<void> errorHandler() {
    String providerMessage =
        Provider.of<PostListProvider>(context, listen: false).getMessage();

    if (providerMessage != null && providerMessage.length != 0) {
      showInSnackBar(providerMessage);
      Provider.of<PostListProvider>(context, listen: false).setMessage("");
    }
  }

  Future<void> refreshPosts() {
    print("refreshposts" + widget.search);
    print("refreshpostsdigeri " + _searchController.text);
    return Provider.of<PostListProvider>(context, listen: false)
        .fetchPostAll(widget.hashtag, selectedSort, _searchController.text);
  }

  Future<void> loadMorePost() {
    print("loadmorepost " + widget.hashtag);

    return Provider.of<PostListProvider>(context, listen: false)
        .fetchPostMore(widget.hashtag, selectedSort, _searchController.text);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _addPostModal(BuildContext ctx) {
    if (!Provider.of<ProfileProvider>(context, listen: false).isProfile()) {
      showInSnackBar("You must create a profil first.");
      return;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      elevation: 5,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddPost(widget.hashtag, selectedSort, _searchController.text),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void submitForm(bool all) async {
    print("submitform " + selectedSort.toString());
    if (all) {
      Provider.of<PostListProvider>(context, listen: false)
          .fetchPostAll(widget.hashtag, selectedSort, "");
      setState(() {
        _searchController.text = "";
      });
    } else {
      if (_formKey.currentState.validate()) {
        String search = _searchController.text;

        print("Aranan search kelimesi " + search);

        FocusScope.of(context).unfocus();

        Provider.of<PostListProvider>(context, listen: false)
            .fetchPostAll(widget.hashtag, 0, search);
      }
    }
  }

  String sort = 'Newest to Oldest';

  int selectedSort = 0;

  var sorts = <String>[
    'Newest to Oldest',
    'Oldest to Newest',
    'Reader by Descend',
    'Reader by Ascend',
  ];

  void changeSort(int index) {
    setState(() {
      selectedSort = index;
    });
    refreshPosts();
  }

  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Post> posts = Provider.of<PostListProvider>(context).getPosts();

    print("hashtag" + widget.hashtag);
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
        child: Provider.of<PostListProvider>(context).isLoading()
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Provider.of<PostListProvider>(context).anyPost()
                ? Column(
                    children: <Widget>[
                      Search(),
                      _createProfileListView(posts),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      Search(),
                      Center(
                        child: Text("No post to show.",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_addPostModal(context)},
        tooltip: "Add a Post",
        backgroundColor: Colors.green,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget Search() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(bottom: 10, top: 10),
      child: Material(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          title: Text(
            "Search and Sort",
            style: TextStyle(color: Colors.black),
          ),
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 10, bottom: 5, top: 5),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _searchController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(24),
                            ],
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              if (value.length > 24) {
                                return "Search length should be less than 24";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter a search term'),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10, bottom: 5, top: 5),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.grey[600], width: 1),
                        ),
                        child: Icon(Icons.search),
                        color: Colors.white,
                        textColor: Colors.black,
                        onPressed: () {
                          submitForm(false);
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10, bottom: 5, top: 5),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.grey[600], width: 1),
                        ),
                        child: Icon(Icons.clear),
                        color: Colors.white,
                        textColor: Colors.black,
                        onPressed: () {
                          submitForm(true);
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Sort",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 10),
                      DropdownButton<String>(
                        value: sort,
                        onChanged: (String newValue) {
                          setState(() {
                            sort = newValue;
                          });
                          changeSort(sorts.indexOf(newValue));
                        },
                        items:
                            sorts.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _createProfileListView(List<Post> posts) {
    int count = posts == null ? 0 : posts.length;
    if (count == 0) {
      return Text("There is no profile to show.");
    } else {
      return Expanded(
        child: RefreshIndicator(
          onRefresh: refreshPosts,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!Provider.of<PostListProvider>(context, listen: false)
                      .isLoadingMore() &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                loadMorePost();
              }
            },
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: count,
              itemBuilder: (context, index) {
                return posts[index].isMine
                    ? Dismissible(
                        key: UniqueKey(),
                        confirmDismiss: (DismissDirection direction) async {
                          final bool res = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text(
                                    "Are you sure you wish to delete this post?"),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () => {
                                            Provider.of<PostListProvider>(
                                                    context,
                                                    listen: false)
                                                .removePost(posts[index].sId),
                                            Navigator.of(context).pop(true),
                                          },
                                      child: const Text("DELETE")),
                                  FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("CANCEL"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (_) {},
                        child: InkWell(
                          child: PostWidget(
                            posts[index].sId,
                            posts[index].isMine,
                            posts[index].profileName,
                            posts[index].profileImage,
                            posts[index].text,
                            posts[index].date,
                            posts[index].like,
                            posts[index].commentLength,
                            posts[index].isLiked,
                            posts[index].isDisliked,
                            false,
                            posts[index].profile,
                            posts[index].readers,
                            index,
                          ),
                        ),
                      )
                    : InkWell(
                        child: PostWidget(
                          posts[index].sId,
                          posts[index].isMine,
                          posts[index].profileName,
                          posts[index].profileImage,
                          posts[index].text,
                          posts[index].date,
                          posts[index].like,
                          posts[index].commentLength,
                          posts[index].isLiked,
                          posts[index].isDisliked,
                          false,
                          posts[index].profile,
                          posts[index].readers,
                          index,
                        ),
                      );
              },
            ),
          ),
        ),
      );
    }
  }
}
