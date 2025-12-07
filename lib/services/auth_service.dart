import 'package:hive/hive.dart';

class AuthService {
  final Box usersBox = Hive.box('users');

  static const _loggedInKey = '_loggedInUser';

  bool registerUser(String username, String password) {
    if (usersBox.containsKey(username)) return false;
    usersBox.put(username, password);
    return true;
  }

  bool login(String username, String password) {
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
}
