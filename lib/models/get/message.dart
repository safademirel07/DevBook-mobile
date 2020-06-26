import 'package:devbook_new/models/get/profile.dart';

class Message {
  String sId;
  String profile;
  String lastMessage;
  String date;
  int iV;
  Profile peerProfile;
  String pairID;

  Message(
      {this.sId,
      this.profile,
      this.peerProfile,
      this.lastMessage,
      this.date,
      this.iV});

  Message.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profile = json['profile'];
    peerProfile = json['peer_profile'] != null
        ? new Profile.fromJson(json['peer_profile'])
        : null;
    lastMessage = json['last_message'];
    date = json['date'];
    pairID = json['pair_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profile'] = this.profile;
    data['peer_profile'] = this.peerProfile.sId;
    data["pair_id"] = this.pairID;
    data['last_message'] = this.lastMessage;
    data['date'] = this.date;
    data['__v'] = this.iV;
    return data;
  }
}
