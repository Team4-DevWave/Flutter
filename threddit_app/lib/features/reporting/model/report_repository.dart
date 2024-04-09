import 'dart:convert';

import 'package:http/http.dart' as http;

class ReportRepository {
  Future<void> submitReport({
    required String reportedID,
    required String type,
    required String additionalInfo,
    required String ruleReason,
    required String userID,
  }) async {
    //final url = Uri.parse('http://localhost:8000/api/v1/report');
    final url = Uri.parse('http://192.168.100.249:3000/reports');
    final body = jsonEncode({
      'reportedID': reportedID,
      'type': type,
      'additional_info': additionalInfo,
      'rule_reason': ruleReason,
      'userID': userID,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // Handle successful response, if needed
    } else {
      throw Exception('Failed to submit report');
    }
  }
}
