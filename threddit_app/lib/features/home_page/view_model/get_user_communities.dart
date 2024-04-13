import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:http/http.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';

final userCommunitisProvider =
    StateNotifierProvider<UserCommunities, bool>((ref) => UserCommunities(ref));

class UserCommunities extends StateNotifier<bool> {
  Ref ref;
  UserCommunities(this.ref) : super(false);
  // final String communitiesURL =
  //     "https://c461e240-480f-4854-a607-619e661e3370.mock.pstmn.io/communities";

  // static String local = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  final String communitiesURL =
      "http://${AppConstants.local}:8000/api/v1/r/user_subreddits";

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
