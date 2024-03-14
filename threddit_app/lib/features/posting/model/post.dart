//import 'package:intl/intl.dart';
import 'package:threddit_app/features/community/models/community.dart';
import 'package:threddit_app/features/commenting/model/comment.dart';
//final formatter = DateFormat.yMd();

class Post {
  final String id;
  final String title;
  final String? link;
  final String? description;
  final DateTime date;
  final Community community;
  final List<String> upvotes;
  final List<String> downvotes;
  final int commentCount;
  List<Comment> comments=[];
  final String username;
  final String uid;
  final String content;

  Post(
      {required this.id,
      required this.title,
      required this.link,
      this.description,
      required this.date,
      required this.community,
      required this.upvotes,
      required this.downvotes,
      required this.commentCount,
      required this.username,
      required this.uid,
      required this.content});
      
  // String get formattedDate {
  //   return formatter.format(date);
  // }
  void addComment(Comment comment)
  {
    comments.add(comment);
  }
  List<Comment> get retrieveComments {
    return comments;
  }
}
