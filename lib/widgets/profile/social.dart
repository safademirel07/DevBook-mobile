import 'package:devbook_new/models/get/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialWidget extends StatelessWidget {
  final SocialMedia social;

  SocialWidget(this.social);

  bool _facebookValid = false;
  bool _instagramValid = false;
  bool _twitterValid = false;
  bool _linkedinValid = false;
  bool _youtubeValid = false;

  //test
  @override
  Widget build(BuildContext context) {
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (_facebookValid)
            buildSocial(FontAwesomeIcons.facebook, social.facebook),
          if (_twitterValid)
            buildSocial(FontAwesomeIcons.twitter, social.twitter),
          if (_instagramValid)
            buildSocial(FontAwesomeIcons.instagram, social.instagram),
          if (_youtubeValid)
            buildSocial(FontAwesomeIcons.youtube, social.youtube),
          if (_linkedinValid)
            buildSocial(FontAwesomeIcons.linkedin, social.linkedin),
        ],
      ),
    );
  }

  Widget buildSocial(IconData icon, String text) {
    return InkWell(
      onTap: () {
        try {
          launch(text);
        } catch (e) {}
      },
      child: Card(
        color: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
