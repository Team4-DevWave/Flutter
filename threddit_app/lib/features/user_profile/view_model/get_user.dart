import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/user_profile/models/other_user_data.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';

final getUserProvider =
    StateNotifierProvider<GetUserNotifier, UserModelNotMe>((ref) => GetUserNotifier(ref));

class GetUserNotifier extends StateNotifier<UserModelNotMe> {
  final Ref ref;

  GetUserNotifier(this.ref) : super(UserModelNotMe());

  FutureEither<UserModelNotMe> getUser(String username) async {
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
        print("SUUUUUUUUUCCCCCCCEEEEEEEESSSSSSSSSSSSSS");
        final jsonBody = UserModelNotMe.fromJson(jsonDecode(response.body));
        state = jsonBody;
        print("SSSSSSSSSSSSSSSSSSSSSSSSSSsss");
        print(state.username);
        print(state.userProfileSettings?.about);
        return right(state);
      } else {

        return left(Failure("Getting user data failed :( "));
      }
    } catch (e) {
      throw e.toString();
    }
  }

}
