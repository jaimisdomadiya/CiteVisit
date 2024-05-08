class EmployeeModal {
  EmployeeModal({
    this.employeeData,
    this.totalPages,
    this.totalEmployees,
  });

  EmployeeModal.fromJson(dynamic json) {
    if (json['employee_data'] != null) {
      employeeData = [];
      json['employee_data'].forEach((v) {
        employeeData?.add(EmployeeData.fromJson(v));
      });
    }
    totalPages = json['total_pages'];
    totalEmployees = json['total_employees'];
  }
  List<EmployeeData>? employeeData;
  int? totalPages;
  int? totalEmployees;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (employeeData != null) {
      map['employee_data'] = employeeData?.map((v) => v.toJson()).toList();
    }
    map['total_pages'] = totalPages;
    map['total_employees'] = totalEmployees;
    return map;
  }
}

class EmployeeData {
  EmployeeData({
    this.name,
    this.email,
    this.profilePic,
    this.phoneNo,
    this.id,
    this.siteIds,
    this.accessLevel,
    this.employeeRole,
  });

  EmployeeData.fromJson(dynamic json) {
    name = json['name'];
    email = json['email'];
    profilePic = json['profile_pic'];
    phoneNo = json['phone_no'];
    id = json['id'];
    siteIds = json['site_ids'].cast<String>();
    accessLevel = json['access_level'];
    employeeRole = json['employee_role'];
  }
  String? name;
  String? email;
  String? profilePic;
  String? employeeRole;
  int? phoneNo;
  String? id;
  List<String>? siteIds;
  String? accessLevel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['email'] = email;
    map['profile_pic'] = profilePic;
    map['phone_no'] = phoneNo;
    map['id'] = id;
    map['employee_role'] = employeeRole;
    if (siteIds != null) {
      map['site_ids'] = siteIds;
    }
    map['access_level'] = accessLevel;
    return map;
  }
}
