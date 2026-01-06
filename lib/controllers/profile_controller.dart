import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ProfileController {
  final String baseUrl = "http://10.0.2.2:5000/api";

  Future getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/profile"),
        headers: {"Authorization": "Bearer $token"},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future updateProfile(
      String token, String name, String username, File? foto) async {
    try {
      var request = http.MultipartRequest("PUT", Uri.parse("$baseUrl/profile"));
      request.headers["Authorization"] = "Bearer $token";
      request.fields["name"] = name;
      request.fields["username"] = username;

      if (foto != null) {
        request.files.add(await http.MultipartFile.fromPath("foto", foto.path));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody);
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future deleteUser(String token) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/delete"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        "status": false,
        "message": e.toString(),
      };
    }
  }

  Future changePassword(
      String token, String oldPass, String newPass, String confirmPass) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/change-password"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "oldPassword": oldPass,
          "newPassword": newPass,
          "confirmPassword": confirmPass
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
}
