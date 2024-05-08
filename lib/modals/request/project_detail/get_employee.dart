class GetEmployee {
  String? search;
  String? page;
  String? projectId;

  GetEmployee({this.search, this.page, this.projectId});

  GetEmployee.fromJson(dynamic json) {
    search = json['search'];
    page = json['page'];
    projectId = json['project_id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['search'] = search;
    map['page'] = page;
    map['project_id'] = projectId;
    return map;
  }
}
