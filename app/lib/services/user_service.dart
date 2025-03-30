import 'dart:convert';

import 'package:wellfi2/constants.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<Map<String, dynamic>> getUserData({
    required String authToken,
    required String id,
  }) async {
    final response = await http.get(
      Uri.parse('$kAPI_URL/users/$id'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
