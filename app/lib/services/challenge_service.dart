import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wellfi2/constants.dart';
import 'package:wellfi2/models/Challenge.dart';

class ChallengeService {
  static Future<List<Challenge>> getPublicChallenges({
    required String authToken,
  }) async {
    try {
      final url = Uri.parse('$kAPI_URL/challenges/all');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      print(response.body.toString());
      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((challenge) => Challenge.fromJson(challenge)).toList();
      } else {
        print('Error: ${response.statusCode}');
        print('Error: ${response.body}');
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<bool> createChallenge({
    required String title,
    required String desc,
    required String creator,
    required String visibility,
    required DateTime startDate,
    required List<String> participants,
    required int requiredStake,
    required String type,
    required String targetType,
    required DateTime deadline,
    required ChallengeTarget target,
    required String status,
    required String authToken,
  }) async {
    try {
      final url = Uri.parse('$kAPI_URL/users/create');

      final Map<String, dynamic> dummyUser = {
        "title": title,
        "desc": desc,
        "creator": creator,
        "visibility": visibility,
        "startDate": startDate,
        "participants": participants,
        "requiredStake": requiredStake,
        "type": type,
        "targetType": targetType,
        "deadline": deadline,
        "target": {
          "steps": target.steps,
          "distance": target.distance,
        },
        "status": status,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(dummyUser),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
