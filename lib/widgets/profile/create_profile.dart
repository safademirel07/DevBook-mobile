import 'dart:convert';
import 'dart:io';

import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/models/get/profile.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:devbook_new/widgets/other/form_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateProfile extends StatefulWidget {
  final String iHandler;
  final String iCompanyName;
  final String iProfilePhoto;
  final String iWebsite;
  final String iLocation;
  final String iBiography;
  final String iGithubUsername;

  const CreateProfile(
    this.iHandler,
    this.iCompanyName,
    this.iProfilePhoto,
    this.iWebsite,
    this.iLocation,
    this.iBiography,
    this.iGithubUsername,
  );

  @override
  CreateProfileState createState() => CreateProfileState();
}

class CreateProfileState extends State<CreateProfile> {
  TextEditingController titleController;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  bool _isCurrent = false;

  void submitForm() async {
    if (_fbKey.currentState.saveAndValidate()) {
      var profileForm = Profile();

      if (_fbKey.currentState.value['handler'] != null &&
          _fbKey.currentState.value['handler'].length > 0) {
        profileForm.handler = _fbKey.currentState.value['handler'];
      }

      if (_fbKey.currentState.value['companyName'] != null &&
          _fbKey.currentState.value['companyName'].length > 0) {
        profileForm.company = _fbKey.currentState.value['companyName'];
      }
      if (_fbKey.currentState.value['profilePhoto'] != null &&
          _fbKey.currentState.value['profilePhoto'].length > 0) {
        profileForm.profilePhoto = _fbKey.currentState.value['profilePhoto'];
      }

      if (_fbKey.currentState.value['website'] != null &&
          _fbKey.currentState.value['website'].length > 0) {
        profileForm.website = _fbKey.currentState.value['website'];
      }

      if (_fbKey.currentState.value['location'] != null &&
          _fbKey.currentState.value['location'].length > 0) {
        profileForm.location = _fbKey.currentState.value['location'];
      }

      if (_fbKey.currentState.value['biography'] != null &&
          _fbKey.currentState.value['biography'].length > 0) {
        profileForm.biography = _fbKey.currentState.value['biography'];
      }

      String base64Image = "";

      if (_fbKey.currentState.value['uploadImage'] != null &&
          _fbKey.currentState.value['uploadImage'].toString().length > 0) {
        var path =
            Map<String, String>.from(_fbKey.currentState.value['uploadImage'])
                .values
                .toList();

        if (path.length > 0) {
          File imageFile = new File(path[0]);
          List<int> imageBytes = await imageFile.readAsBytes();
          base64Image = "data:image/png;base64," + base64Encode(imageBytes);
        }

        /*
      if (_fbKey.currentState.value['githubUsername'] != null &&
          _fbKey.currentState.value['githubUsername'].length > 0) {
        profileForm.githubUsername =
            _fbKey.currentState.value['githubUsername'];
      }
      */

        Provider.of<ProfileProvider>(context, listen: false)
            .profilePostRequest(profileForm, base64Image);
        // Navigator.pop(context);
      }
    }
  }

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
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  margin: EdgeInsets.only(bottom: 5),
                  child: FormBuilderTextField(
                    attribute: "handler",
                    initialValue: widget.iHandler,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Nickname (*)",
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 10),
                      ),
                    ),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(Constants.minLengthShort),
                      FormBuilderValidators.maxLength(Constants.maxLengthShort),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  margin: EdgeInsets.only(bottom: 5),
                  child: FormBuilderFilePicker(
                    attribute: "uploadImage",
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Profile Photo",
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 10),
                      ),
                    ),
                    previewImages: true,
                    onChanged: (val) => print(val),
                    fileType: FileType.image,
                    selector: Row(
                      children: <Widget>[
                        Icon(Icons.file_upload),
                        Text('Select a Profile Photo'),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  margin: EdgeInsets.only(bottom: 5),
                  child: FormBuilderTextField(
                    attribute: "companyName",
                    initialValue: widget.iCompanyName,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Company Name",
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 10),
                      ),
                    ),
                    validators: [
                      FormBuilderValidators.maxLength(
                          Constants.maxLengthMiddle),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  margin: EdgeInsets.only(bottom: 5),
                  child: FormBuilderTextField(
                    attribute: "website",
                    initialValue: widget.iWebsite,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Website",
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 10),
                      ),
                    ),
                    validators: [
                      FormBuilderValidators.url(
                          protocols: ["http", "https"], requireProtocol: true),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  margin: EdgeInsets.only(bottom: 5),
                  child: FormBuilderTextField(
                    attribute: "location",
                    initialValue: widget.iLocation,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Location",
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 10),
                      ),
                    ),
                    validators: [
                      FormBuilderValidators.maxLength(
                          Constants.maxLengthMiddle),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  margin: EdgeInsets.only(bottom: 5),
                  child: FormBuilderTextField(
                    attribute: "biography",
                    initialValue: widget.iBiography,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Biography",
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 10),
                      ),
                    ),
                    validators: [
                      FormBuilderValidators.maxLength(Constants.maxLengthLong),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(right: 10, bottom: 5),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                    child: Text('Create Profile'),
                    color: Colors.black,
                    textColor: Colors.white,
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
