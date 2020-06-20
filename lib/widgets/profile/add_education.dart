import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/models/get/profile.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddEducation extends StatefulWidget {
  @override
  AddEducationState createState() => AddEducationState();
}

class AddEducationState extends State<AddEducation> {
  TextEditingController titleController;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  bool _isCurrent = false;

  void submitForm() async {
    if (_fbKey.currentState.saveAndValidate()) {
      var educationForm = Education();

      educationForm.current = _isCurrent;
      educationForm.schoolName = _fbKey.currentState.value['schoolName'];
      educationForm.degree = _fbKey.currentState.value['degree'];
      educationForm.fieldOfStudy = _fbKey.currentState.value['fieldOfStudy'];
      educationForm.from = _fbKey.currentState.value['from'].toString();

      if (!_isCurrent &&
          _fbKey.currentState.value['to'] != null &&
          _fbKey.currentState.value['to'].toString().length > 0)
        educationForm.to = _fbKey.currentState.value['to'].toString();

      educationForm.description = _fbKey.currentState.value['description'];

      Provider.of<ProfileProvider>(context, listen: false)
          .addEducationRequest(educationForm);
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
                    attribute: "schoolName",
                    decoration: InputDecoration(labelText: "School Name (*)"),
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
                    attribute: "degree",
                    decoration: InputDecoration(labelText: "Degree (*)"),
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
                    attribute: "fieldOfStudy",
                    decoration: InputDecoration(labelText: "Field of Name (*)"),
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
                  child: FormBuilderDateTimePicker(
                    initialValue: DateTime.now(),
                    attribute: "from",
                    inputType: InputType.date,
                    format: DateFormat("yyyy-MM-dd"),
                    decoration: InputDecoration(labelText: "From (*)"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilderDateTimePicker(
                    enabled: !_isCurrent,
                    attribute: "to",
                    inputType: InputType.date,
                    format: DateFormat("yyyy-MM-dd"),
                    decoration: InputDecoration(
                        labelText: "To" + (!_isCurrent ? " (*)" : "")),
                    validators: [
                      if (!_isCurrent) FormBuilderValidators.required(),
                      (val) {
                        if (val != null &&
                            val.isBefore(_fbKey.currentState.value['from']))
                          return "To can't be before From";
                      },
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilderCheckbox(
                    onChanged: (value) {
                      setState(() {
                        _isCurrent = value;
                      });
                    },
                    attribute: "current",
                    label: Text("Is this your current education?"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilderTextField(
                    attribute: "description",
                    decoration: InputDecoration(labelText: "Description"),
                    validators: [
                      FormBuilderValidators.maxLength(Constants.maxLengthLong),
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
                    child: Text('Add Education'),
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
