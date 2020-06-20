import 'package:devbook_new/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EducationWidget extends StatelessWidget {
  final String id;
  final String universityName;
  final String from;
  final String to;
  final bool current;
  final String degree;
  final String fieldOfStudy;
  final String description;
  final bool owner;

  EducationWidget(
    this.id,
    this.universityName,
    this.from,
    this.to,
    this.current,
    this.degree,
    this.fieldOfStudy,
    this.description,
    this.owner,
  );

  @override
  Widget build(BuildContext context) {
    String dateFormat = this.from;

    if (current)
      dateFormat += " - Now";
    else
      dateFormat += " - $to";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            color: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 8, bottom: 8, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        this.universityName,
                        style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                      owner
                          ? Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  margin: EdgeInsets.only(right: 3),
                                  child: InkWell(
                                    child: Icon(Icons.delete),
                                    onTap: () => {
                                      Provider.of<ProfileProvider>(context,
                                              listen: false)
                                          .removeEducationRequest(this.id)
                                    },
                                  ),
                                ),
                              ),
                            )
                          : Spacer(),
                    ],
                  ),
                  Text(
                    dateFormat,
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Degree: ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        this.degree,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Field of Study: ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        this.fieldOfStudy,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  if (this.description.length > 0)
                    Row(
                      children: <Widget>[
                        Text(
                          "Description: ",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          this.description,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
