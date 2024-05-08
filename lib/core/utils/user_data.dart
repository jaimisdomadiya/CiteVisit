import 'package:cityvisit/modals/request/site_details/add_site_request.dart';
import 'package:flutter/cupertino.dart';

class UserData {
  static final UserData _userData = UserData._init();

  factory UserData() {
    return _userData;
  }

  UserData._init();

  ValueNotifier<String> userName = ValueNotifier('');
  ValueNotifier<String> email = ValueNotifier('');
  ValueNotifier<String> profileImage = ValueNotifier('');
  ValueNotifier<String> projectCount = ValueNotifier('0');
  ValueNotifier<String> siteCount = ValueNotifier('0');
  ValueNotifier<String> memberCount = ValueNotifier('0');
  ImageData? _imageData;

  set imageData(ImageData value) => _imageData = value;

  ImageData get imageData => _imageData ?? ImageData();
}
