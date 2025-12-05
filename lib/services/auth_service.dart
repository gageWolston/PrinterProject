import 'package:hive/hive.dart';

class AuthService {
  final Box usersBox = Hive.box('users');

  String? loggedInUser;

  bool registerUser(String username, String password) {
    if (usersBox.containsKey(username)) return false;
    usersBox.put(username, password);
    return true;
  }

  bool login(String username, String password) {
    if (!usersBox.containsKey(username)) return false;
    if (usersBox.get(username) != password) return false;
    loggedInUser = username;
    return true;
  }

  bool isLoggedIn() {
    return loggedInUser != null;
  }

  void logout() {
    loggedInUser = null;
  }
}
