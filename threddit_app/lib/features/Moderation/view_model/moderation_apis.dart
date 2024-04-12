import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/Moderation/model/approved_user.dart';
import 'package:threddit_clone/features/Moderation/model/banned_user.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/Moderation/model/moderator.dart';

const String urlAndroid = "http://10.0.2.2:3001";
const String urlWindows = "http://localhost:3001";
final moderationApisProvider =
    StateNotifierProvider<ModerationApis, bool>((ref) => ModerationApis(ref));

class ModerationApis extends StateNotifier<bool> {
  final Ref ref;
  ModerationApis(this.ref) : super(false);
  Future<int> modUser({
    required http.Client client,
    required username,
    required permissions,
  }) async {
    Map<String, dynamic> body = {
      "username": username,
      "permissions": permissions,
    };
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    print(body);

    String bodyEncoded = jsonEncode(body);

    print(body);
    final response = await client.post(
      Uri.parse('$url/api/add-moderator'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: bodyEncoded,
    );
    return response.statusCode;
  }

  Future<int> editMod(
      {required http.Client client,
      required username,
      required permissions}) async {
    Map<String, dynamic> body = {
      "username": username,
      "permissions": permissions,
    };
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    print(body);

    String bodyEncoded = jsonEncode(body);

    print(body);
    final response = await client.patch(
      Uri.parse('$url/api/edit-moderator'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: bodyEncoded,
    );
    return response.statusCode;
  }

  Future<int> unMod({
    required http.Client client,
    required username,
  }) async {
    Map<String, dynamic> body = {"username": username};
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }

    String bodyEncoded = jsonEncode(body);

    print(body);
    final response = await client.delete(
      Uri.parse('$url/api/remove-moderator'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: bodyEncoded,
    );
    print(response.statusCode);
    return response.statusCode;
  }

  Future<List<Moderator>> getMods({required http.Client client}) async {
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    final response = await client.get(Uri.parse('$url/api/moderators'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      List<Moderator> moderators =
          data.map((userJson) => Moderator.fromJson(userJson)).toList();
      return moderators;
    } else {
      throw Exception('Failed to fetch banned users');
    }
  }

  Future<int> banUser(
      {required http.Client client,
      required username,
      required reason,
      message,
      modnote,
      length}) async {
    Map<String, dynamic> body = {
      "userToBan": username,
      "reasonToBan": reason,
      "messageToUser": message == null ? message : "",
      "banModNote": modnote == null ? modnote : " ",
      "banLength": length
    };
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    print(body);

    String bodyEncoded = jsonEncode(body);

    print(body);
    final response = await client.post(
      Uri.parse('$url/api/ban'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: bodyEncoded,
    );
    return response.statusCode;
  }

  Future<int> updateBannedUser(
      {required http.Client client,
      required username,
      required reason,
      message,
      modnote,
      length}) async {
    Map<String, dynamic> body = {
      "userToBan": username,
      "reasonToBan": reason,
      "messageToUser": message == null ? message : "",
      "banModNote": modnote == null ? modnote : " ",
      "banLength": length
    };
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    print(body);

    String bodyEncoded = jsonEncode(body);

    print(body);
    final response = await client.patch(
      Uri.parse('$url/api/ban'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: bodyEncoded,
    );
    return response.statusCode;
  }

  Future<int> unbanUser({
    required http.Client client,
    required username,
  }) async {
    Map<String, dynamic> body = {"userToUnBan": username};
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }

    String bodyEncoded = jsonEncode(body);

    print(body);
    final response = await client.delete(
      Uri.parse('$url/api/unban'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: bodyEncoded,
    );
    print(response.statusCode);
    return response.statusCode;
  }

  Future<List<BannedUser>> getBannedUsers({required http.Client client}) async {
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    final response = await client.get(Uri.parse('$url/api/banned'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      List<BannedUser> bannedUsers =
          data.map((userJson) => BannedUser.fromJson(userJson)).toList();
      return bannedUsers;
    } else {
      throw Exception('Failed to fetch banned users');
    }
  }

  Future<int> approveUser({
    required http.Client client,
    required username,
  }) async {
    Map<String, dynamic> body = {
      "userToApprove": username,
    };
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    print(body);

    String bodyEncoded = jsonEncode(body);

    print(body);
    final response = await client.post(
      Uri.parse('$url/api/approve'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: bodyEncoded,
    );
    return response.statusCode;
  }

  Future<int> removeUser({
    required http.Client client,
    required username,
  }) async {
    Map<String, dynamic> body = {"userToRemove": username};
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }

    String bodyEncoded = jsonEncode(body);

    print(body);
    final response = await client.delete(
      Uri.parse('$url/api/remove'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: bodyEncoded,
    );
    print(response.statusCode);
    return response.statusCode;
  }

  Future<List<ApprovedUser>> getApprovedUsers(
      {required http.Client client}) async {
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    final response = await client.get(Uri.parse('$url/api/approved'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      List<ApprovedUser> approvedUsers =
          data.map((userJson) => ApprovedUser.fromJson(userJson)).toList();
      return approvedUsers;
    } else {
      throw Exception('Failed to fetch banned users');
    }
  }
}
