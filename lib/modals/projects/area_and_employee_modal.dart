class AreaAndEmployeeData {
  AreaAndEmployeeData({
    this.areas,
    this.employees,
    this.employeeRole,
  });

  AreaAndEmployeeData.fromJson(dynamic json) {
    if (json['areas'] != null) {
      areas = [];
      json['areas'].forEach((v) {
        areas?.add(Areas.fromJson(v));
      });
    }
    if (json['Employees'] != null) {
      employees = [];
      json['Employees'].forEach((v) {
        employees?.add(Employees.fromJson(v));
      });
    }
    employeeRole = json['employee_role'] != null
        ? json['employee_role'].cast<String>()
        : [];
  }

  List<Areas>? areas;
  List<Employees>? employees;
  List<String>? employeeRole;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (areas != null) {
      map['areas'] = areas?.map((v) => v.toJson()).toList();
    }
    if (employees != null) {
      map['Employees'] = employees?.map((v) => v.toJson()).toList();
    }
    map['employee_role'] = employeeRole;

    return map;
  }
}

class Employees {
  Employees({
    this.name,
    this.id,
    this.profilePic,
  });

  Employees.fromJson(dynamic json) {
    name = json['name'];
    id = json['id'];
    profilePic = json['profile_pic'];
  }

  String? name;
  String? id;
  String? profilePic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['id'] = id;
    map['profile_pic'] = profilePic;
    return map;
  }
}

class Areas {
  Areas({
    this.areaName,
    this.id,
  });

  Areas.fromJson(dynamic json) {
    areaName = json['area_name'];
    id = json['id'];
  }

  String? areaName;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['area_name'] = areaName;
    map['id'] = id;
    return map;
  }
}
