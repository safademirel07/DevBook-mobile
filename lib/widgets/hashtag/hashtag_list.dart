import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/models/get/hashtag.dart';
import 'package:devbook_new/providers/hashtag_list_provider.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:devbook_new/widgets/hashtag/hashtag.dart';
import 'package:devbook_new/widgets/post/add_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

class HashtagList extends StatefulWidget {
  String hashtag;

  HashtagList(this.hashtag);

  @override
  _HashtagListState createState() => _HashtagListState();
}

class _HashtagListState extends State<HashtagList> {
  initState() {
    super.initState();
    Future.microtask(() => {
          Provider.of<HashtagListProvider>(context, listen: false)
              .setFetchAgain(false),
          Provider.of<HashtagListProvider>(context, listen: false)
              .fetchHashtagAll(widget.hashtag)
        });
  }

  @override
  void didChangeDependencies() {
    if (Provider.of<HashtagListProvider>(context, listen: false)
        .getFetchAgain()) {
      Future.microtask(() => {
            Provider.of<HashtagListProvider>(context, listen: false)
                .setFetchAgain(false),
            Provider.of<HashtagListProvider>(context, listen: false)
                .fetchHashtagAll(widget.hashtag)
          });
    }

    Future.microtask(() => {errorHandler()});

    super.didChangeDependencies();
  }

  Future<void> errorHandler() {
    String providerMessage =
        Provider.of<HashtagListProvider>(context, listen: false).getMessage();

    if (providerMessage != null && providerMessage.length != 0) {
      showInSnackBar(providerMessage);
      Provider.of<HashtagListProvider>(context, listen: false).setMessage("");
    }
  }

  Future<void> refreshHashtags() {
    return Provider.of<HashtagListProvider>(context, listen: false)
        .fetchHashtagAll(widget.hashtag);
  }

  Future<void> loadMoreHashtag() {
    return Provider.of<HashtagListProvider>(context, listen: false)
        .fetchHashtagMore(widget.hashtag);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  void submitForm(bool all) async {
    if (all) {
      Provider.of<HashtagListProvider>(context, listen: false)
          .fetchHashtagAll("");
      setState(() {
        _searchController.text = "";
      });
    } else {
      if (_formKey.currentState.validate()) {
        String search = _searchController.text;

        FocusScope.of(context).unfocus();

        Provider.of<HashtagListProvider>(context, listen: false)
            .fetchHashtagAll(search);
      }
    }
  }

  Card Search() {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Hashtag> hashtags =
        Provider.of<HashtagListProvider>(context).getHashtags();

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
        child: Provider.of<HashtagListProvider>(context).isLoading()
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Provider.of<HashtagListProvider>(context).anyHashtag()
                ? Column(
                    children: <Widget>[
                      Search(),
                      _createHashtagListView(hashtags)
                    ],
                  )
                : Column(
                    children: <Widget>[
                      Search(),
                      Center(
                        child: Text("No hashtag to show.",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _createHashtagListView(List<Hashtag> hashtags) {
    int count = hashtags == null ? 0 : hashtags.length;
    if (count == 0) {
      return Text("There is no hashtag to show.");
    } else {
      return Expanded(
        flex: 1,
        child: RefreshIndicator(
          onRefresh: refreshHashtags,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!Provider.of<HashtagListProvider>(context, listen: false)
                      .isLoadingMore() &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                loadMoreHashtag();
              }
            },
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: count,
              itemBuilder: (context, index) {
                return InkWell(
                    child: HashtagSummary(
                        hashtags[index].sId,
                        hashtags[index].hashtag,
                        hashtags[index].value,
                        hashtags[index].color));
              },
            ),
          ),
        ),
      );
    }
  }
}
