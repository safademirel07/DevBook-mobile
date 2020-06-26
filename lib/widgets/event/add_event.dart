import 'package:devbook_new/models/get/event.dart';
import 'package:devbook_new/providers/event_list_provider.dart';
import 'package:devbook_new/providers/event_provider.dart';
import 'package:devbook_new/providers/post_list_provider.dart';
import 'package:devbook_new/providers/post_provider.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddEvent extends StatefulWidget {
  AddEvent();

  @override
  AddEventState createState() => AddEventState();
}

class AddEventState extends State<AddEvent> {
  TextEditingController titleController;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  LocationResult _pickedLocation;

  bool _isCurrent = false;

  bool notSelected = false;

  void submitForm() async {
    if (_pickedLocation == null) {
      setState(() {
        notSelected = true;
      });
      return;
    }

    if (_fbKey.currentState.saveAndValidate()) {
      var eventForm = Event();

      DateTime date = _fbKey.currentState.value['date'];

      DateTime newDate = date.add(Duration(hours: 3));

      eventForm.title = _fbKey.currentState.value['title'];
      eventForm.description = _fbKey.currentState.value['description'];
      eventForm.location = _pickedLocation.address;
      eventForm.latitude = _pickedLocation.latLng.latitude.toString();
      eventForm.longitude = _pickedLocation.latLng.longitude.toString();
      eventForm.date = newDate.toString();

      Provider.of<EventListProvider>(context, listen: false)
          .addEvent(eventForm);
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
                    decoration: InputDecoration(labelText: "Title (*):"),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(3),
                      FormBuilderValidators.maxLength(1000),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilderTextField(
                    attribute: "description",
                    decoration: InputDecoration(labelText: "Description (*):"),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(3),
                      FormBuilderValidators.maxLength(1000),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FormBuilderDateTimePicker(
                    inputType: InputType.both,
                    initialValue: DateTime.now(),
                    attribute: "date",
                    format: DateFormat("yyyy-MM-dd H:mm"),
                    decoration: InputDecoration(labelText: "Date (*)"),
                    validators: [
                      FormBuilderValidators.required(),
                      (val) {
                        if (val != null && val.isBefore(DateTime.now()))
                          return "Event date-time must bigger than now.";
                      },
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.grey[600], width: 1),
                      ),
                      child: Text('Select a Location'),
                      color: Colors.white,
                      textColor: Colors.black,
                      onPressed: () async {
                        LocationResult result = await showLocationPicker(
                          context,
                          "AIzaSyDiIlquFio6srsmdgIUGyiSE9-vBtJZW6M",
                          initialCenter:
                              LatLng(41.00020601589707, 29.047325514256954),
                          automaticallyAnimateToCurrentLocation: true,
                          myLocationButtonEnabled: true,
                          layersButtonEnabled: true,
                        );
                        setState(() => _pickedLocation = result);
                      },
                    ),
                  ),
                ),
                if (_pickedLocation != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Text(
                        (_pickedLocation != null
                            ? _pickedLocation.address
                            : ""),
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
                else
                  Visibility(
                    visible: notSelected,
                    child: Center(
                      child: Text(
                        "Please select a location",
                        style: TextStyle(color: Colors.red),
                      ),
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
