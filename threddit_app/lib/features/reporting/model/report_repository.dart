import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

/// This repository handles all the http requests sent to the backend related to reporting a post or a comment
/// submitReport is used to submit a report
/// The submitReport function takes the reportedID, type, additionalInfo, ruleReason and userID as it's parameters
/// The submitReport function returns a Future that is used to submit the report
/// The reportedID is the ID of the post or comment that is being reported
/// The type is the type of the report, it can be either post or comment
/// The additionalInfo is the additional information that the user wants to provide
/// The ruleReason is the reason for reporting the post or comment
/// The userID is the ID of the user who is reporting the post or comment
/// The submitReport function sends a POST request to the backend with the reportedID, type, additionalInfo, ruleReason and userID in the body
/// The submitReport function returns a Future that is used to submit the report

class ReportRepository {
  Future<void> submitReport({
    required String reportedID,
    required String type,
    required String additionalInfo,
    required String ruleReason,
    required String userID,
  }) async {
    final url = Uri.parse('https://www.threadit.tech/api/v1/report');
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
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      final jsonResponse = jsonDecode(response.body);
    } else {
      throw Exception('Failed to submit report');
    }
  }
}
