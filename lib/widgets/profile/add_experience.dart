import 'package:devbook_new/data/constants.dart';
import 'package:devbook_new/models/get/profile.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddExperience extends StatefulWidget {
  @override
  AddExperienceState createState() => AddExperienceState();
}

class AddExperienceState extends State<AddExperience> {
  TextEditingController titleController;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  bool _isCurrent = false;

  void submitForm() async {
    if (_fbKey.currentState.saveAndValidate()) {
      var experienceForm = Experience();

      experienceForm.companyName = _fbKey.currentState.value['companyName'];
      experienceForm.title = _fbKey.currentState.value['title'];
      experienceForm.location = _fbKey.currentState.value['location'];
      experienceForm.from = _fbKey.currentState.value['from'].toString();

      if (!_isCurrent &&
          _fbKey.currentState.value['to'] != null &&
          _fbKey.currentState.value['to'].toString().length > 0)
        experienceForm.to = _fbKey.currentState.value['to'].toString();

      experienceForm.description = _fbKey.currentState.value['description'];
      experienceForm.current = _isCurrent;

      Provider.of<ProfileProvider>(context, listen: false)
          .addExperienceRequest(experienceForm);
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
                    attribute: "companyName",
                    decoration: InputDecoration(labelText: "Company Name (*)"),
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
                    attribute: "location",
                    decoration: InputDecoration(labelText: "Location (*)"),
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
                    initialValue: _isCurrent,
                    attribute: 'current',
                    label: Text("Is this your current job?"),
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
                    child: Text('Add Experience'),
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
