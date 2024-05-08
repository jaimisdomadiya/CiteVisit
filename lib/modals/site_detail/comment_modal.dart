import 'package:get/get.dart';

class CommentModal {
  CommentModal({
    this.id,
    this.profilePic,
    this.name,
    this.dateTime,
    this.comment,
    this.subComments,
    required this.isShowReply,
  });

  CommentModal.fromJson(dynamic json) {
    id = json['_id'];
    profilePic = json['profilePic'];
    name = json['name'];
    dateTime = json['dateTime'];
    comment = json['comment'];
    if (json['subcomments'] != null) {
      subComments = [];
      json['subcomments'].forEach((v) {
        subComments?.add(Subcomments.fromJson(v));
      });
    }
  }

  String? id;
  String? profilePic;
  String? name;
  String? dateTime;
  String? comment;
  RxBool isShowReply = false.obs;
  List<Subcomments>? subComments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['profilePic'] = profilePic;
    map['name'] = name;
    map['dateTime'] = dateTime;
    map['comment'] = comment;
    if (subComments != null) {
      map['subcomments'] = subComments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Subcomments {
  Subcomments({
    this.profilePic,
    this.name,
    this.dateTime,
    this.comment,
    this.id,
  });

  Subcomments.fromJson(dynamic json) {
    profilePic = json['profilePic'];
    name = json['name'];
    dateTime = json['dateTime'];
    comment = json['comment'];
    id = json['id'];
  }

  String? profilePic;
  String? name;
  String? dateTime;
  String? comment;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profilePic'] = profilePic;
    map['name'] = name;
    map['dateTime'] = dateTime;
    map['comment'] = comment;
    map['id'] = id;
    return map;
  }
}
