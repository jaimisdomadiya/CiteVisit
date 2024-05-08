class AddSubCommentRequest {
  String? commentId;
  String? userType;
  String? userId;
  String? profilePic;
  String? dateTime;
  String? comment;
  String? siteId;
  String? projectId;

  AddSubCommentRequest(
      {this.commentId,
      this.userType,
      this.userId,
      this.profilePic,
      this.dateTime,
      this.projectId,
      this.siteId,
      this.comment});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['commentid'] = commentId;
    map['userType'] = userType;
    map['userId'] = userId;
    map['profilePic'] = profilePic;
    map['dateTime'] = dateTime;
    map['comment'] = comment;
    map['project_id'] = projectId;
    map['site_id'] = siteId;
    return map;
  }

  AddSubCommentRequest.fromJson(dynamic json) {
    commentId = json['commentid'];
    userType = json['userType'];
    userId = json['userId'];
    profilePic = json['profilePic'];
    dateTime = json['dateTime'];
    comment = json['comment'];
    siteId = json['site_id'];
    projectId = json['project_id'];
  }
}
