class AddCommentModal {
  AddCommentModal({
    this.floorimg,
    this.userId,
    this.userType,
    this.profilePic,
    this.name,
    this.dateTime,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  AddCommentModal.fromJson(dynamic json) {
    floorimg = json['floorimg'];
    userId = json['userId'];
    userType = json['userType'];
    profilePic = json['profilePic'];
    name = json['name'];
    dateTime = json['dateTime'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  String? floorimg;
  String? userId;
  String? userType;
  String? profilePic;
  String? name;
  String? dateTime;
  String? comment;
  String? createdAt;
  String? updatedAt;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['floorimg'] = floorimg;
    map['userId'] = userId;
    map['userType'] = userType;
    map['profilePic'] = profilePic;
    map['name'] = name;
    map['dateTime'] = dateTime;
    map['comment'] = comment;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['id'] = id;
    return map;
  }
}
