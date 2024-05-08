class IndividualFloorImageRequest {
  String? siteId;
  String? areaName;
  String? floorName;
  String? img;
  List<Coordinate>? coordinate;

  IndividualFloorImageRequest(
      {this.siteId, this.areaName, this.floorName, this.img, this.coordinate});

  IndividualFloorImageRequest.fromJson(dynamic json) {
    if (json['coordinates'] != null) {
      coordinate = [];
      json['coordinates'].forEach((v) {
        coordinate?.add(Coordinate.fromJson(v));
      });
    }
    img = json['img'];
    floorName = json['floor_name'];
    areaName = json['area_name'];
    siteId = json['site_id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (coordinate != null) {
      map['coordinates'] = coordinate?.map((v) => v.toJson()).toList();
    }
    map['img'] = img;
    map['floor_name'] = floorName;
    map['area_name'] = areaName;
    map['site_id'] = siteId;
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
