class GetSitesModal {
  String? search;
  String? page;
  String? projectId;
  String? startDate;
  String? endDate;

  GetSitesModal(
      {this.search, this.page, this.projectId, this.startDate, this.endDate});

  GetSitesModal.fromJson(dynamic json) {
    search = json['search'];
    page = json['page'];
    projectId = json['project_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['search'] = search;
    map['page'] = page;
    map['project_id'] = projectId;
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    return map;
  }
}
