import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';
import 'package:devbook_new/main.dart';
import 'package:devbook_new/models/get/profile.dart';
import 'package:devbook_new/providers/user_provider.dart';
import 'package:devbook_new/widgets/CustomCircleAvatar.dart';
import 'package:devbook_new/widgets/other/login.dart';
import 'package:devbook_new/widgets/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Header extends StatelessWidget {
  Profile profile;
  String profileImage;
  String handler;
  String location;
  String company;
  SocialMedia social;
  bool owner;
  bool _facebookValid = false;
  bool _instagramValid = false;
  bool _twitterValid = false;
  bool _linkedinValid = false;
  bool _youtubeValid = false;

  Header(this.profile, this.profileImage, this.handler, this.location,
      this.company, this.social, this.owner) {
    _facebookValid = this.social.facebook != null
        ? this.social.facebook.length == 0
            ? false
            : Uri.parse(this.social.facebook).isAbsolute
        : false;
    _instagramValid = this.social.instagram != null
        ? this.social.instagram.length == 0
            ? false
            : Uri.parse(this.social.instagram).isAbsolute
        : false;
    _twitterValid = this.social.twitter != null
        ? this.social.twitter.length == 0
            ? false
            : Uri.parse(this.social.twitter).isAbsolute
        : false;
    _linkedinValid = this.social.linkedin != null
        ? this.social.linkedin.length == 0
            ? false
            : Uri.parse(this.social.linkedin).isAbsolute
        : false;
    _youtubeValid = this.social.youtube != null
        ? this.social.youtube.length == 0
            ? false
            : Uri.parse(this.social.youtube).isAbsolute
        : false;
  }

  void _editProfileModal(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      elevation: 10,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: EditProfile(
            profile.handler,
            profile.company,
            profile.profilePhoto,
            profile.website,
            profile.location,
            profile.biography,
            profile.githubUsername,
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding; //Safe Area
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: Material(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: CustomCircleAvatar(
                    animationDuration: 300,
                    radius: screenHeight * 0.25,
                    imagePath: this.profileImage != null
                        ? this.profileImage.length == 0
                            ? 'https://s3.amazonaws.com/37assets/svn/765-default-avatar.png'
                            : this.profileImage
                        : 'https://s3.amazonaws.com/37assets/svn/765-default-avatar.png',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              handler,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            if (owner)
                              InkWell(
                                onTap: () {
                                  _editProfileModal(context);
                                },
                                child: Icon(Icons.edit),
                              ),
                            SizedBox(
                              width: 5,
                            ),
                            /*
                            if (owner)
                              InkWell(
                                onTap: () {
                                  logoutRequest(context);
                                },
                                child: Icon(Icons.exit_to_app),
                              ),
                              */
                          ],
                        ),
                        Text(
                          location,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          company,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: socialBuilder()),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> socialBuilder() {
    List<Widget> widgetList = List<Widget>();

    var socialMap = [
      {
        "isValid": _facebookValid,
        "link": social.facebook,
        "icon": FontAwesomeIcons.facebook
      },
      {
        "isValid": _twitterValid,
        "link": social.twitter,
        "icon": FontAwesomeIcons.twitter
      },
      {
        "isValid": _instagramValid,
        "link": social.instagram,
        "icon": FontAwesomeIcons.instagram
      },
      {
        "isValid": _linkedinValid,
        "link": social.linkedin,
        "icon": FontAwesomeIcons.linkedin
      },
      {
        "isValid": _youtubeValid,
        "link": social.youtube,
        "icon": FontAwesomeIcons.youtube
      },
    ];

    for (int i = 0; i < socialMap.length; i++) {
      Map<String, Object> map = socialMap[i];
      if (map['isValid']) {
        widgetList.add(InkWell(
          onTap: () => launch(map['link']),
          child: FaIcon(
            map['icon'],
            color: Colors.black.withOpacity(0.8),
          ),
        ));
        widgetList.add(SizedBox(width: 10));
      }
    }

    return widgetList;
  }
}
