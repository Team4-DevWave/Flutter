// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:threddit_clone/features/user_system/model/notification_settings_model.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/user_data.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/model/user_settings.dart';
import 'package:threddit_clone/features/user_system/view/widgets/alert.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth_controller.dart';
import 'package:threddit_clone/features/user_system/view_model/user_settings_provider.dart';
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
  String? token = await getToken();
  http.Response response = await http.patch(
    Uri.parse(
        "https://www.threadit.tech/api/v1/users/me/settings/changepassword"),
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

  String bodyEncoded = jsonEncode(body);
  http.Response response = await http.patch(
    Uri.parse("https://www.threadit.tech/api/v1/users/me/settings/changeemail"),
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

  String bodyEncoded = jsonEncode(body);

  http.Response response = await http.patch(
    Uri.parse("https://www.threadit.tech/api/v1/users/me/changeGender"),
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
  int statusCode = statusCodeFuture;
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
  int statusCode = statusCodeFuture;
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

  http.Response response = await http.post(
    Uri.parse("https://www.threadit.tech/api/v1/users/me/block/$userToBlock"),
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
    {required http.Client client, required String settingName}) async {
  Map<String, dynamic> body = {'setting': settingName};
  String bodyEncoded = jsonEncode(body);
  String? token = await getToken();
  http.Response response = await client.patch(
    Uri.parse(
        "https://www.threadit.tech/api/v1/notifications/change_user_settings"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: bodyEncoded,
  );
  return response.statusCode;
}

Future<int> modNotificationOn({required String subredditName}) async {
  String? token = await getToken();
  http.Response response = await http.patch(
    Uri.parse(
        "https://www.threadit.tech/pi/v1/notifications/change_user_mod_notifications_settings/$subredditName"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  return response.statusCode;
}

Future<int> activityModNotification({
  required String subredditName,
}) async {
  String? token = await getToken();
  http.Response response = await http.patch(
    Uri.parse(
        "https://www.threadit.tech/api/v1/notifications/change_user_mod_notifications_settings/$subredditName/activity"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  return response.statusCode;
}

Future<int> reportCommentModNotification(
    {required String settingName, required String subredditName}) async {
  String? token = await getToken();
  http.Response response = await http.patch(
    Uri.parse(
        "https://www.threadit.tech/api/v1/notifications/change_user_mod_notifications_settings/$subredditName/reports/comments/$settingName"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  return response.statusCode;
}

Future<int> reportPostModNotification(
    {required String settingName, required String subredditName}) async {
  String? token = await getToken();
  http.Response response = await http.patch(
    Uri.parse(
        "https://www.threadit.tech/api/v1/notifications/change_user_mod_notifications_settings/$subredditName/reports/posts/$settingName"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  return response.statusCode;
}

Future<int> activitypostWithUpvotes(
    {required String settingName, required String subredditName}) async {
  String? token = await getToken();
  http.Response response = await http.patch(
    Uri.parse(
        "https://www.threadit.tech/api/v1/notifications/change_user_mod_notifications_settings/$subredditName/activity/postsWithUpvotes/$settingName"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  return response.statusCode;
}

Future<int> activitypostWithComments(
    {required String settingName, required String subredditName}) async {
  String? token = await getToken();
  http.Response response = await http.patch(
    Uri.parse(
        "https://www.threadit.tech/api/v1/notifications/change_user_mod_notifications_settings/$subredditName/activity/postsWithComments/$settingName"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  return response.statusCode;
}

Future<int> activityCommentSlider(
    {required String subredditName, required double value}) async {
  String? token = await getToken();
  int newValue = value.toInt();
  http.Response response = await http.patch(
    Uri.parse(
        "https://www.threadit.tech/api/v1/notifications/change_user_mod_notifications_settings/$subredditName/activity/postsWithComments/advancedSetup/$newValue"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  return response.statusCode;
}

Future<int> activityUpvotesSlider(
    {required String subredditName, required double value}) async {
  String? token = await getToken();
  int newValue = value.toInt();
  http.Response response = await http.patch(
    Uri.parse(
        "https://www.threadit.tech/api/v1/notifications/change_user_mod_notifications_settings/$subredditName/activity/postsWithUpvotes/advancedSetup/$newValue"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  return response.statusCode;
}

Future<int> reportCommentsSlider(
    {required String subredditName, required double value}) async {
  String? token = await getToken();
  int newValue = value.toInt();
  http.Response response = await http.patch(
    Uri.parse(
        "https://www.threadit.tech/api/v1/notifications/change_user_mod_notifications_settings/$subredditName/reports/comments/advancedSetup/$newValue"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  return response.statusCode;
}

Future<int> reportPostsSlider(
    {required String subredditName, required double value}) async {
  String? token = await getToken();
  int newValue = value.toInt();
  http.Response response = await http.patch(
    Uri.parse(
        "https://www.threadit.tech/api/v1/notifications/change_user_mod_notifications_settings/$subredditName/reports/posts/advancedSetup/$newValue"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  return response.statusCode;
}

Future<int> unblockUser(
    {required http.Client client,
    required String userToUnBlock,
    required BuildContext context}) async {
  String? token = await getToken();

  http.Response response = await client.delete(
    Uri.parse("https://www.threadit.tech/api/v1/users/me/block/$userToUnBlock"),
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

  Future<UserModelMe> getMe() async {
    UserModelMe user = ref.read(userModelProvider)!;
    String? token = await getToken();
    http.Response response = await http.get(
      Uri.parse("https://www.threadit.tech/api/v1/users/me/current"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      user = UserModelMe.fromJson(jsonDecode(response.body));
      ref.read(userModelProvider.notifier).update((state) => user);
    } else {}
    return UserModelMe.fromJson(jsonDecode(response.body));
  }

  Future<UserSettings> getSettings() async {
    String? token = await getToken();
    http.Response response = await http.get(
      Uri.parse("https://www.threadit.tech/api/v1/users/me/settings"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final userSettings = UserSettings.fromJson(jsonDecode(response.body));
    ref.read(userProfileProvider.notifier).setUser(userSettings.userProfile);
    return userSettings;
  }

  Future<NotificationsSettingsModel> getNotificationSetting(
      {required http.Client client}) async {
    String? token = await getToken();
    http.Response response = await client.get(
      Uri.parse("https://www.threadit.tech/api/v1/notifications/settings"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return NotificationsSettingsModel.fromJson(jsonDecode(response.body));
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
  http.Response response = await http.patch(
    Uri.parse("https://www.threadit.tech//api/v1/users/me/settings"),
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

  http.Response response = await http.patch(
    Uri.parse(
        "https://www.threadit.tech/api/v1/users/me/settings/changecountry"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: bodyEncoded,
  );
  return response.statusCode;
}
