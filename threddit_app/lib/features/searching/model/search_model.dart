import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/searching/model/media.dart';
import 'package:threddit_clone/features/searching/model/search_comment_model.dart';
import 'package:threddit_clone/features/user_system/model/user_data.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/models/comment.dart';
import 'package:threddit_clone/models/community.dart';
import 'package:threddit_clone/models/subreddit.dart';

class SearchModel {
  List<Post> posts = [];
  List<SearchCommentModel> comments = [];
  List<Subreddit> subreddits = [];
  List<Media> medias = [];
  List<UserModelMe> users = [];
  SearchModel({
    required this.posts,
    required this.comments,
    required this.subreddits,
    required this.medias,
    required this.users,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    final List<Post> parsedPosts = PostApiResponse.fromJson(json).posts;

    print(parsedPosts.length);
    List<dynamic> commentsList = json['data']['comments'];
    print(commentsList);
    final List<SearchCommentModel> parsedComments =
        SearchCommentsList.fromJson(commentsList).comments;

    List<dynamic> subredditList = json['data']['subreddits'];
    final List<Subreddit> parsedSubreddits =
        SubredditList.fromJson(subredditList).subreddits;
    print(
        "INSIDE SEAERCHMODEL FROM JSON !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    print(parsedSubreddits.length);
    final List<Media> parsedMedias = [];
    if (json['data']['media'] is List) {
      for (var mediaJson in json['data']['media'] as List) {
        print(mediaJson);
        parsedMedias.add(Media.fromJson(mediaJson));
      }
    }
    final List<UserModelMe> parsedUsers = [];
    if (json['data']['users'] is List) {
      for (var userJson in json['data']['users'] as List) {
        parsedUsers.add(UserModelMe.fromJsonSearch(userJson));
      }
    }

    return SearchModel(
      posts: parsedPosts,
      comments: parsedComments,
      subreddits: parsedSubreddits,
      medias: parsedMedias,
      users: parsedUsers,
    );
  }
}
