import 'dart:convert';
import 'package:http/http.dart' as http;

/// Thin REST client for the NestJS API. Attaches the Firebase ID token.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  // Use 10.0.2.2 for Android emulator -> host machine; localhost for iOS sim.
  String baseUrl = const String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://localhost:3000/api',
  );

  Future<String?> Function()? tokenProvider;

  Future<Map<String, String>> _headers() async {
    final token = await tokenProvider?.call();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String path) async {
    final res = await http.get(Uri.parse('$baseUrl$path'), headers: await _headers());
    return _decode(res);
  }

  Future<dynamic> post(String path, Object body) async {
    final res = await http.post(Uri.parse('$baseUrl$path'),
        headers: await _headers(), body: jsonEncode(body));
    return _decode(res);
  }

  Future<dynamic> patch(String path, Object body) async {
    final res = await http.patch(Uri.parse('$baseUrl$path'),
        headers: await _headers(), body: jsonEncode(body));
    return _decode(res);
  }

  Future<dynamic> delete(String path) async {
    final res = await http.delete(Uri.parse('$baseUrl$path'), headers: await _headers());
    return _decode(res);
  }

  dynamic _decode(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return res.body.isEmpty ? null : jsonDecode(res.body);
    }
    throw Exception('API ${res.statusCode}: ${res.body}');
  }
}
