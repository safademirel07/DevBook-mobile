import 'package:devbook_new/providers/post_list_provider.dart';
import 'package:devbook_new/providers/post_provider.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddComment extends StatefulWidget {
  final String id;

  AddComment(this.id);

  @override
  AddCommentState createState() => AddCommentState();
}

class AddCommentState extends State<AddComment> {
  TextEditingController titleController;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  bool _isCurrent = false;

  void submitForm() async {
    if (_fbKey.currentState.saveAndValidate()) {
      Provider.of<PostProvider>(context, listen: false)
          .addComment(widget.id, _fbKey.currentState.value['comment']);
      Provider.of<PostListProvider>(context, listen: false).setFetchAgain(true);

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
                    attribute: "comment",
                    decoration: InputDecoration(labelText: "Comment:"),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(3),
                      FormBuilderValidators.maxLength(240),
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
                    child: Text('Submit'),
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
