import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:http/http.dart' as http;
import 'package:threddit_app/features/commenting/model/comment.dart';
import 'package:threddit_app/features/commenting/model/comment_repository.dart';


// Mock HTTP client
class MockClient extends Mock implements http.Client {}

void main() {
  group('CommentRepository', () {
    test('fetchComments - Success', () async {
  // Arrange
  final client = MockClient();
  final repository = CommentRepository();
  final postId = '1';

  // Define a mock response in a variable
  final responseBody =
    '[{"id": "a115", "text": "This is the second comment.", "createdAt": "2024-03-21T06:30:00.000Z", "postId": "1", "username": "User2", "profilePic": "profile_pic_url", "upvotes": ["user1"], "downvotes": ["user2"]},'
    '{"id": "97c3", "text": "This is the third comment.", "createdAt": "2024-03-21T05:30:00.000Z", "postId": "1", "username": "User3", "profilePic": "profile_pic_url", "upvotes": ["user1"], "downvotes": []},'
    '{"id": "12f9", "text": "this is a new comment ", "postId": "1", "username": "user1", "createdAt": "2024-03-20T21:01:27.727734", "upvotes": [], "downvotes": []}]';

  // Create a response with a configurable content-type header
  final response = http.Response(responseBody, 200, headers: {
    'content-type': 'application/json',
  });

  // Act
  final comments = await repository.fetchComments(postId);

  // Assert
  expect(comments.length, 3);
  expect(comments[0].id, 'a115');
  expect(comments[0].text, 'This is the second comment.');
  expect(comments[0].username, 'User2');
  expect(comments[0].profilePic, 'profile_pic_url');
  expect(comments[0].upvotes, ['user1']);
  expect(comments[0].downvotes, ['user2']);

});


 test('addComment - Success', () async {
      // Arrange
      final client = MockClient();
      final repository = CommentRepository();
      final commentText = 'Test Comment';
      final postId = '1';
      final uid = 'Test User';

      // Define the expected comment data
      final commentData = {
        'id' : 'ss15',
        'text': commentText,
        'postId': postId,
        'username': uid,
        'upvotes': [],
        'downvotes': [],
      };

      // Define the expected JSON data for the comment
      final jsonData = jsonEncode(commentData);

      // Define a mock response to the POST request
      final responseBody = jsonEncode({
        ...commentData,
        'createdAt': '2024-03-25T12:00:00.000Z', 
      });
      final response = http.Response(responseBody, 201);

      // Configure the mock client to return the mock response when the POST request is made
     when(client.post(
  Uri.parse('http://192.168.100.249:3000/comments'),
  headers: {'Content-Type': 'application/json; charset=UTF-8'},
  body: jsonData,
)).thenAnswer((_) async => http.Response('', 201));

      // Act
      await repository.addComment(commentText, postId, uid);

      // Assert
      // Verify that the POST request was made to the correct URL with the expected JSON data
      verify(client.post(
        Uri.parse('http://192.168.100.249:3000/comments'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonData,
      ));

      // Verify that the added comment is included in the fetched comments
      final addedComment = Comment.fromJson(jsonDecode(responseBody));
      final fetchedComments = await repository.fetchComments(postId);
      expect(fetchedComments.contains(addedComment), true);
    });
   
  });
}
