import 'package:devbook_new/models/get/profile.dart';
import 'package:devbook_new/providers/post_list_provider.dart';
import 'package:devbook_new/providers/profile_list_provider.dart';
import 'package:devbook_new/widgets/profile/profile_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProfileListWidget extends StatefulWidget {
  String search;

  ProfileListWidget(this.search);
  @override
  _ProfileListWidgetState createState() => _ProfileListWidgetState();
}

class _ProfileListWidgetState extends State<ProfileListWidget> {
  initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProfileListProvider>(context, listen: false)
            .fetchProfileAll(widget.search));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> refreshProfiles() {
    return Provider.of<ProfileListProvider>(context, listen: false)
        .fetchProfileAll(_searchController.toString());
  }

  Future<void> loadMoreProfile() {
    return Provider.of<ProfileListProvider>(context, listen: false)
        .fetchProfileMore(_searchController.toString());
  }

  void refreshProfileList() {}

  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

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

  void submitForm(bool all) async {
    if (all) {
      _searchController.text = "";
      Provider.of<ProfileListProvider>(context, listen: false)
          .fetchProfileAll("");
    } else {
      if (_formKey.currentState.validate()) {
        String search = _searchController.text;

        FocusScope.of(context).unfocus();

        Provider.of<ProfileListProvider>(context, listen: false)
            .fetchProfileAll(search);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    List<Profile> profiles =
        Provider.of<ProfileListProvider>(context).getProfiles();

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blueGrey, Colors.grey],
        ),
      ),
      child: Provider.of<ProfileListProvider>(context).isLoading()
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Provider.of<ProfileListProvider>(context).anyProfile()
              ? Column(
                  children: <Widget>[
                    Search(),
                    _createProfileListView(profiles),
                  ],
                )
              : Column(
                  children: <Widget>[
                    Search(),
                    Center(
                      child: Text("No profiles to show.",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
    ));
  }

  Widget _createProfileListView(List<Profile> profiles) {
    int count = profiles == null ? 0 : profiles.length;
    if (count == 0) {
      return Text("No profiles to show.");
    } else {
      return Expanded(
        child: RefreshIndicator(
          onRefresh: refreshProfiles,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!Provider.of<ProfileListProvider>(context, listen: false)
                      .isLoadingMore() &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                loadMoreProfile();
              }
            },
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: profiles == null ? 0 : profiles.length,
              itemBuilder: (BuildContext context, int index) {
                return ProfileSummary(
                    profiles[index].sId,
                    profiles[index].profilePhoto,
                    profiles[index].handler,
                    profiles[index].company,
                    false);
              },
            ),
          ),
        ),
      );
    }
  }
}
