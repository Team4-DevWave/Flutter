import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/models/votes.dart';

/// This repository handles all the http requests sent to the backend related to post
/// operations like voting on a post, toggling post NSFW status and toggling post spoiler status
/// votePost is used to vote on a post, vote type is 1 for upvote and -1 for downvote
/// togglePostNSFW is used to toggle the NSFW status of a post
/// togglePostSpoiler is used to toggle the spoiler status of a post
/// fetchPost is used to get a post by it's ID
typedef votingParameters = ({String postID, int voteType});
typedef pollVotingParameters = ({String postID, String option});

class PostRepository {
  Future<void> togglePostNSFW(String postId) async {
    try {
      String? jwtToken = await getToken();
      String url = 'https://www.threadit.tech/api/v1/posts/$postId/nsfw';
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwtToken",
      };
      final response = await http.patch(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        print('Post NSFW status toggled successfully');
      }
    } catch (e) {
      print('Error toggling post NSFW status: $e');
    }
  }

  Future<void> togglePostSpoiler(String postId) async {
    try {
      String? jwtToken = await getToken();
      String url = 'https://www.threadit.tech/api/v1/posts/$postId/spoiler';
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwtToken",
      };
      final response = await http.patch(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        print('Post spoiler status toggled successfully');
      }
    } catch (e) {
      print('Error toggling post spoiler status: $e');
    }
  }

  Future<Post> fetchPost(String postId) async {
    String? token = await getToken();
    final url = Uri.parse('https://www.threadit.tech/api/v1/posts/$postId');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final post = Post.fromJson(responseData['data']['post']);
        return post;
      } else {
        throw Exception(
            'Failed to fetch post. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching post: $e');
      throw Exception('Failed to fetch post');
    }
  }

  Future<Votes> getUserUpvotes() async {
    String? token = await getToken();
    final url =
        Uri.parse('https://www.threadit.tech/api/v1/users/me/upvoted?page=1');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Votes.fromJson(responseData);
      } else {
        throw Exception(
            'Failed to get user upvotes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting user upvotes: $e');
      throw Exception('Failed to get user upvotes');
    }
  }

  Future<Votes> getUserDownvotes() async {
    String? token = await getToken();
    final url =
        Uri.parse('https://www.threadit.tech/api/v1/users/me/downvoted?page=1');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Votes.fromJson(responseData);
      } else {
        throw Exception(
            'Failed to get user downvotes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting user downvotes: $e');
      throw Exception('Failed to get user downvotes');
    }
  }
}

final votePost =
    FutureProvider.family<void, votingParameters>((ref, arguments) async {
  try {
    String? token = await getToken();
    final url =
        'https://www.threadit.tech/api/v1/posts/${arguments.postID}/vote';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.patch(
      Uri.parse(url),
      body: jsonEncode({'voteType': arguments.voteType}),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print("post upvoted");
    } else {
      print('Failed to vote on post: ${response.statusCode}');
    }
  } catch (e) {
    print('Error voting on post: $e');
  }
});
final votePoll =
    FutureProvider.family<void, pollVotingParameters>((ref, arguments) async {
  try {
    String? token = await getToken();
    final url =
        'https://www.threadit.tech/api/v1/posts/${arguments.postID}/votepoll';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({'option': arguments.option}),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print("poll voted");
    } else {
      print('Failed to vote on poll: ${response.statusCode}');
    }
  } catch (e) {
    print('Error voting on poll: $e');
  }
});
