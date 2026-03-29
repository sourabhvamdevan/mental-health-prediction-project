import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000/api";

  static Future<Map<String, dynamic>?> getUserByUid(String uid) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$uid'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  static Future<bool> signupUser({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "uid": uid,
          "name": name,
          "email": email,
          "phone": phone,
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("Signup Error: $e");
      return false;
    }
  }
}
