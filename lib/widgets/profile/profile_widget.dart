import 'package:devbook_new/data/sharedpref/shared_preference_helper.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:devbook_new/providers/user_provider.dart';
import 'package:devbook_new/widgets/other/login.dart';
import 'package:devbook_new/widgets/other/logo.dart';
import 'package:devbook_new/widgets/profile/add_skill.dart';
import 'package:devbook_new/widgets/profile/create_profile.dart';
import 'package:devbook_new/widgets/profile/edit_profile.dart';
import 'package:devbook_new/widgets/profile/edit_social.dart';
import 'package:devbook_new/widgets/profile/social.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:devbook_new/models/get/profile.dart';
import 'package:devbook_new/widgets/profile/add_repository.dart';
import 'package:devbook_new/widgets/profile/education.dart';
import 'package:devbook_new/widgets/profile/experience.dart';
import 'package:devbook_new/widgets/profile/repository.dart';
import 'package:devbook_new/widgets/profile/skill.dart';

import '../../main.dart';
import 'add_education.dart';
import 'add_experience.dart';
import 'biography.dart';
import 'header.dart';

class ProfileWidget extends StatefulWidget {
  final String id;
  ProfileWidget(this.id);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState(this.id);
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final String id;
  _ProfileWidgetState(this.id);

  @override
  void dispose() {
    super.dispose();
  }

