import 'package:cityvisit/modals/projects/area_and_employee_modal.dart';

class SiteAndEmployeeRoleModal {
  SiteAndEmployeeRoleModal({
    this.siteName,
    this.employeeRole,
    this.employees,
  });

  SiteAndEmployeeRoleModal.fromJson(dynamic json) {
    if (json['site_name'] != null) {
      siteName = [];
      json['site_name'].forEach((v) {
        siteName?.add(SiteData.fromJson(v));
      });
    }
    employeeRole = json['employee_role'] != null
        ? json['employee_role'].cast<String>()
        : [];
    if (json['employee_data'] != null) {
      employees = [];
      json['employee_data'].forEach((v) {
        employees?.add(Employees.fromJson(v));
      });
    }
  }

  List<SiteData>? siteName;
  List<String>? employeeRole;
  List<Employees>? employees;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (siteName != null) {
      map['site_name'] = siteName?.map((v) => v.toJson()).toList();
    }
    map['employee_role'] = employeeRole;
    map['employee_data'] = employees;
    return map;
  }
}

class SiteData {
  String? siteName;
  String? siteId;

  SiteData({this.siteId, this.siteName});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Site_id'] = siteId;
    map['Site_name'] = siteName;
    return map;
  }

  SiteData.fromJson(dynamic json) {
    siteName = json['Site_name'];
    siteId = json['Site_id'];
  }
}
