import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
