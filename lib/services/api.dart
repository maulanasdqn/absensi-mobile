import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class ApiRequest {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  Future<bool> sendAttendace(String lat, String long) async {
    final url = dotenv.env['API_URL'] ?? '';
    final apiUrl = '$url/user/attendance';
    final uri = Uri.parse(apiUrl);
    final String? token = await _secureStorage.read(key: 'access_token');
    if (token == null) return false;
    final res = await http.post(uri, headers: <String, String>{
      'Authorization': 'Bearer $token',
    }, body: {
      'latitude': lat,
      'longitude': long,
    });
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getAttendanceHistory() async {
    final url = dotenv.env['API_URL'] ?? '';
    final apiUrl = '$url/user/attendance';
    final uri = Uri.parse(apiUrl);
    final String? token = await _secureStorage.read(key: 'access_token');
    if (token == null) return null;

    final res = await http.get(uri, headers: <String, String>{
      'Authorization': 'Bearer $token',
    });
    if (res.statusCode == 200) {
      final Map<String, dynamic> attendanceHistory = jsonDecode(res.body);

      return attendanceHistory;
    } else {
      return null;
    }
  }
}
