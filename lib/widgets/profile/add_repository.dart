import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/models/get/profile.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddRepository extends StatefulWidget {
  @override
  AddRepositoryState createState() => AddRepositoryState();
}

class AddRepositoryState extends State<AddRepository> {
  TextEditingController titleController;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  bool _isCurrent = false;

  void submitForm() async {
    if (_fbKey.currentState.saveAndValidate()) {
      var repositoryForm = Repository();

      repositoryForm.title = _fbKey.currentState.value['title'];
      repositoryForm.description = _fbKey.currentState.value['description'];
      repositoryForm.url = _fbKey.currentState.value['url'];

      Provider.of<ProfileProvider>(context, listen: false)
          .addRepositoryRequest(repositoryForm);
      Navigator.pop(context);
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilderTextField(
                    attribute: "title",
                    decoration: InputDecoration(labelText: "Title (*)"),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(Constants.minLengthShort),
                      FormBuilderValidators.maxLength(
                          Constants.maxLengthMiddle),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilderTextField(
                    attribute: "description",
                    decoration: InputDecoration(labelText: "Description (*)"),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.maxLength(Constants.maxLengthLong),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilderTextField(
                    attribute: "url",
                    decoration: InputDecoration(labelText: "URL (*)"),
                    validators: [
                      FormBuilderValidators.required(),
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
                    child: Text('Add Repository'),
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
