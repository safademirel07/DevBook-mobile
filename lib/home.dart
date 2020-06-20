import 'package:devbook_new/models/get/hashtag.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:devbook_new/widgets/event/event_list.dart';
import 'package:devbook_new/widgets/hashtag/hashtag_list.dart';
import 'package:devbook_new/widgets/other/logo.dart';
import 'package:devbook_new/widgets/profile/create_profile.dart';
import 'package:devbook_new/widgets/profile/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'data/sharedpref/shared_preference_helper.dart';
import 'main.dart';
import 'widgets/post/post_list.dart';
import 'widgets/profile/profile_list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;
  PageController _c;
  @override
  void initState() {
    _c = new PageController(
      initialPage: _page,
    );
    Future.microtask(() =>
        Provider.of<ProfileProvider>(context, listen: false).fetchProfile(""));

    super.initState();
  }

  int _currentIndex = 0;

  final List<Widget> _children = [
    PostList("", ""),
    HashtagList(""),
    EventList(""),
    ProfileListWidget(""),
    ProfileWidget(""),
  ];

  void onTabTapped(int index) {
    this._c.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);

    setState(() {
      _currentIndex = index;
    });
  }

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

  Widget createProfile() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blueGrey, Colors.grey],
        ),
      ),
      child: Center(
          child: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Logo(MainAxisAlignment.center),
              Container(
                margin: EdgeInsets.only(top: 3),
                child: Text(
                  "Create a Profile.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Container(
                child: CreateProfile(
                  "",
                  "",
                  "",
                  "",
                  "",
                  "",
                  "",
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Provider.of<ProfileProvider>(context).getCreateProfile()
            ? createProfile()
            : PageView(
                controller: _c,
                onPageChanged: (newPage) {
                  setState(() {
                    this._page = newPage;
                  });
                },
                children: _children,
              ),
        bottomNavigationBar:
            (!Provider.of<ProfileProvider>(context).getCreateProfile())
                ? BottomNavigationBar(
                    currentIndex: _page,
                    onTap: (index) {
                      this._c.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    type: BottomNavigationBarType.fixed,
                    items: [
                      new BottomNavigationBarItem(
                        icon: Icon(Icons.comment),
                        title: Text('Feed'),
                      ),
                      new BottomNavigationBarItem(
                        icon: FaIcon(FontAwesomeIcons.hashtag),
                        title: Text('Hashtags'),
                      ),
                      new BottomNavigationBarItem(
                        icon: FaIcon(FontAwesomeIcons.calendarAlt),
                        title: Text('Events'),
                      ),
                      new BottomNavigationBarItem(
                        icon: Icon(Icons.people),
                        title: Text('Profiles'),
                      ),
                      new BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        title: Text('My Profile'),
                      )
                    ],
                  )
                : null,
      ),
    );
  }
}
