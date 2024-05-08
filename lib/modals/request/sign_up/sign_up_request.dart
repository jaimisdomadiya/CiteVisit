class SignUpRequest {
  SignUpRequest({
    this.businessName,
    this.managerName,
    this.email,
    this.phone,
    this.password,
    this.type,
    this.socialId,
    this.tag,
    this.otp,
    this.deviceToken
  });

  SignUpRequest.fromJson(dynamic json) {
    businessName = json['bussiness_name'];
    managerName = json['manager_name'];
    email = json['email'];
    phone = json['phone_no'];
    password = json['password'];
    type = json['type'];
    socialId = json['social_id'];
    tag = json['tag'];
    otp = json['otp'];
    deviceToken = json['device_token'];
  }

  String? businessName;
  String? managerName;
  String? email;
  String? phone;
  String? password;
  String? type;
  String? socialId;
  String? tag;
  String? otp;
  String? deviceToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bussiness_name'] = businessName;
    map['manager_name'] = managerName;
    map['email'] = email;
    map['phone_no'] = phone;
    map['password'] = password;
    map['type'] = type;
    map['social_id'] = socialId;
    map['tag'] = tag;
    map['otp'] = otp;
    map['device_token'] = deviceToken;
    return map;
  }
}
