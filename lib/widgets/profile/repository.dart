import 'package:devbook_new/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RepositoryWidget extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String url;
  final bool owner;

  RepositoryWidget(this.id, this.title, this.description, this.url, this.owner);

  @override
  Widget build(BuildContext context) {
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
                        this.title,
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
                                          .removeRepositoryRequest(this.id)
                                    },
                                  ),
                                ),
                              ),
                            )
                          : Spacer(),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            children: <TextSpan>[
                              new TextSpan(
                                text: "Description: ",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              new TextSpan(
                                text: this.description,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "URL: ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        child: Text(
                          this.url,
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () => launch(this.url),
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
