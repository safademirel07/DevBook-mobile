import 'package:devbook_new/models/get/profile.dart';

class Event {
  String sId;
  String profileName;
  String profileImage;
  String title;
  String description;
  String location;
  String date;
  String profile;
  List<Participants> participants;
  List<Maybes> maybes;
  int iV;
  bool isMine;
  bool isMaybe;
  bool isParticipant;
  int maybeCount;
  int participantCount;

  String latitude;
  String longitude;

  Profile owner;

  Event({
    this.profileName,
    this.profileImage,
    this.sId,
    this.title,
    this.description,
    this.location,
    this.date,
    this.profile,
    this.participants,
    this.maybes,
    this.iV,
    this.isMine,
    this.isMaybe,
    this.isParticipant,
    this.maybeCount,
    this.participantCount,
    this.latitude,
    this.longitude,
  });

  Event.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'];
    profileImage = json['profileImage'];
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    location = json['location'];
    date = json['date'];
    profile = json['profile'];
    if (json['participants'] != null) {
      participants = new List<Participants>();
      json['participants'].forEach((v) {
        participants.add(new Participants.fromJson(v));
      });
    }
    if (json['maybes'] != null) {
      maybes = new List<Maybes>();
      json['maybes'].forEach((v) {
        maybes.add(new Maybes.fromJson(v));
      });
    }
    iV = json['__v'];
    isMine = json['isMine'];
    isMaybe = json['isMaybe'];
    isParticipant = json['isParticipant'];
    maybeCount = json['maybeCount'];
    participantCount = json['participantCount'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    owner = json['owner'] != null ? new Profile.fromJson(json['owner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileName'] = this.profileName;
    data['profileImage'] = this.profileImage;
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['location'] = this.location;
    data['date'] = this.date;
    data['profile'] = this.profile;
    if (this.participants != null) {
      data['participants'] = this.participants.map((v) => v.toJson()).toList();
    }
    if (this.maybes != null) {
      data['maybes'] = this.maybes.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    data['isMine'] = this.isMine;
    data['isMaybe'] = this.isMaybe;
    data['isParticipant'] = this.isParticipant;
    data['maybeCount'] = this.maybeCount;
    data['participantCount'] = this.participantCount;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Participants {
  String profileID;
  String profileName;
  String profileJob;
  String profileImage;

  Participants(
      {this.profileID, this.profileName, this.profileJob, this.profileImage});

  Participants.fromJson(Map<String, dynamic> json) {
    profileID = json['profileID'];
    profileName = json['profileName'];
    profileJob = json['profileJob'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileID'] = this.profileID;
    data['profileName'] = this.profileName;
    data['profileJob'] = this.profileJob;
    data['profileImage'] = this.profileImage;
    return data;
  }
}

class Maybes {
  String profileID;
  String profileName;
  String profileJob;
  String profileImage;

  Maybes(
      {this.profileID, this.profileName, this.profileJob, this.profileImage});

  Maybes.fromJson(Map<String, dynamic> json) {
    profileID = json['profileID'];
    profileName = json['profileName'];
    profileJob = json['profileJob'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileID'] = this.profileID;
    data['profileName'] = this.profileName;
    data['profileJob'] = this.profileJob;
    data['profileImage'] = this.profileImage;
    return data;
  }
}
