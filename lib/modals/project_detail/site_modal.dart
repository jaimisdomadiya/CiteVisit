class SiteModal {
  SiteModal({
    this.siteData,
    this.totalPages,
    this.totalSites,
    this.totalEmployees,
  });

  SiteModal.fromJson(dynamic json) {
    if (json['site_data'] != null) {
      siteData = [];
      json['site_data'].forEach((v) {
        siteData?.add(SiteData.fromJson(v));
      });
    }
    totalPages = json['total_pages'];
    totalSites = json['total_sites'];
    totalEmployees = json['total_employees'];
  }
  List<SiteData>? siteData;
  int? totalPages;
  int? totalSites;
  int? totalEmployees;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (siteData != null) {
      map['site_data'] = siteData?.map((v) => v.toJson()).toList();
    }
    map['total_pages'] = totalPages;
    map['total_sites'] = totalSites;
    map['total_employees'] = totalEmployees;
    return map;
  }
}

class SiteData {
  SiteData({
    this.siteName,
    this.siteImage,
    this.siteAddress,
    this.id,
    this.imageCount,
    this.noOfAreas,
  });

  SiteData.fromJson(dynamic json) {
    siteName = json['site_name'];
    siteImage = json['site_image'];
    siteAddress = json['site_address'];
    id = json['id'];
    imageCount = json['image_count'];
    noOfAreas = json['no_of_areas'];
  }
  String? siteName;
  String? siteImage;
  String? siteAddress;
  String? id;
  int? imageCount;
  int? noOfAreas;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['site_name'] = siteName;
    map['site_image'] = siteImage;
    map['site_address'] = siteAddress;
    map['id'] = id;
    map['image_count'] = imageCount;
    map['no_of_areas'] = noOfAreas;
    return map;
  }
}
