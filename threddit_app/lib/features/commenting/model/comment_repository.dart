import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


///this repository handles all the http requests sent to the backend related to comment
///operations like fetching all comments, creating a comment, voting on a comment, editing a comment and deleting a comment
///fetch comment is used to get all the comments of a post and then used by get comments stream which automatically fetches the comments every 5 seconds to update the UI continously
///create comment is used to create a new comment on a post
///vote comment is used to vote on a comment, vote type is 1 for upvote and -1 for downvote
///edit comment is used to edit a comment and accepts a comment ID and the new content as it's parameters
///delete comment is used to delete a comment and accepts a comment ID as it's parameter

class CommentRepository {
  

  Future<void> voteComment(String commentId, int voteType) async {
    try {
      final url =
          'http://${AppConstants.local}:8000/api/v1/comments/$commentId/vote';
      final token = await getToken();
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http.patch(
        Uri.parse(url),
        body: jsonEncode({"voteType": voteType}),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print("voted successfully");
      } else {
        print('Failed to vote on comment: ${response.body}');
      }
    } catch (e) {
      print('Error voting on comment: $e');
    }
  }

 
}
