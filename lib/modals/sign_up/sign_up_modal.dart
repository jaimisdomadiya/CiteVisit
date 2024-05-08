class SignUpModal {
  String? id;
  String? token;

  SignUpModal({this.id, this.token});

  SignUpModal.fromJson(dynamic json) {
    id = json['id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['token'] = token;
    return map;
  }
}
