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
  final testStatusCode = 200;
  final testBody = jsonEncode({
    'user_id': 1,
    'current_password': 'currentPassword',
    'new_password': 'newPassword',
    'confirmed_password': 'confirmedPassword',
  });
  test('Checks if user data are returned correctly', () async {
    final client = MockClient();
    final testUser = UserMock(
        id: '1', email: 'ahmed@gmail.com', username: "user1", gender: "Man");
    testUser.printUserInfo();
    when(client.get(url)).thenAnswer((_) async => http.Response(
          '{"username":"user1","email": "ahmed@gmail.com", "user_id": "1", "gender": "Man"}',
          200,
        ));
    final result = await getUserInfo(client);
    logInvocations([client]);
    expect(result.getUsername, equals(testUser.getUsername));
  });
}
