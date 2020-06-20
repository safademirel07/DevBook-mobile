import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  MainAxisAlignment alignment;

  Logo(this.alignment);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: this.alignment,
      children: <Widget>[
        Icon(
          Icons.code,
          color: Colors.white,
          size: 64,
        ),
        Text(
          "Dev",
          style: TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontStyle: FontStyle.italic,
          ),
        ),
        Text(
          "Book",
          style: TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
