class AddMemberRequest {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? accessLevel;
  String? employeeRole;
  String? type;

  AddMemberRequest(
      {this.lastName,
      this.firstName,
      this.email,
      this.type,
      this.phoneNumber,
      this.employeeRole,
      this.accessLevel});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['phone_no'] = phoneNumber;
    map['access_level'] = accessLevel;
    map['employee_role'] = employeeRole;
    map['type'] = type;

    return map;
  }

  AddMemberRequest.fromJson(dynamic json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_no'];
    accessLevel = json['access_level'];
    employeeRole = json['employee_role'];
    type = json['type'];
  }
}
