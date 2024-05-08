import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:http/http.dart' as http;

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
      print(response.statusCode);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<String> rules = List<String>.from(json['data']['rules']);
        print(rules);
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
