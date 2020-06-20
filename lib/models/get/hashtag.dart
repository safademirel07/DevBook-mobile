import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class Hashtag {
  int value;
  String sId;
  String hashtag;
  int iV;
  Color color;
  Hashtag({this.value, this.sId, this.hashtag, this.iV, this.color});

  Hashtag.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    sId = json['_id'];
    hashtag = json['hashtag'];
    iV = json['__v'];
    color = RandomColor().randomColor(colorHue: ColorHue.blue);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['_id'] = this.sId;
    data['hashtag'] = this.hashtag;
    data['__v'] = this.iV;
    data['color'] = this.color;
    return data;
  }
}
