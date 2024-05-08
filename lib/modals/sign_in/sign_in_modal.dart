import 'dart:convert';

SignInModal signUpModalFromJson(String str) =>
    SignInModal.fromJson(json.decode(str));

String signUpModalToJson(SignInModal data) => json.encode(data.toJson());

class SignInModal {
  SignInModal({
    this.bussinessName,
    this.managerName,
    this.email,
    this.countryCode,
    this.phoneno,
    this.token,
    this.id,
  });

  SignInModal.fromJson(dynamic json) {
    id = json['id'];
    bussinessName = json['bussiness_name'];
    managerName = json['manager_name'];
    email = json['email'];
    countryCode = json['country_code'];
    phoneno = json['phoneno'];
    token = json['token'];
  }

  String? bussinessName;
  String? managerName;
  String? email;
  int? countryCode;
  int? phoneno;
  String? token;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bussiness_name'] = bussinessName;
    map['manager_name'] = managerName;
    map['email'] = email;
    map['country_code'] = countryCode;
    map['phoneno'] = phoneno;
    map['token'] = token;
    map['id'] = id;
    return map;
  }
}
