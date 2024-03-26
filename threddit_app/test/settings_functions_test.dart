import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:threddit_app/features/user_system/model/user_mock.dart';
import 'package:threddit_app/features/user_system/view_model/settings_functions.dart';
import 'settings_functions_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {

  final url = Uri.parse("http://10.0.2.2:3001/api/user-info?user_id=1");
  final testBody = jsonEncode({
    'user_id': 1,
    'current_password': 'currentPassword',
    'new_password': 'newPassword',
    'confirmed_password': 'confirmedPassword',
  });
  test('Checks if user data are retrieved correctly', () async {
    final client = MockClient();
    final testUser = UserMock(
        id: '1', email: 'ahmed@gmail.com', username: "user1", gender: "Man");
    when(client.get(url)).thenAnswer((_) async => http.Response(
          '{"username":"user1","email": "ahmed@gmail.com", "user_id": "1", "gender": "Man"}',
          200,
        ));
    final result = await getUserInfo(client);
    expect(result.getUsername, equals(testUser.getUsername));
    expect(result.getEmail, equals(testUser.getEmail));
    expect(result.getGender, equals(testUser.getGender));
  });

  test('Checks if change password works correctly', () async {
    final client = MockClient();
    when(client.post(
      Uri.parse("http://10.0.2.2:3001/api/change-password"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': 1,
        'current_password': 'current',
        'new_password': 'new',
        'confirmed_password': 'new',
      }),
    )).thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

    expect(
        await changePasswordFunction(
            client: client,
            currentPassword: 'current',
            newPassword: 'new',
            confirmedPassword: 'new'),
        200);
  });

  test('Checks if change password works correctly', () async {
    final client = MockClient();
    when(client.post(
      Uri.parse("http://10.0.2.2:3001/api/change-password"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': 1,
        'current_password': 'not_current',
        'new_password': 'new',
        'confirmed_password': 'new',
      }),
    )).thenAnswer((_) async => http.Response('Error', 401));

    expect(
        await changePasswordFunction(
            client: client,
            currentPassword: 'not_current',
            newPassword: 'new',
            confirmedPassword: 'new'),
        401);
  });

  test('Checks if change email works correctly', () async {
    final client = MockClient();
    when(client.post(
      Uri.parse("http://10.0.2.2:3001/api/change-email"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': 1,
        'current_password': 'current',
        'new_email': 'ahmed@gmail.com'
      }),
    )).thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

    expect(
        await changeEmailFunction(
          client: client,
          currentPassword: 'current',
          newEmail: 'ahmed@gmail.com',
        ),
        200);
  });

  test('Checks if change email works correctly', () async {
    final client = MockClient();
    when(client.post(
      Uri.parse("http://10.0.2.2:3001/api/change-email"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': 1,
        'current_password': 'not_current',
        'new_email': 'ahmed@gmail.com'
      }),
    )).thenAnswer((_) async => http.Response('Error incorret password', 401));

    expect(
        await changeEmailFunction(
          client: client,
          currentPassword: 'not_current',
          newEmail: 'ahmed@gmail.com',
        ),
        401);
  });

  test('Checks if change gender works correctly', () async {
    final client = MockClient();
    when(client.post(
      Uri.parse("http://10.0.2.2:3001/api/change-gender"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': 1,
        'gender': "Man",
      }),
    )).thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

    expect(await changeGenderFunction(client: client, gender: "Man"), 200);
  });
}
