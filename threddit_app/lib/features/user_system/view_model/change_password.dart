import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:threddit_app/features/user_system/view/widgets/alert.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';

Future<int> changePasswordFunction(
    {required String currentPassword,
    required String newPassword,
    required String confirmedPassword}) async {
  Map<String, dynamic> body = {
    'user_id': 1,
    'current_password': currentPassword,
    'new_password': newPassword,
    'confirmed_password': confirmedPassword,
  };

  String bodyEncoded = jsonEncode(body);

  http.Response response = await http.post(
    Uri.parse("http://10.0.2.2:3001/api/change-password"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: bodyEncoded,
  );

  final responseDecoded = jsonDecode(response.body);
  return response.statusCode;
}

void checkResponse(
    {required BuildContext context,
    required Future<int> statusCodeFuture}) async {
  int statusCode = await statusCodeFuture;
  if (statusCode == 200) {
    showAlert("Password was changed correctly!", context);
  } else {
    showAlert("Password wasn't changed.", context);
  }
}
