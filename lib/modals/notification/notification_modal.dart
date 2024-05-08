class NotificationModal {
  NotificationModal({
    this.title,
    this.body,
    this.userId,
    this.userType,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.id,
  });

  NotificationModal.fromJson(dynamic json) {
    title = json['title'];
    body = json['body'];
    userId = json['user_id'];
    userType = json['user_type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
    id = json['id'];
  }

  String? title;
  String? body;
  String? userId;
  int? userType;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['body'] = body;
    map['user_id'] = userId;
    map['user_type'] = userType;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    map['id'] = id;
    return map;
  }
}
