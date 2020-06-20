import 'package:provider/provider.dart';
import 'package:devbook_new/providers/profile_provider.dart';
import 'package:flutter/material.dart';

class ExperienceWidget extends StatelessWidget {
  final String id;

  final String companyName;
  final String from;
  final String to;
  final bool current;
  final String position;
  final String location;
  final String description;
  final bool owner;

  ExperienceWidget(
    this.id,
    this.companyName,
    this.from,
    this.to,
    this.current,
    this.position,
    this.location,
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
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        this.companyName,
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
                                          .removeExperienceRequest(this.id)
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
                        "Position: ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        this.position,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Location: ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        this.location,
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
                        Expanded(
                          child: Text(
                            this.description,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 14),
                          ),
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
