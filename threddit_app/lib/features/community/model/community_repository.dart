import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/models/subreddit.dart';

/// This repository handles all the http requests sent to the backend related to community
/// operations like creating a community, fetching a community and joining/unsubscribing from a community
/// createCommunity is used to create a new community
/// fetchCommunity is used to fetch a community
/// joinSubreddit is used to join a community
/// unsubscribeFromSubreddit is used to unsubscribe from a community

class CommunityRepository {
  Future<int> createCommunity(String name, bool nsfw, String type) async {
    String? token = await getToken();

    final url = Uri.parse("https://www.threadit.tech/api/v1/r/create");
    final body = jsonEncode({
      'name': name,
      'srType': type,
      'nsfw': nsfw,
    });

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // Add your token here
    };

    try {
      final response = await http.post(
        url,
        body: body,
        headers: headers,
      );

      if (response.statusCode == 201) {
        jsonDecode(response.body);
        print('coomunity created successfully');
        return 201;
      }
      if (response.statusCode == 409) {
        return 409;
      } else {}
    } catch (e) {}
    return 404;
  }

  Future<Subreddit> fetchCommunity(String subreddit) async {
    String? token = await getToken();
    final url = Uri.parse('https://www.threadit.tech/api/v1/r/$subreddit');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> data = responseData['data'];
        final Map<String, dynamic> communityData = data['subreddit'];
        print("community fetched successfully");
        return Subreddit.fromJson(communityData);
      } else {
        throw Exception('Failed to fetch subreddit info,');
      }
    } catch (e) {
      throw Exception('Community not found , $e');
    }
  }

  Future<void> joinSubreddit(String subredditName) async {
    String? token = await getToken();
    final url = Uri.parse(
        'https://www.threadit.tech/api/v1/r/$subredditName/subscribe');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 201) {
      } else {
        throw Exception('Failed to join subreddit');
      }
    } catch (e) {
      throw Exception('Failed to join subreddit');
    }
  }

  Future<void> unsubscribeFromSubreddit(String subredditName) async {
    String? token = await getToken();
    final url = Uri.parse(
        'https://www.threadit.tech/api/v1/r/$subredditName/unsubscribe');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 204) {
      } else {
        throw Exception('Failed to unsubscribe from subreddit');
      }
    } catch (e) {
      throw Exception('Failed to unsubscribe from subreddit');
    }
  }
}
