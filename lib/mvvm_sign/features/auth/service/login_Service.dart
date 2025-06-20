import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/common/constants/api_endpoints.dart';
import '../model/signin_model.dart';

class LoginService {
  Future<Welcome?> loginService(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.login),
        body: {'username': email, 'password': password},
      );

      print('🔍 Raw Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('Parsed JSON: $json');
        return Welcome.fromJson(json);
      }
    } catch (e) {
      print('Login error: $e');
    }
    return null;
  }
}
