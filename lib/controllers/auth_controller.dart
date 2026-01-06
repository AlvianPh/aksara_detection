import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthController {
  final String baseUrl = "http://10.0.2.2:5000/api";
// ="http://10.0.0.2.5000/api"
  // ==========================
  // LOGIN
  // ==========================
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  // ==========================
  // REGISTER
  // ==========================
  Future<Map<String, dynamic>> register({
    required String name,
    required String username,
    required String password,
    required String confirmPassword,
    File? foto,
  }) async {
    final url = Uri.parse("$baseUrl/register");
    final request = http.MultipartRequest("POST", url);

    request.fields["name"] = name;
    request.fields["username"] = username;
    request.fields["password"] = password;
    request.fields["confirmPassword"] = confirmPassword;

    if (foto != null) {
      request.files.add(
        await http.MultipartFile.fromPath("foto", foto.path),
      );
    }

    final result = await request.send();
    final response = await http.Response.fromStream(result);
    return jsonDecode(response.body);
  }
}
