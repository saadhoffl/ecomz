// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import '../auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    _isLoggedIn = await AuthService.isLoggedIn();
    notifyListeners();
  }

  Future<String?> signin(String email, String password) async {
    final result = await AuthService.signin(email, password);
    await checkLoginStatus();
    return result;
  }

  Future<String?> signup(String email, String password) async {
    final result = await AuthService.signup(email, password);
    return result; // null if success, string error if fail
  }

  Future<void> logout() async {
    await AuthService.logout();
    await checkLoginStatus();
  }
}
