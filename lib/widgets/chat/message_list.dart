import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/models/get/hashtag.dart';
import 'package:devbook_new/models/get/message.dart';
import 'package:devbook_new/providers/hashtag_list_provider.dart';
import 'package:devbook_new/providers/message_list_provider.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:devbook_new/widgets/chat/message.dart';
import 'package:devbook_new/widgets/hashtag/hashtag.dart';
import 'package:devbook_new/widgets/post/add_post.dart';
import 'package:devbook_new/widgets/profile/profile_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

class MessageList extends StatefulWidget {
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  initState() {
    super.initState();
    Future.microtask(() => {
          Provider.of<MessageListProvider>(context, listen: false)
              .setFetchAgain(false),
          Provider.of<MessageListProvider>(context, listen: false)
              .fetchMessageAll()
        });
  }

  @override
  void didChangeDependencies() {
    if (Provider.of<MessageListProvider>(context, listen: false)
        .getFetchAgain()) {
      Future.microtask(() => {
            Provider.of<MessageListProvider>(context, listen: false)
                .setFetchAgain(false),
            Provider.of<MessageListProvider>(context, listen: false)
                .fetchMessageAll()
          });
    }

    Future.microtask(() => {errorHandler()});

    super.didChangeDependencies();
  }

  Future<void> errorHandler() {
    String providerMessage =
        Provider.of<MessageListProvider>(context, listen: false).getMessage();

    if (providerMessage != null && providerMessage.length != 0) {
      showInSnackBar(providerMessage);
      Provider.of<MessageListProvider>(context, listen: false).setMessage("");
    }
  }

  Future<void> refreshHashtags() {
    return Provider.of<MessageListProvider>(context, listen: false)
        .fetchMessageAll();
  }

  Future<void> loadMoreHashtag() {
    return Provider.of<MessageListProvider>(context, listen: false)
        .fetchMessageMore();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    List<Message> messages =
        Provider.of<MessageListProvider>(context).getMessages();

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
        child: Provider.of<MessageListProvider>(context).isLoading()
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Provider.of<MessageListProvider>(context).anyMessage()
                ? Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: <Widget>[_createMessageListView(messages)],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text("You don't have a conversation.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileListWidget(""),
                            ));
                          },
                          child: Text(
                              "Click here to find people to chat right now.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _createMessageListView(List<Message> messages) {
    int count = messages == null ? 0 : messages.length;
    if (count == 0) {
      return Text("There is no hashtag to show.");
    } else {
      return Expanded(
        flex: 1,
        child: RefreshIndicator(
          onRefresh: refreshHashtags,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!Provider.of<MessageListProvider>(context, listen: false)
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
                    child: MessageSummary(
                  messages[index].peerProfile,
                  messages[index].lastMessage,
                  messages[index].date,
                  messages[index].pairID,
                ));
              },
            ),
          ),
        ),
      );
    }
  }
}
