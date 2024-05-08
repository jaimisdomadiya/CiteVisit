class ProfileModal {
  ProfileModal({
    this.id,
    this.bussinessName,
    this.managerName,
    this.email,
    this.password,
    this.phoneno,
    this.profilePic,
    this.type,
    this.projectCount,
    this.employeeCount,
    this.siteCount,
  });

  ProfileModal.fromJson(dynamic json) {
    id = json['id'];
    bussinessName = json['bussiness_name'];
    managerName = json['manager_name'];
    email = json['email'];
    password = json['password'];
    phoneno = json['phoneno'].toString();
    profilePic = json['profile_pic'].toString();
    type = json['type'].toString();
    projectCount = json['project_count'].toString();
    siteCount = json['Site_count'].toString();
    employeeCount = json['Employee_count'].toString();
  }
  String? id;
  String? bussinessName;
  String? managerName;
  String? email;
  String? password;
  String? phoneno;
  String? profilePic;
  String? type;
  String? projectCount;
  String? siteCount;
  String? employeeCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['bussiness_name'] = bussinessName;
    map['manager_name'] = managerName;
    map['email'] = email;
    map['password'] = password;
    map['phoneno'] = phoneno;
    map['profile_pic'] = profilePic;
    map['type'] = type;
    map['project_count'] = projectCount;
    map['Site_count'] = siteCount;
    map['Employee_count'] = employeeCount;
    return map;
  }
}
