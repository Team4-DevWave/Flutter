import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

class ReportRepository {
  Future<void> submitReport({
    required String reportedID,
    required String type,
    required String additionalInfo,
    required String ruleReason,
    required String userID,
  }) async {
    final url = Uri.parse('http://10.0.2.2:8000:8000/api/v1/report');
    String? token = await getToken();
    final body = jsonEncode({
      'reportedID': reportedID,
      'type': type,
      'additional_info': additionalInfo,
      'rule_reason': ruleReason,
      'userID': userID,
    });
     final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", 
    };

    final response = await http.post(
      url,
      headers:headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      
    } else {
      throw Exception('Failed to submit report');
    }
  }
}
