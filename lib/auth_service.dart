import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://localhost:3000/api/auth"; 
  static const String tokenKey = "auth_token";
  // ⚠️ On real device/emulator: replace `localhost` with your PC IP, e.g. http://192.168.x.x:3000

  // Signup
  static Future<String?> signup(String email, String password) async {
    final url = Uri.parse("$baseUrl/signup");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return null; // success
    } else {
      final data = jsonDecode(response.body);
      return data["message"] ?? "Signup failed";
    }
  }

  // Signin
 static Future<String?> signin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/signin"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data["token"];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(tokenKey, token);
        return null; // success
      } else {
        final error = jsonDecode(response.body);
        return error["message"] ?? "Signin failed";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) != null;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }
}
