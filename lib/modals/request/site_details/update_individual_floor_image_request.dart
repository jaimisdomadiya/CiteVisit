import 'package:cityvisit/modals/request/site_details/individual_floor_image_request.dart';

class UpdateIndividualFloorImageRequest {
  String? siteId;
  String? areaName;
  String? floorName;
  String? img;
  String? updateImg;
  List<Coordinate>? coordinate;

  UpdateIndividualFloorImageRequest(
      {this.siteId,
      this.areaName,
      this.floorName,
      this.img,
      this.coordinate,
      this.updateImg});

  UpdateIndividualFloorImageRequest.fromJson(dynamic json) {
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
    updateImg = json['update_img'];
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
    map['update_img'] = updateImg;
    return map;
  }
}
