// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/user_data.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/model/user_settings.dart';
import 'package:threddit_clone/features/user_system/view/widgets/alert.dart';
import 'package:threddit_clone/features/user_system/model/user_mock.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth_controller.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';

const String urlAndroid = "http://10.0.2.2";
const String urlWindows = "http://localhost";

/// API call for changing password address:
/// Recieves the client, current password, new password, confirmed password as parameters,
/// Currently defaults to user_id 1 should be changed to token later.
/// Returns the status Code
Future<int> changePasswordFunction(
    {required String currentPassword,
    required String newPassword,
    required String confirmedPassword}) async {
  Map<String, dynamic> body = {
    'currentPassword': currentPassword,
    'newPassword': newPassword,
    'passwordConfirm': confirmedPassword,
  };
  String bodyEncoded = jsonEncode(body);
  final String url;
  if (Platform.isWindows) {
    url = urlWindows;
  } else {
    url = urlAndroid;
  }
  String? token = await getToken();
  http.Response response = await http.patch(
    Uri.parse("$url:8000/api/v1/users/me/settings/changepassword"),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: bodyEncoded,
  );

  return response.statusCode;
}

Future<int> confirmPasswordFunction(
    {required http.Client client,
    required String confirmedPassword,
    required String token}) async {
  Map<String, dynamic> body = {
    'user_id': 1,
    'confirmed_password': confirmedPassword,
  };
  String bodyEncoded = jsonEncode(body);
  final String url;
  if (Platform.isWindows) {
    url = urlWindows;
  } else {
    url = urlAndroid;
  }
  http.Response response = await client.post(
    Uri.parse("$url:3001/api/confirm-password"),
    headers: {
      'Authorization': 'Bearer $token',
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
  required String newEmail,
}) async {
  Map<String, dynamic> body = {
    'email': newEmail,
  };
  String? token = await getToken();
  final String url;
  if (Platform.isWindows) {
    url = urlWindows;
  } else {
    url = urlAndroid;
  }

  String bodyEncoded = jsonEncode(body);
  http.Response response = await http.patch(
    Uri.parse("$url:8000/api/v1/users/me/settings/changeemail"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: bodyEncoded,
  );
  return response.statusCode;
}

/// API call for changing Gender:
/// Recieves the client and the changed Gender as paramters,
/// Currently defaults to user_id 1 should be changed to token later.
/// Returns the status code.
Future<int> changeGenderFunction({
  required String gender,
}) async {
  Map<String, dynamic> body = {
    'gender': gender,
  };
  String? token = await getToken();
  final String url;
  if (Platform.isWindows) {
    url = urlWindows;
  } else {
    url = urlAndroid;
  }
  String bodyEncoded = jsonEncode(body);

  http.Response response = await http.patch(
    Uri.parse("$url:8000/api/v1/users/me/changeGender"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: bodyEncoded,
  );
  return response.statusCode;
}

/// API Call for checking the Email Update Response,
/// Depending on the Status Code returns an alert to inform the User.
void checkEmailUpdateResponse(
    {required BuildContext context, required int statusCodeFuture}) async {
  int statusCode = await statusCodeFuture;
  if (statusCode == 200) {
    showAlert("Email was changed correctly!", context);
  } else {
    showAlert("Email wasn't changed.", context);
  }
}

/// API Call for checking the Password Change Response,
/// Depending on the Status Code returns an alert to inform the User.
void checkPasswordChangeResponse({
  required WidgetRef ref,
  required BuildContext context,
  required Future<int> statusCodeFuture,
}) async {
  int statusCode = await statusCodeFuture;
  if (statusCode == 200) {
    ref.watch(authControllerProvider.notifier).logout();
    showAlert("Password was changed correctly! Please log in again!", context);
  } else {
    showAlert("Password was incorrect.", context);
  }
}

void checkBlockResponse(
    {required BuildContext context, required int statusCodeFuture}) async {
  int statusCode = await statusCodeFuture;
  if (statusCode == 200) {
  } else {
    showAlert("User was not blocked/unblocked", context);
  }
}

Future<int> blockUser({
  required String userToBlock,
  required BuildContext context,
}) async {
  String? token = await getToken();
  final String url;
  if (Platform.isWindows) {
    url = urlWindows;
  } else {
    url = urlAndroid;
  }
  http.Response response = await http.post(
    Uri.parse("$url:8000/api/v1/users/me/block/$userToBlock"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  checkBlockResponse(context: context, statusCodeFuture: response.statusCode);
  Navigator.pop(context);
  return response.statusCode;
}

Future<int> notificationOn(
    {required http.Client client,
    required bool isEnabled,
    required String token}) async {
  Map<String, dynamic> body = {'isOn': isEnabled};
  String bodyEncoded = jsonEncode(body);

  final String url;
  if (Platform.isWindows) {
    url = urlWindows;
  } else {
    url = urlAndroid;
  }

  http.Response response = await client.post(
    Uri.parse("$url/api/notification?user_id=1"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: bodyEncoded,
  );
  return response.statusCode;
}

Future<int> unblockUser(
    {required http.Client client,
    required String userToUnBlock,
    required BuildContext context}) async {
  final String url;
  String? token = await getToken();
  if (Platform.isWindows) {
    url = urlWindows;
  } else {
    url = urlAndroid;
  }
  http.Response response = await client.delete(
    Uri.parse("$url:8000/api/v1/users/me/block/$userToUnBlock"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 204) {
    showAlert("User was unblocked succesfully", context);
  } else {
    showAlert("User was not unblocked", context);
  }
  return response.statusCode;
}

final settingsFetchProvider =
    StateNotifierProvider<SettingsFetch, bool>((ref) => SettingsFetch(ref));

class SettingsFetch extends StateNotifier<bool> {
  final Ref ref;
  SettingsFetch(this.ref) : super(false);
  void checkPasswordConfirmResponse(
      {required BuildContext context,
      required Future<int> statusCodeFuture}) async {
    int statusCode = await statusCodeFuture;
    if (statusCode == 200) {
      UserModel? currentUser = ref.read(userProvider)!;
      UserModel updatedUser = currentUser.copyWith(isGoogle: true);
      ref.read(userProvider.notifier).state = updatedUser;
      Navigator.pop(context);
    } else {
      showAlert("Invalid Credintals", context);
    }
  }

  /// API Call to fetch the User data

  Future<UserMock> getUserInfo(
      {required http.Client client, required String token}) async {
    // final url = Uri.https(
    //     'threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app',
    //     'users.json');
    //final url = Uri.http("localhost:3001/api/user-info?user_id=1");
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    try {
      http.Response response = await http.get(
        Uri.parse("$url:3001/api/user-info?user_id=1"),
      );

      return UserMock.fromJson(jsonDecode(response.body));
    } catch (e) {
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
    }
    return users;
  }

  Future<UserMock> getBlockedUsers() async {
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    String? token = await getToken();
    http.Response response = await http.get(
      Uri.parse("$url:3001/api/user-info?user_id=2"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return UserMock.fromJson(jsonDecode(response.body));
  }

  Future<UserModelMe> getMe() async {
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    String? token = await getToken();
    http.Response response = await http.get(
      Uri.parse("$url:8000/api/v1/users/me/current"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return UserModelMe.fromJson(jsonDecode(response.body));
  }

  Future<UserSettings> getSettings() async {
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    String? token = await getToken();
    http.Response response = await http.get(
      Uri.parse("$url:8000/api/v1/users/me/settings"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return UserSettings.fromJson(jsonDecode(response.body));
  }

  Future<bool> getNotificationSetting(
      {required http.Client client, required String token}) async {
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    http.Response response = await client.get(
      Uri.parse("$url:3001/api/user-info?user_id=1"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> userData = jsonDecode(response.body);
    final bool isNotificationEnabled = userData['notification'];
    return isNotificationEnabled;
  }

  Future<bool> getFollowableSetting() async {
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    String? token = await getToken();
    http.Response response = await http.get(
      Uri.parse("$url/api/user-info?user_id=1"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> userData = jsonDecode(response.body);
    final bool isFollowableEnabled = userData['isFollowable'];
    return isFollowableEnabled;
  }
}

Future<int> changeSetting({
  required change,
  required String settingsName,
  required String settingsType,
}) async {
  Map<String, dynamic> body = {
    settingsType: {
      settingsName: change,
    }
  };
  String? token = await getToken();
  String bodyEncoded = jsonEncode(body);
  final String url;
  if (Platform.isWindows) {
    url = urlWindows;
  } else {
    url = urlAndroid;
  }
  http.Response response = await http.patch(
    Uri.parse("$url:8000/api/v1/users/me/settings"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: bodyEncoded,
  );
  return response.statusCode;
}

Future<int> changeCountry({
  required String country,
}) async {
  Map<String, dynamic> body = {
    "country": country,
  };
  String? token = await getToken();
  String bodyEncoded = jsonEncode(body);
  final String url;
  if (Platform.isWindows) {
    url = urlWindows;
  } else {
    url = urlAndroid;
  }
  http.Response response = await http.patch(
    Uri.parse("$url:8000/api/v1/users/me/settings/changecountry"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: bodyEncoded,
  );
  return response.statusCode;
}
