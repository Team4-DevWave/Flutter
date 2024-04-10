import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/Moderation/model/banned_user.dart';
import 'package:http/http.dart' as http;

const String urlAndroid = "http://10.0.2.2:3001";
const String urlWindows = "http://localhost:3001";
final moderationApisProvider =
    StateNotifierProvider<ModerationApis, bool>((ref) => ModerationApis(ref));

class ModerationApis extends StateNotifier<bool> {
  final Ref ref;
  ModerationApis(this.ref) : super(false);
  Future<int> banUser({required http.Client client, required username}) async {
    Map<String, dynamic> body = {"userToBan": username};
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }

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

  Future<int> unbanUser({required http.Client client, required username}) async {
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
}
