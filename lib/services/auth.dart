import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  Future<bool> login(String email, String password) async {
    final url = dotenv.env['API_URL'] ?? '';
    final apiUrl = '$url/auth/login';
    final uri = Uri.parse(apiUrl);
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String accessToken = data['data']['access_token'];
      await _secureStorage.write(key: 'access_token', value: accessToken);

      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
  }

  Future<bool> isLoggedIn() async {
    final String? token = await _secureStorage.read(key: 'access_token');
    return token != null;
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final url = dotenv.env['API_URL'] ?? '';
    final apiUrl = '$url/user/me';
    final uri = Uri.parse(apiUrl);
    final String? token = await _secureStorage.read(key: 'access_token');
    if (token == null) return null;

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = jsonDecode(response.body);
      return userData;
    } else {
      return null;
    }
  }
}
