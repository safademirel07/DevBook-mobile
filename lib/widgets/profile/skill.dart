import 'package:devbook_new/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SkillWidget extends StatelessWidget {
  final String id;
  final String title;
  final bool owner;

  SkillWidget(this.id, this.title, this.owner);
  //test
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.check),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      this.title,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Spacer(),
                  if (owner)
                    InkWell(
                        onTap: () {
                          Provider.of<ProfileProvider>(context, listen: false)
                              .removeSkillRequest(this.id);
                        },
                        child: Icon(Icons.delete)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
