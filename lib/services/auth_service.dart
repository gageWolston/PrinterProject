import 'package:hive/hive.dart';

class AuthService {
  final Box usersBox = Hive.box('users');

  static const _loggedInKey = '_loggedInUser';
  static const _adminUser = 'Admin';
  static const _adminPassword = '1234';

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
