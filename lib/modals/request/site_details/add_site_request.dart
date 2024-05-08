class AddSiteRequest {
  String? siteName;
  String? siteAddress;
  String? siteImage;
  List<String>? members;
  List<String>? areas;
  String? projectId;
  String? businessId;
  List<FloorPlan>? floorPlan;
  String? type;

  AddSiteRequest(
      {this.siteName,
      this.siteAddress,
      this.siteImage,
      this.members,
      this.areas,
      this.type,
      this.projectId,
      this.businessId,
      this.floorPlan});

  AddSiteRequest.fromJson(dynamic json) {
    if (json['floor_plan'] != null) {
      floorPlan = [];
      json['floor_plan'].forEach((v) {
        floorPlan?.add(FloorPlan.fromJson(v));
      });
    }
    siteName = json['site_name'];
    siteAddress = json['site_address'];
    siteImage = json['site_image'];
    projectId = json['project_id'];
    businessId = json['bussinessuser_id'];
    businessId = json['type'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (floorPlan != null) {
      map['floor_plan'] = floorPlan?.map((v) => v.toJson()).toList();
    }
    map['site_name'] = siteName;
    map['site_address'] = siteAddress;
    map['site_image'] = siteImage;
    map['project_id'] = projectId;
    map['bussinessuser_id'] = businessId;
    map['members'] = members;
    map['areas'] = areas;
    map['type'] = type;
    return map;
  }
}

class FloorPlan {
  String? areaName;
  List<FloorData>? floorData;

  FloorPlan({this.areaName, this.floorData});

  FloorPlan.fromJson(dynamic json) {
    if (json['floor_data'] != null) {
      floorData = [];
      json['floor_data'].forEach((v) {
        floorData?.add(FloorData.fromJson(v));
      });
    }
    areaName = json['area_name'];
  }

  FloorPlan copyWith({
    String? areaName,
    List<FloorData>? floorData,
  }) {
    return FloorPlan(
      areaName: areaName,
      floorData: floorData,
    );
  }

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
  String? floorName;
  List<ImageData>? imageData;

  FloorData({this.floorName, this.imageData});

  FloorData.fromJson(dynamic json) {
    if (json['image_data'] != null) {
      imageData = [];
      json['image_data'].forEach((v) {
        imageData?.add(ImageData.fromJson(v));
      });
    }
    floorName = json['floor_name'];
  }

  FloorData copyWith({
    String? floorName,
    List<ImageData>? imageData,
  }) {
    return FloorData(
      floorName: floorName,
      imageData: imageData,
    );
  }

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
  String? img;
  List<Coordinate>? coordinate;

  ImageData({this.img, this.coordinate});

  ImageData.fromJson(dynamic json) {
    if (json['coordinates'] != null) {
      coordinate = [];
      json['coordinates'].forEach((v) {
        coordinate?.add(Coordinate.fromJson(v));
      });
    }
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (coordinate != null) {
      map['coordinates'] = coordinate?.map((v) => v.toJson()).toList();
    }
    map['img'] = img;

    return map;
  }
}

class Coordinate {
  String? x;
  String? y;
  String? msg;

  Coordinate({this.x, this.y, this.msg});

  Coordinate.fromJson(dynamic json) {
    x = json['x'];
    y = json['y'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['x'] = x;
    map['y'] = y;
    map['msg'] = msg;
    return map;
  }
}
