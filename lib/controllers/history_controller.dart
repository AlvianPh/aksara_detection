import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HistoryController {
  final String baseUrl = "http://10.0.2.2:5000/api";

  Future getAllHistory(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/history"),
        headers: {"Authorization": "Bearer $token"},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future getHistoryById(String token, int id) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/history/$id"),
        headers: {"Authorization": "Bearer $token"},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future saveHistory(
      String token, String hasil, String akurasi, File foto) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/history"),
      );

      request.headers["Authorization"] = "Bearer $token";
      request.fields["hasil"] = hasil;
      request.fields["akurasi"] = akurasi;
      request.files.add(await http.MultipartFile.fromPath("foto", foto.path));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody);
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future deleteHistory(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/history/$id"),
        headers: {"Authorization": "Bearer $token"},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
}
