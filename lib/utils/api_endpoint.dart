class ApiEndpoint {
  static const String baseUrl = "http://10.0.2.2:5000/api";

  static String login = "$baseUrl/login";
  static String register = "$baseUrl/register";
  static String profile = "$baseUrl/profile";
  static String changePassword = "$baseUrl/profile/password";
  static String history = "$baseUrl/history";
  static String deleteUser = "$baseUrl/delete";
}
