import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://mindlaundry.help'; //10.0.2.2:8080

class ApiService {
  static Future<String> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null || token.isEmpty) {
      throw Exception("Access token is missing");
    }
    return token;
  }

  static Future<http.Response> get(String endpoint) async {
    final token = await _getAccessToken();
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    return _handleResponse(response);
  }

  static Future<http.Response> post(String endpoint, dynamic body) async {
    final token = await _getAccessToken();
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<http.Response> postMessage(String endpoint, dynamic cookie, dynamic body) async {
    final token = await _getAccessToken();
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Cookie': cookie
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<http.Response> put(String endpoint, dynamic body) async {
    final token = await _getAccessToken();
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<http.Response> patch(String endpoint, dynamic body) async {
    final token = await _getAccessToken();
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<http.Response> delete(String endpoint) async {
    final token = await _getAccessToken();
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    return _handleResponse(response);
  }

  static http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      final body = jsonDecode(response.body);
      final message = body['message'] ?? 'Unknown error';
      throw Exception('API Error: $message');
    }
  }
}