  void _editProfileModal(
    BuildContext ctx,
    String iHandler,
    String iCompanyName,
    String iProfilePhoto,
    String iWebsite,
    String iLocation,
    String iBiography,
    String iGithubUsername,
  ) {
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
            iHandler,
            iCompanyName,
            iProfilePhoto,
            iWebsite,
            iLocation,
            iBiography,
            iGithubUsername,
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _addRepositoryModal(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      elevation: 5,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddRepository(),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _addExperienceModal(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      elevation: 5,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddExperience(),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _addEducationModal(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      elevation: 5,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddEducation(),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _addSkillModal(BuildContext ctx) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      elevation: 5,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddSkill(),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _addSocialModal(BuildContext ctx, String facebook, String twitter,
      String instagram, String youtube, String linkedin, String github) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      elevation: 5,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: EditSocial(
              facebook, twitter, instagram, youtube, linkedin, github),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void logoutRequest(context) async {
    final token = await SharedPreferenceHelper.getAuthToken;

    if (token == null || token.toString().length == 0) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Login(),
      ));
    } else {
      Provider.of<UserProvider>(context, listen: false).logoutRequest();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Login(),
      ));
    }
  }

  var _isInit = true;
  var _isLoading = false;

  Future<Profile> _future;

  initState() {
    super.initState();
    Future.microtask(() => Provider.of<ProfileProvider>(context, listen: false)
        .fetchProfile(this.id));
  }

  @override
  void didChangeDependencies() {
    Future.microtask(() => {checkStatus()});

    super.didChangeDependencies();
  }

  Future<void> checkStatus() {}

  Future<void> refreshProfile() {
    return Provider.of<ProfileProvider>(context, listen: false)
        .fetchProfile(this.id);
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    double screenHeight = MediaQuery.of(context).size.height;

    Profile profile = Provider.of<ProfileProvider>(context).getProfile();

    bool isMine = this.id.length == 0 ? true : false;

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueGrey, Colors.grey],
            ),
          ),
          child: Provider.of<ProfileProvider>(context).isProfile()
              ? profileBuilder(profile, isMine, _scrollController, screenHeight)
              : Provider.of<ProfileProvider>(context).getCreateProfile()
                  ? Center(
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
                    ))
                  : Center(child: CircularProgressIndicator())),
    );
  }

  Widget profileBuilder(Profile profile, bool isMine,
      ScrollController scrollController, double screenHeight) {
    print("profile.skills.length" + profile.skills.length.toString());
    return RefreshIndicator(
      onRefresh: refreshProfile,
      child: SingleChildScrollView(
        controller: scrollController,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      child: Header(
                          profile,
                          profile.profilePhoto,
                          profile.handler,
                          profile.location,
                          profile.company,
                          profile.socialMedia,
                          isMine),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      child: Material(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            "Biography",
                            style: TextStyle(color: Colors.black),
                          ),
                          children: <Widget>[
                            Biography(profile.biography),
                            if (isMine)
                              Container(
                                margin: EdgeInsets.only(bottom: 10, right: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      child: Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      onTap: () => {
                                        _editProfileModal(
                                          context,
                                          profile.handler,
                                          profile.company,
                                          profile.profilePhoto,
                                          profile.website,
                                          profile.location,
                                          profile.biography,
                                          profile.githubUsername,
                                        )
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Material(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            "Skills",
                            style: TextStyle(color: Colors.black),
                          ),
                          children: <Widget>[
                            if (profile.skills == null ||
                                profile.skills.length == 0)
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(
                                    "There is no Skill information to show."),
                              )
                            else
                              for (int i = 0; i < profile.skills.length; i++)
                                SkillWidget(profile.skills[i].sId,
                                    profile.skills[i].skillName, isMine),
                            if (isMine)
                              Container(
                                margin: EdgeInsets.only(bottom: 10, right: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      child: Text(
                                        "Add Skill",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      onTap: () => {_addSkillModal(context)},
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Material(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            "Social",
                            style: TextStyle(color: Colors.black),
                          ),
                          children: <Widget>[
                            (profile.socialMedia.facebook == null &&
                                    profile.socialMedia.twitter == null &&
                                    profile.socialMedia.instagram == null &&
                                    profile.socialMedia.linkedin == null &&
                                    profile.socialMedia.youtube == null &&
                                    profile.socialMedia.github == null)
                                ? Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                        "There is no Social media information to show."),
                                  )
                                : SocialWidget(profile.socialMedia),
                            if (isMine)
                              Container(
                                margin: EdgeInsets.only(bottom: 10, right: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      child: Text(
                                        "Edit Social",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      onTap: () => {
                                        _addSocialModal(
                                          context,
                                          profile.socialMedia.facebook,
                                          profile.socialMedia.twitter,
                                          profile.socialMedia.instagram,
                                          profile.socialMedia.youtube,
                                          profile.socialMedia.linkedin,
                                          profile.socialMedia.github,
                                        )
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Material(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            "Education",
                            style: TextStyle(color: Colors.black),
                          ),
                          children: <Widget>[
                            if (profile.education.length == 0)
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(
                                    "There is no Education information to show."),
                              )
                            else
                              for (int i = 0; i < profile.education.length; i++)
                                EducationWidget(
                                    profile.education[i].sId,
                                    profile.education[i].schoolName,
                                    profile.education[i].from,
                                    profile.education[i].to,
                                    profile.education[i].current,
                                    profile.education[i].degree,
                                    profile.education[i].fieldOfStudy,
                                    profile.education[i].description,
                                    isMine),
                            if (isMine)
                              Container(
                                margin: EdgeInsets.only(bottom: 10, right: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      child: Text(
                                        "Add Education",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      onTap: () =>
                                          {_addEducationModal(context)},
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Material(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            "Experience",
                            style: TextStyle(color: Colors.black),
                          ),
                          children: <Widget>[
                            if (profile.experience.length == 0)
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(
                                    "There is no Experience information to show."),
                              )
                            else
                              for (int i = 0;
                                  i < profile.experience.length;
                                  i++)
                                ExperienceWidget(
                                  profile.experience[i].sId,
                                  profile.experience[i].companyName,
                                  profile.experience[i].from,
                                  profile.experience[i].to,
                                  profile.experience[i].current,
                                  profile.experience[i].title,
                                  profile.experience[i].location,
                                  profile.experience[i].description,
                                  isMine,
                                ),
                            if (isMine)
                              Container(
                                margin: EdgeInsets.only(bottom: 10, right: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      child: Text(
                                        "Add Experience",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      onTap: () =>
                                          {_addExperienceModal(context)},
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Material(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            "Repositories",
                            style: TextStyle(color: Colors.black),
                          ),
                          children: <Widget>[
                            if (profile.repository.length == 0)
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(
                                    "There is no Repository information to show."),
                              )
                            else
                              for (int i = 0;
                                  i < profile.repository.length;
                                  i++)
                                RepositoryWidget(
                                  profile.repository[i].sId,
                                  profile.repository[i].title,
                                  profile.repository[i].description,
                                  profile.repository[i].url,
                                  isMine,
                                ),
                            if (isMine)
                              Container(
                                margin: EdgeInsets.only(bottom: 10, right: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      child: Text(
                                        "Add Repository",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      onTap: () =>
                                          {_addRepositoryModal(context)},
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (isMine)
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            logoutRequest(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Logout",
                              textAlign: TextAlign.right,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
