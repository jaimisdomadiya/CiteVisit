part of 'utils.dart';

class Preferences {
  Preferences._();

  static final Preferences _instance = Preferences._();

  static SharedPreferences? _shared;

  final String _isLogged = 'isLogged';
  final String _token = 'token';
  final String _id = 'id';
  final String _businessName = 'businessName';
  final String _managerName = 'managerName';
  final String _email = 'email';
  final String _password = 'password';
  final String _profilePic = 'profilePic';
  final String _isSocialLogin = 'isSocialLogin';
  final String _businessUserId = 'businessUserId';

  static Future<void> init() async {
    _shared = await SharedPreferences.getInstance();
  }

  set isLogged(bool value) => _shared?.setBool(_isLogged, value);

  bool get isLogged => _shared?.getBool(_isLogged) ?? false;

  set id(String value) => _shared?.setString(_id, value);

  String get id => _shared?.getString(_id) ?? '';

  set token(String value) => _shared?.setString(_token, value);

  String get token => _shared?.getString(_token) ?? '';

  set businessName(String value) => _shared?.setString(_businessName, value);

  String get businessName => _shared?.getString(_businessName) ?? '';

  set managerName(String value) => _shared?.setString(_managerName, value);

  String get managerName => _shared?.getString(_managerName) ?? '';

  set email(String value) => _shared?.setString(_email, value);

  String get email => _shared?.getString(_email) ?? '';

  set profilePic(String value) => _shared?.setString(_profilePic, value);

  String get profilePic => _shared?.getString(_profilePic) ?? '';

  set password(String value) => _shared?.setString(_password, value);

  String get password => _shared?.getString(_password) ?? '';

  set isSocialLogin(bool value) => _shared?.setBool(_isSocialLogin, value);

  set businessUserId(String value) =>
      _shared?.setString(_businessUserId, value);

  String get businessUserId => _shared?.getString(_businessUserId) ?? '';

  bool get isSocialLogin => _shared?.getBool(_isSocialLogin) ?? false;

  Future<void> clear() async {
    await _shared?.clear();
  }

  static Preferences get instance => _instance;
}
