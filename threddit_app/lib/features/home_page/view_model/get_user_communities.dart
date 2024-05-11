import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:http/http.dart';

import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';

final userCommunitisProvider =
    StateNotifierProvider<UserCommunities, bool>((ref) => UserCommunities(ref));

class UserCommunities extends StateNotifier<bool> {
  Ref ref;
  UserCommunities(this.ref) : super(false);

  // static String local = Platform.isAndroid ? '${AppConstants.local}' : 'localhost';

  final String communitiesURL =
      "https://www.threadit.tech/api/v1/r/user_subreddits";

  ///The function returns the names of the user's communities
  FutureEither<List<List<String>>> getUserCommunities() async {
    final token = await getToken();
    try {
      Response res = await get(Uri.parse(communitiesURL), headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      });

      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(res.body);
        List<List<String>> communitiedData =
            (body["data"]["userSubreddits"] as List<dynamic>).map((e) {
          final name = e["name"] as String;
          final icon = e["icon"] as String? ?? "";
          return [name, icon];
        }).toList();

        return right(communitiedData);
      } else {
        return left(Failure("Unable to retrieve communities"));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }

  ///The function returns the names of the user's communities
  FutureEither<List<List<String>>> getUserModerating() async {
    final token = await getToken();
    try {
      Response res = await get(Uri.parse(communitiesURL), headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      });

      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(res.body);
        List<List<String>> moderatorsData =
            (body["data"]["userSubreddits"] as List<dynamic>).map((e) {
          final moderators = e["moderators"] as List;
          final moderatorUserNames = moderators.map((mod)=> mod["username"] as String).toList();
          final name = e["name"] as String;
          final icon = e["icon"] as String? ?? "";
          return [name, icon, ...moderatorUserNames];
        }).toList();

        List<List<String>> userModerating = [];
        String username = ref.read(userModelProvider)!.username!;

        for(var mod in moderatorsData)
        {
          if(mod[2].contains(username))
          {
            userModerating.add([mod[0], mod[1]]);
          }
        }

        return right(userModerating);
      } else {
        return left(Failure("Unable to retrieve moderating communities"));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }

  FutureEither<List<List<String>>> searchResults(String searchString) async {
    final token = await getToken();
    try {
      Response res = await get(Uri.parse(communitiesURL), headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      });

      ///This returns the search results that match the searchString

      if (res.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(res.body);
        List<List<String>> communities =
            (body["data"]["userSubreddits"] as List<dynamic>).map((e) {
          final name = e["name"] as String;
          final icon = e["icon"] as String? ?? "";
          return [name, icon];
        }).toList();

        return right(communities
            .where((list) =>
                list[0].toLowerCase().contains(searchString.toLowerCase()))
            .toList());
      } else {
        return left(Failure("Failed to retrieve communities"));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }
}
