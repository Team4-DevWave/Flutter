import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:threddit_clone/features/user_system/view/widgets/alert.dart';
import 'package:threddit_clone/features/user_system/model/user_mock.dart';

/// API call for changing password address:
/// Recieves the client, current password, new password, confirmed password as parameters,
/// Currently defaults to user_id 1 should be changed to token later.
/// Returns the status Code
Future<int> changePasswordFunction(
    {required http.Client client,
    required String currentPassword,
    required String newPassword,
    required String confirmedPassword}) async {
  Map<String, dynamic> body = {
    'user_id': 1,
    'current_password': currentPassword,
    'new_password': newPassword,
    'confirmed_password': confirmedPassword,
  };
  String bodyEncoded = jsonEncode(body);

  http.Response response = await client.post(
    Uri.parse("http://10.0.2.2:3001/api/change-password"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: bodyEncoded,
  );

  return response.statusCode;
}

Future<int> confirmPasswordFunction(
    {required http.Client client, required String confirmedPassword}) async {
  Map<String, dynamic> body = {
    'user_id': 1,
    'confirmed_password': confirmedPassword,
  };
  String bodyEncoded = jsonEncode(body);

  http.Response response = await client.post(
    Uri.parse("http://10.0.2.2:3001/api/confirm-password"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: bodyEncoded,
  );

  return response.statusCode;
}

/// API call for changing email address:
/// Recieves the client, current password, the new email as parameters,
/// Currently defaults to user_id 1 should be changed to token later.
/// Returns the status Code
Future<int> changeEmailFunction({
  required http.Client client,
  required String currentPassword,
  required String newEmail,
}) async {
  Map<String, dynamic> body = {
    'user_id': 1,
    'current_password': currentPassword,
    'new_email': newEmail,
  };

  String bodyEncoded = jsonEncode(body);

  http.Response response = await client.post(
    Uri.parse("http://10.0.2.2:3001/api/change-email"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: bodyEncoded,
  );
  return response.statusCode;
}

/// API call for changing Gender:
/// Recieves the client and the changed Gender as paramters,
/// Currently defaults to user_id 1 should be changed to token later.
/// Returns the status code.
Future<int> changeGenderFunction(
    {required http.Client client, required String gender}) async {
  Map<String, dynamic> body = {
    'user_id': 1,
    'gender': gender,
  };

  String bodyEncoded = jsonEncode(body);

  http.Response response = await client.post(
    Uri.parse("http://10.0.2.2:3001/api/change-gender"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: bodyEncoded,
  );
  return response.statusCode;
}

/// API Call for checking the Email Update Response,
/// Depending on the Status Code returns an alert to inform the User.
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

/// API Call for checking the Password Change Response,
/// Depending on the Status Code returns an alert to inform the User.
void checkPasswordChangeResponse(
    {required BuildContext context,
    required Future<int> statusCodeFuture}) async {
  int statusCode = await statusCodeFuture;
  if (statusCode == 200) {
    showAlert("Password was changed correctly!", context);
  } else {
    showAlert("Password was incorrect.", context);
  }
}

void checkPasswordConfirmResponse(
    {required BuildContext context,
    required Future<int> statusCodeFuture}) async {
  int statusCode = await statusCodeFuture;
  if (statusCode == 200) {
    Navigator.pop(context);
  } else {
    showAlert("Invalid Credintals", context);
  }
}

void checkBlockResponse(
    {required BuildContext context,
    required Future<int> statusCodeFuture}) async {
  int statusCode = await statusCodeFuture;
  if (statusCode == 200) {
  } else {
    showAlert("User was not blocked/unblocked", context);
  }
}

Future<int> blockUser(
    {required http.Client client, required String userToBlock}) async {
  Map<String, dynamic> body = {'blockUsername': userToBlock};
  String bodyEncoded = jsonEncode(body);

  http.Response response = await client.post(
    Uri.parse("http://10.0.2.2:3001/api/block-user"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: bodyEncoded,
  );
  return response.statusCode;
}

Future<int> followableOn(
    {required http.Client client, required bool isEnabled}) async {
  Map<String, dynamic> body = {'isOn': isEnabled};
  String bodyEncoded = jsonEncode(body);

  http.Response response = await client.post(
    Uri.parse("http://localhost:3001/api/followable?user_id=1"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: bodyEncoded,
  );
  print(response.statusCode);
  return response.statusCode;
}

Future<int> notificationOn(
    {required http.Client client, required bool isEnabled}) async {
  Map<String, dynamic> body = {'isOn': isEnabled};
  String bodyEncoded = jsonEncode(body);

  http.Response response = await client.post(
    Uri.parse("http://10.0.2.2:3001/api/notification?user_id=1"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: bodyEncoded,
  );
  print(response.statusCode);
  return response.statusCode;
}

Future<int> unblockUser(
    {required http.Client client, required String userToUnBlock}) async {
  Map<String, dynamic> body = {'blockUsername': userToUnBlock};
  String bodyEncoded = jsonEncode(body);

  http.Response response = await client.post(
    Uri.parse("http://10.0.2.2:3001/api/unblock-user"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: bodyEncoded,
  );
  return response.statusCode;
}

final settingsFetchProvider =
    StateNotifierProvider<SettingsFetch, bool>((ref) => SettingsFetch(ref));

class SettingsFetch extends StateNotifier<bool> {
  final Ref ref;
  SettingsFetch(this.ref) : super(false);

  /// API Call to fetch the User data

  Future<UserMock> getUserInfo(http.Client client) async {
    // final url = Uri.https(
    //     'threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app',
    //     'users.json');
    //final url = Uri.http("localhost:3001/api/user-info?user_id=1");
    final url;
    if (Platform.isWindows) {
      url = Uri.parse("http://localhost:3001/api/user-info?user_id=1");
    } else {
      url = Uri.parse("http://10.0.2.2:3001/api/user-info?user_id=1");
    }
    try {
      http.Response response = await http.get(url);

      print(response.body);
      return UserMock.fromJson(jsonDecode(response.body));
    } catch (e) {
      print(e.toString());
      return UserMock.fromJson(jsonDecode('sd'));
    }
  }

  Future<List<UserMock>> searchUsers(http.Client client, String query) async {
    http.Response response = await client.get(
      Uri.parse("http://10.0.2.2:3001/api/search-user?query=$query"),
    );
    List<dynamic> data = jsonDecode(response.body.toString());
    List<UserMock> users = [];
    for (var userData in data) {
      String username = userData['username'] as String;
      bool blocked = userData['blocked'] as bool;
      users.add(UserMock(
          id: '',
          email: '',
          username: username,
          isBlocked: blocked,
          gender: ''));
      print(users);
      print(data);
    }
    return users;
  }

  Future<UserMock> getBlockedUsers(http.Client client) async {
    http.Response response = await client.get(
      Uri.parse("http://10.0.2.2:3001/api/user-info?user_id=2"),
    );
    return UserMock.fromJson(jsonDecode(response.body));
  }

  Future<bool> getNotificationSetting(http.Client client) async {
    http.Response response = await client.get(
      Uri.parse("http://10.0.2.2:3001/api/user-info?user_id=1"),
    );
    Map<String, dynamic> userData = jsonDecode(response.body);
    final body = jsonDecode(response.body);
    print(body);
    final bool isNotificationEnabled = userData['notification'];
    print(isNotificationEnabled);
    return isNotificationEnabled;
  }

  Future<bool> getFollowableSetting(http.Client client) async {
    http.Response response = await client.get(
      Uri.parse("http://localhost:3001/api/user-info?user_id=1"),
    );
    print('AMOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO');
    Map<String, dynamic> userData = jsonDecode(response.body);
    final body = jsonDecode(response.body);
    print(body);
    final bool isFollowableEnabled = userData['isFollowable'];
    print(isFollowableEnabled);
    return isFollowableEnabled;
  }
}
