import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

import 'package:http/http.dart' as http;
import 'package:threddit_clone/models/subreddit.dart';

final getCommunityRules = StateNotifierProvider<GetCommunityRules, bool>(
    (ref) => GetCommunityRules(ref));

class GetCommunityRules extends StateNotifier<bool> {
  Ref ref;

  GetCommunityRules(this.ref) : super(false);

  Future<Either<Failure, List<String>>> getCommunityRules(
      String communityName) async {
    final url =
        Uri.parse("https://www.threadit.tech/api/v1/r/$communityName/rules");
    final token = await getToken();
    try {
      final response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<String> rules = List<String>.from(json['data']['rules']);
        return right(rules);
      } else {
        return left(Failure('Something went wrong, please try again later.'));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else if (e is FormatException) {
        return left(Failure('Failed to parse data.'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }
}

Future<SubredditList> fetchSubredditsAll() async {
  final response = await http
      .get(Uri.parse('https://www.threadit.tech/api/v1/r/all?page=1'));
  final response2 = await http
      .get(Uri.parse('https://www.threadit.tech/api/v1/r/all?page=2'));
  final response3 = await http
      .get(Uri.parse('https://www.threadit.tech/api/v1/r/all?page=3'));

  if (response.statusCode == 200) {
    Map<String, dynamic> body = jsonDecode(response.body);
    Map<String, dynamic> body2 = jsonDecode(response2.body);
    Map<String, dynamic> body3 = jsonDecode(response3.body);
    List<dynamic> subredditList = body['data']['subreddits'];
    subredditList.append(body2['data']['subreddits']);
    subredditList.append(body3['data']['subreddits']);

    return SubredditList.fromJson(subredditList);
  } else {
    throw Exception('Failed to load subreddits');
  }
}
