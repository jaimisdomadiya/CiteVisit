class SiteDetailModal {
  SiteDetailModal({
    this.siteName,
    this.siteAddress,
    this.projectName,
    this.siteImage,
    this.membersProfile,
    this.floorPlan,
  });

  SiteDetailModal.fromJson(dynamic json) {
    siteName = json['site_name'];
    siteAddress = json['site_address'];
    projectName = json['project_name'];
    siteImage = json['site_image'];
    if (json['floor_plan'] != null) {
      floorPlan = [];
      json['floor_plan'].forEach((v) {
        floorPlan?.add(FloorPlan.fromJson(v));
      });
    }
    if (json['members_details'] != null) {
      membersProfile = [];
      json['members_details'].forEach((v) {
        membersProfile?.add(MemberModal.fromJson(v));
      });
    }
  }

  String? siteName;
  String? siteAddress;
  String? projectName;
  String? siteImage;
  List<MemberModal>? membersProfile;
  List<FloorPlan>? floorPlan;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['site_name'] = siteName;
    map['site_address'] = siteAddress;
    map['project_name'] = projectName;
    map['site_image'] = siteImage;
    if (floorPlan != null) {
      map['floor_plan'] = floorPlan?.map((v) => v.toJson()).toList();
    }
    if (membersProfile != null) {
      map['members_details'] = membersProfile?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class FloorPlan {
  FloorPlan({
    this.floorData,
    this.areaName,
  });

  FloorPlan.fromJson(dynamic json) {
    if (json['floor_data'] != null) {
      floorData = [];
      json['floor_data'].forEach((v) {
        floorData?.add(FloorData.fromJson(v));
      });
    }
    areaName = json['area_name'];
  }

  List<FloorData>? floorData;
  String? areaName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (floorData != null) {
      map['floor_data'] = floorData?.map((v) => v.toJson()).toList();
    }
    map['area_name'] = areaName;
    return map;
  }
}

class FloorData {
  FloorData({
    this.imageData,
    this.floorName,
  });

  FloorData.fromJson(dynamic json) {
    if (json['image_data'] != null) {
      imageData = [];
      json['image_data'].forEach((v) {
        imageData?.add(ImageData.fromJson(v));
      });
    }
    floorName = json['floor_name'];
  }

  List<ImageData>? imageData;
  String? floorName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (imageData != null) {
      map['image_data'] = imageData?.map((v) => v.toJson()).toList();
    }
    map['floor_name'] = floorName;
    return map;
  }
}

class ImageData {
  ImageData({
    this.coordinates,
    this.img,
  });

  ImageData.fromJson(dynamic json) {
    if (json['coordinates'] != null) {
      coordinates = [];
      json['coordinates'].forEach((v) {
        coordinates?.add(Coordinates.fromJson(v));
      });
    }
    img = json['img'];
  }

  List<Coordinates>? coordinates;
  String? img;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (coordinates != null) {
      map['coordinates'] = coordinates?.map((v) => v.toJson()).toList();
    }
    map['img'] = img;
    return map;
  }
}

class Coordinates {
  Coordinates({
    this.x,
    this.y,
    this.msg,
  });

  Coordinates.fromJson(dynamic json) {
    x = json['x'] != null ? json['x'].toString() : "0";
    y = json['y'] != null ? json['y'].toString() : "0";
    msg = json['msg'];
  }

  String? x;
  String? y;
  String? msg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['x'] = x;
    map['y'] = y;
    map['msg'] = msg;
    return map;
  }
}

class MemberModal {
  MemberModal({
    this.name,
    this.profilePic,
  });

  MemberModal.fromJson(dynamic json) {
    profilePic = json['profile_pic'];
    name = json['name'];
  }

  String? name;
  String? profilePic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['profile_pic'] = profilePic;
    return map;
  }
}
