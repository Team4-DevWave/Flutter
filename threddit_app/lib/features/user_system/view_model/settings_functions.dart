import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:threddit_app/features/user_system/view/widgets/alert.dart';
import 'package:threddit_app/features/user_system/model/user_mock.dart';
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

  return response.statusCode;
}
Future<int> changeEmailFunction(
    {required String currentPassword,
    required String newEmail,}) async {
  Map<String, dynamic> body = {
    'user_id': 1,
    'current_password': currentPassword,
    'new_email': newEmail,
  };

  String bodyEncoded = jsonEncode(body);

  http.Response response = await http.post(
    Uri.parse("http://10.0.2.2:3001/api/change-email"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: bodyEncoded,
  );
  return response.statusCode;
}
Future<int> changeGenderFunction(
    {required String gender}) async {
  Map<String, dynamic> body = {
    'user_id': 1,
    'gender': gender,
  };

  String bodyEncoded = jsonEncode(body);

  http.Response response = await http.post(
    Uri.parse("http://10.0.2.2:3001/api/change-gender"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: bodyEncoded,
  );
  return response.statusCode;
}
void checkEmailUpdateResponse(
    {required BuildContext context,
    required Future<int> statusCodeFuture}) async {
  int statusCode = await statusCodeFuture;
  if (statusCode == 200) {
    showAlert("Email was changed correctly!", context);
  } else {
    showAlert("Email wasn't changed.", context);
  }
}
void checkPasswordChangeResponse(
    {required BuildContext context,
    required Future<int> statusCodeFuture}) async {
  int statusCode = await statusCodeFuture;
  if (statusCode == 200) {
    showAlert("Password was changed correctly!", context);
  } else {
    showAlert("Password wasn't changed.", context);
  }
}


Future<UserMock> getUserInfo() async {


  http.Response response = await http.get(
    Uri.parse("http://10.0.2.2:3001/api/user-info?user_id=1"),
  );
  return UserMock.fromJson(jsonDecode(response.body));
 
  
}