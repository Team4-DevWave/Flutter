import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/user_profile/models/user_model.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

final getUserProvider =
    StateNotifierProvider<GetUser, bool>((ref) => GetUser(ref));

class GetUser extends StateNotifier<bool> {
  final Ref ref;

  GetUser(this.ref) : super(false);

  Future<void> getUser(String username) async {
    String? token = await getToken();
    try {
      http.Response response = await http.get(
        Uri.parse("http://${AppConstants.local}:8000/api/v1/users/$username"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        UserModelNotMe user = ref.read(userModelNotMeProvider)!;
        user = UserModelNotMe.fromJson(jsonDecode(response.body));
        ref.watch(userModelNotMeProvider.notifier).update((state) => user);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
