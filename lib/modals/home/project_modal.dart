class ProjectModal {
  ProjectModal({
    this.projectName,
    this.projectImage,
    this.sites,
    this.id,
  });

  ProjectModal.fromJson(dynamic json) {
    projectName = json['project_name'];
    projectImage = json['project_image'];
    sites = json['sites'];
    id = json['id'];
  }

  String? projectName;
  String? projectImage;
  int? sites;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['project_name'] = projectName;
    map['project_image'] = projectImage;
    map['sites'] = sites;
    map['id'] = id;
    return map;
  }
}
