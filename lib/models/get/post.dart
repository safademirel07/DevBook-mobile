class Post {
  String profileName;
  String profileImage;
  String sId;
  String text;
  String profile;
  String date;
  bool isMine;
  bool isLiked;
  bool isDisliked;
  int like;
  int commentLength;
  List<Comment> comments;
  int readers;

  Post(
      {this.profileName,
      this.profileImage,
      this.sId,
      this.text,
      this.profile,
      this.date,
      this.isMine,
      this.isLiked,
      this.isDisliked,
      this.like,
      this.commentLength,
      this.comments,
      this.readers});

  Post.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'];
    profileImage = json['profileImage'];
    sId = json['_id'];
    text = json['text'];
    profile = json['profile'];
    date = json['date'];
    isMine = json['isMine'];
    isLiked = json['isLiked'];
    isDisliked = json['isDisliked'];
    like = json['like'];
    commentLength = json['commentLength'];
    if (json['comments'] != null) {
      comments = new List<Comment>();
      json['comments'].forEach((v) {
        comments.add(new Comment.fromJson(v));
      });
    }
    readers = json['readers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileName'] = this.profileName;
    data['profileImage'] = this.profileImage;
    data['_id'] = this.sId;
    data['text'] = this.text;
    data['profile'] = this.profile;
    data['date'] = this.date;
    data['isMine'] = this.isMine;
    data['isLiked'] = this.isLiked;
    data['isDisliked'] = this.isDisliked;
    data['like'] = this.like;
    data['readers'] = this.readers;
    data['commentLength'] = this.commentLength;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comment {
  String profileName;
  String profileImage;
  bool isMine;
  String sId;
  String text;
  String post;
  String profile;
  String date;
  int iV;

  Comment(
      {this.profileName,
      this.profileImage,
      this.isMine,
      this.sId,
      this.text,
      this.post,
      this.profile,
      this.date,
      this.iV});

  Comment.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'];
    profileImage = json['profileImage'];
    isMine = json['isMine'];
    sId = json['_id'];
    text = json['text'];
    post = json['post'];
    profile = json['profile'];
    date = json['date'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileName'] = this.profileName;
    data['profileImage'] = this.profileImage;
    data['isMine'] = this.isMine;
    data['_id'] = this.sId;
    data['text'] = this.text;
    data['post'] = this.post;
    data['profile'] = this.profile;
    data['date'] = this.date;
    data['__v'] = this.iV;
    return data;
  }
}
