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

  Future<List<BannedUser>> getBannedUsers() async {
    final String url;
    if (Platform.isWindows) {
      url = urlWindows;
    } else {
      url = urlAndroid;
    }
    final response = await http.get(Uri.parse('$url/api/banned'));
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
