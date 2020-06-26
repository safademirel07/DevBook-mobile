class Profile {
  String profilePhoto;
  String company;
  String website;
  String location;
  List<Skills> skills;
  String biography;
  String githubUsername;
  String sId;
  String handler;
  String status;
  String user;
  String createDate;
  List<Education> education;
  List<Experience> experience;
  List<Repository> repository;
  SocialMedia socialMedia;
  String email;
  bool isMe;

  Profile({
    this.profilePhoto,
    this.company,
    this.website,
    this.location,
    this.skills,
    this.biography,
    this.githubUsername,
    this.sId,
    this.handler,
    this.status,
    this.user,
    this.createDate,
    this.education,
    this.experience,
    this.repository,
    this.socialMedia,
    this.email,
    this.isMe,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    profilePhoto = json['profilePhoto'];
    company = json['company'];
    website = json['website'];
    location = json['location'];
    if (json['skills'] != null) {
      skills = new List<Skills>();
      json['skills'].forEach((v) {
        skills.add(new Skills.fromJson(v));
      });
    }
    biography = json['biography'];
    githubUsername = json['githubUsername'];
    sId = json['_id'];
    handler = json['handler'];
    status = json['status'];
    user = json['user'];
    createDate = json['createDate'];
    if (json['education'] != null) {
      education = new List<Education>();
      json['education'].forEach((v) {
        education.add(new Education.fromJson(v));
      });
    }
    if (json['experience'] != null) {
      experience = new List<Experience>();
      json['experience'].forEach((v) {
        experience.add(new Experience.fromJson(v));
      });
    }
    if (json['repository'] != null) {
      repository = new List<Repository>();
      json['repository'].forEach((v) {
        repository.add(new Repository.fromJson(v));
      });
    }
    socialMedia = json['socialMedia'] != null
        ? new SocialMedia.fromJson(json['socialMedia'])
        : null;
    email = json['email'];
    isMe = json["isMe"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profilePhoto'] = this.profilePhoto;
    data['company'] = this.company;
    data['website'] = this.website;
    data['location'] = this.location;
    if (this.skills != null) {
      data['skills'] = this.skills.map((v) => v.toJson()).toList();
    }
    data['biography'] = this.biography;
    data['githubUsername'] = this.githubUsername;
    data['_id'] = this.sId;
    data['handler'] = this.handler;
    data['status'] = this.status;
    data['user'] = this.user;
    data['createDate'] = this.createDate;
    data['email'] = this.email;
    if (this.education != null) {
      data['education'] = this.education.map((v) => v.toJson()).toList();
    }
    if (this.experience != null) {
      data['experience'] = this.experience.map((v) => v.toJson()).toList();
    }
    if (this.repository != null) {
      data['repository'] = this.repository.map((v) => v.toJson()).toList();
    }
    if (this.socialMedia != null) {
      data['socialMedia'] = this.socialMedia.toJson();
    }
    return data;
  }
}

class Skills {
  String sId;
  String skillName;
  String profile;

  Skills({this.sId, this.skillName, this.profile});

  Skills.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    skillName = json['skillName'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['skillName'] = this.skillName;
    data['profile'] = this.profile;
    return data;
  }
}

class Education {
  bool current;
  String sId;
  String schoolName;
  String degree;
  String fieldOfStudy;
  String from;
  String to;
  String description;
  String profile;

  Education(
      {this.current,
      this.sId,
      this.schoolName,
      this.degree,
      this.fieldOfStudy,
      this.from,
      this.to,
      this.description,
      this.profile});

  Education.fromJson(Map<String, dynamic> json) {
    current = json['current'];
    if (current == null) current = false;
    sId = json['_id'];
    schoolName = json['schoolName'];
    degree = json['degree'];
    fieldOfStudy = json['fieldOfStudy'];
    from = json['from'];
    to = json['to'];
    description = json['description'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current'] = this.current;
    data['_id'] = this.sId;
    data['schoolName'] = this.schoolName;
    data['degree'] = this.degree;
    data['fieldOfStudy'] = this.fieldOfStudy;
    data['from'] = this.from;
    data['to'] = this.to;
    data['description'] = this.description;
    data['profile'] = this.profile;
    return data;
  }
}

class Experience {
  bool current;
  String sId;
  String title;
  String companyName;
  String location;
  String from;
  String to;
  String description;
  String profile;

  Experience(
      {this.current,
      this.sId,
      this.title,
      this.companyName,
      this.location,
      this.from,
      this.to,
      this.description,
      this.profile});

  Experience.fromJson(Map<String, dynamic> json) {
    current = json['current'];
    if (current == null) current = false;
    sId = json['_id'];
    title = json['title'];
    companyName = json['companyName'];
    location = json['location'];
    from = json['from'];
    to = json['to'];
    description = json['description'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current'] = this.current;

    data['_id'] = this.sId;
    data['title'] = this.title;
    data['companyName'] = this.companyName;
    data['location'] = this.location;
    data['from'] = this.from;
    data['to'] = this.to;
    data['description'] = this.description;
    data['profile'] = this.profile;
    return data;
  }
}

class Repository {
  String sId;
  String title;
  String description;
  String url;
  String profile;

  Repository({this.sId, this.title, this.description, this.url, this.profile});

  Repository.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    profile = json['profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['profile'] = this.profile;
    return data;
  }
}

class SocialMedia {
  String facebook;
  String twitter;
  String instagram;
  String linkedin;
  String youtube;
  String github;

  SocialMedia(
      {this.facebook,
      this.twitter,
      this.instagram,
      this.linkedin,
      this.youtube,
      this.github});

  SocialMedia.fromJson(Map<String, dynamic> json) {
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    linkedin = json['linkedin'];
    youtube = json['youtube'];
    github = json['github'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['instagram'] = this.instagram;
    data['linkedin'] = this.linkedin;
    data['youtube'] = this.youtube;
    data['github'] = this.github;
    return data;
  }
}
