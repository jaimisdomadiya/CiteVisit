class AddMemberWithSiteRequest {
  String? projectId;
  List<String>? members;
  List<String>? siteId;
  String? type;

  AddMemberWithSiteRequest(
      {this.projectId, this.members, this.siteId, this.type});

  AddMemberWithSiteRequest.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    members = json['members'].cast<String>();
    siteId = json['site_id'].cast<String>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['project_id'] = projectId;
    data['members'] = members;
    data['site_id'] = siteId;
    data['type'] = type;
    return data;
  }
}