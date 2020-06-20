import 'package:devbook_new/models/get/profile.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditSocial extends StatefulWidget {
  final String facebook;
  final String twitter;
  final String instagram;
  final String youtube;
  final String linkedin;
  final String github;

  EditSocial(
    this.facebook,
    this.twitter,
    this.instagram,
    this.youtube,
    this.linkedin,
    this.github,
  );

  @override
  EditSocialState createState() => EditSocialState();
}

class EditSocialState extends State<EditSocial> {
  TextEditingController titleController;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  bool _isCurrent = false;

  void submitForm() async {
    if (_fbKey.currentState.saveAndValidate()) {
      SocialMedia social = new SocialMedia();
      social.facebook = _fbKey.currentState.value['facebook'] != null
          ? _fbKey.currentState.value['facebook']
          : "";
      social.instagram = _fbKey.currentState.value['instagram'] != null
          ? _fbKey.currentState.value['instagram']
          : "";
      social.twitter = _fbKey.currentState.value['twitter'] != null
          ? _fbKey.currentState.value['twitter']
          : "";
      social.linkedin = _fbKey.currentState.value['linkedin'] != null
          ? _fbKey.currentState.value['linkedin']
          : "";
      social.youtube = _fbKey.currentState.value['youtube'] != null
          ? _fbKey.currentState.value['youtube']
          : "";

      social.github = _fbKey.currentState.value['github'] != null
          ? _fbKey.currentState.value['github']
          : "";

      Provider.of<ProfileProvider>(context, listen: false)
          .postSocialRequest(social);
      Navigator.pop(context);
    }
  }

  // var facebookReg = new RegExp(
  //  r"^(?:https?:\/\/)?(?:www\.)?(mbasic.facebook|m\.facebook|facebook|fb)\.(com|me)\/(?:(?:\w\.)*#!\/)?(?:pages\/)?(?:[\w\-\.]*\/)*([\w\-\.]*)$");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: FormBuilder(
            key: _fbKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilderTextField(
                    attribute: "facebook",
                    initialValue:
                        (widget.facebook != null && widget.facebook.length > 0)
                            ? widget.facebook
                            : "",
                    decoration: InputDecoration(labelText: "Facebook profile"),
                    validators: [
                      FormBuilderValidators.url(
                          protocols: ["http", "https"], requireProtocol: true),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilderTextField(
                    attribute: "twitter",
                    initialValue:
                        (widget.twitter != null && widget.twitter.length > 0)
                            ? widget.twitter
                            : "",
                    decoration: InputDecoration(labelText: "Twitter profile"),
                    validators: [
                      FormBuilderValidators.url(
                          protocols: ["http", "https"], requireProtocol: true),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilderTextField(
                    attribute: "instagram",
                    initialValue: (widget.instagram != null &&
                            widget.instagram.length > 0)
                        ? widget.instagram
                        : "",
                    decoration: InputDecoration(labelText: "Instagram profile"),
                    validators: [
                      FormBuilderValidators.url(
                          protocols: ["http", "https"], requireProtocol: true),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilderTextField(
                    attribute: "youtube",
                    initialValue:
                        (widget.youtube != null && widget.youtube.length > 0)
                            ? widget.youtube
                            : "",
                    decoration: InputDecoration(labelText: "Youtube channel"),
                    validators: [
                      FormBuilderValidators.url(
                          protocols: ["http", "https"], requireProtocol: true),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilderTextField(
                    attribute: "linkedin",
                    initialValue:
                        (widget.linkedin != null && widget.linkedin.length > 0)
                            ? widget.linkedin
                            : "",
                    decoration: InputDecoration(labelText: "Linkedin profile"),
                    validators: [
                      FormBuilderValidators.url(
                          protocols: ["http", "https"], requireProtocol: true),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilderTextField(
                    attribute: "github",
                    initialValue:
                        (widget.linkedin != null && widget.linkedin.length > 0)
                            ? widget.linkedin
                            : "",
                    decoration: InputDecoration(labelText: "Github profile"),
                    validators: [
                      FormBuilderValidators.url(
                          protocols: ["http", "https"], requireProtocol: true),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10, bottom: 5),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.grey[600], width: 1),
                    ),
                    child: Text('Change'),
                    color: Colors.white,
                    textColor: Colors.black,
                    onPressed: () {
                      submitForm();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
