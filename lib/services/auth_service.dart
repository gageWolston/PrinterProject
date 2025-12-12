import 'package:hive/hive.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  final Box usersBox = Hive.box('users');

  static const _loggedInKey = '_loggedInUser';
  static const _adminUser = 'Admin';
  // Test-only admin account; change or remove before shipping to production
  static const _adminPassword = '1234';

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  bool registerUser(String username, String password) {
    if (username == _adminUser) return false;
    if (usersBox.containsKey(username)) return false;
    usersBox.put(username, password);
    return true;
  }

  bool login(String username, String password) {
    if (username == _adminUser) {
      if (password != _adminPassword) return false;
      usersBox.put(_loggedInKey, username);
      return true;
    }

    if (!usersBox.containsKey(username)) return false;
    if (usersBox.get(username) != password) return false;
    usersBox.put(_loggedInKey, username);
    return true;
  }

  bool isLoggedIn() {
    return usersBox.get(_loggedInKey) != null;
  }

  void logout() {
    usersBox.delete(_loggedInKey);
  }

  String? get loggedInUser => usersBox.get(_loggedInKey) as String?;

  bool get isAdmin => loggedInUser == _adminUser;
}
