import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/models/subreddit.dart';

class CommunityRepository {
  Future<int> createCommunity(String name, bool nsfw, String _type) async {
    String? token = await getToken();

    final url = Uri.parse("http://10.0.2.2:8000/api/v1/r/create");
    final body = jsonEncode({
      'name': name,
      'srType': _type,
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
        print('community created successfully');
        return 201;
      }
      if (response.statusCode == 409) {
        return 409;
      } else {
        print(
            'Failed to create community. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating community: $e');
    }
    return 404;
  }

  Future<Subreddit> fetchCommunity(String subreddit) async {
    String? token = await getToken();
    final url = Uri.parse('http://10.0.2.2:8000/api/v1/r/$subreddit');
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
        return Subreddit.fromJson(communityData);
      } else {
        print(
            'Failed to fetch subreddit info. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch subreddit info');
      }
    } catch (e) {
      print('Error fetching subreddit info: $e');
      throw Exception('Community not found');
    }
  }

  Future<void> joinSubreddit(String subredditName) async {
    String? token = await getToken();
    final url =
        Uri.parse('http://10.0.2.2:8000/api/v1/r/$subredditName/subscribe');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 201) {
        print('Successfully joined subreddit: $subredditName');
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String status = responseData['status'];
        print('Response status: $status');
      } else {
        print(
            'Failed to join subreddit: $subredditName. Status code: ${response.statusCode}');
        throw Exception('Failed to join subreddit');
      }
    } catch (e) {
      print('Error joining subreddit: $e');
      throw Exception('Failed to join subreddit');
    }
  }

  Future<void> unsubscribeFromSubreddit(String subredditName) async {
    String? token = await getToken();
    final url =
        Uri.parse('http://10.0.2.2:8000/api/v1/r/$subredditName/unsubscribe');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 204) {
        print('Successfully unsubscribed from subreddit: $subredditName');
        print('Response status: ${response.statusCode}');
      } else {
        print(
            'Failed to unsubscribe from subreddit: $subredditName. Status code: ${response.statusCode}');
        throw Exception('Failed to unsubscribe from subreddit');
      }
    } catch (e) {
      print('Error unsubscribing from subreddit: $e');
      throw Exception('Failed to unsubscribe from subreddit');
    }
  }
}
