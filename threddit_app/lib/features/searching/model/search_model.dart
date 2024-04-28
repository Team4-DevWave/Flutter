import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/searching/model/media.dart';
import 'package:threddit_clone/models/comment.dart';
import 'package:threddit_clone/models/community.dart';
import 'package:threddit_clone/models/subreddit.dart';

class SearchModel {
  List<Post> posts = [];
  List<Comment> comments = [];
  List<Subreddit> subreddits = [];
  List<Media> medias = [];
  SearchModel({
    required this.posts,
    required this.comments,
    required this.subreddits,
    required this.medias,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    final List<Post> parsedPosts = [];
    if (json['data']['posts'] is List) {
      for (var postJson in json['data']['posts'] as List) {
        parsedPosts.add(Post.fromJson(postJson));
      }
    }

    final List<Comment> parsedComments = [];
    if (json['data']['comments'] is List) {
      for (var commentJson in json['data']['comments'] as List) {
        parsedComments.add(Comment.fromJson(commentJson));
      }
    }
    final List<Subreddit> parsedSubreddits = [];
    if (json['data']['subreddits'] is List) {
      for (var subredditJson in json['data']['subreddits'] as List) {
        parsedSubreddits.add(Subreddit.fromJson(subredditJson));
      }
    }

    final List<Media> parsedMedias = [];
    if (json['data']['medias'] is List) {
      for (var mediaJson in json['data']['medias'] as List) {
        parsedMedias.add(Media.fromJson(mediaJson));
      }
    }

    return SearchModel(
      posts: parsedPosts,
      comments: parsedComments,
      subreddits: parsedSubreddits,
      medias: parsedMedias,
    );
  }
}
