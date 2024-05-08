class UpdateProfileRequest {
  UpdateProfileRequest({
    this.businessName,
    this.managerName,
    this.email,
    this.password,
    this.profilePic,
  });

  UpdateProfileRequest.fromJson(dynamic json) {
    businessName = json['bussiness_name'];
    managerName = json['manager_name'];
    email = json['email'];
    password = json['password'];
    profilePic = json['profile_pic'];
  }
  String? businessName;
  String? managerName;
  String? email;
  String? password;
  String? profilePic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bussiness_name'] = businessName;
    map['manager_name'] = managerName;
    map['email'] = email;
    map['password'] = password;
    map['profile_pic'] = profilePic;
    return map;
  }
}
