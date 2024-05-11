import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/models/comment.dart';


void main() {
  User me=User(id: 'myId', username: 'myUsername');
  UserModelMe meModel=UserModelMe(karma: Karma(comments: 0,posts:0),id: 'myId',username: 'myUsername',downvotes: Votes(comments: [],posts: []),upvotes: Votes(comments: [],posts: []));
  String postId='postId';
  String content='this is a new comment';
  Comment comment=Comment(user: me, content: content, createdAt: DateTime.now(), votes: Vote(downvotes: 0,upvotes: 0), post: postId, collapsed: false, mentioned: [], id: 'commentId', version: 0,userVote: 'none');
 int currentCommentCount=meModel.karma!.comments;
 int currentUpvoteCount =comment.votes.upvotes;
 int currentDownVoteCount=comment.votes.downvotes;
 group('testing comments',(){
    test('testing adding a comment',(){
      comment.addComment(me,postId,content,meModel);
      expect(comment.content==content,true);
      expect(meModel.karma!.comments==currentCommentCount+1,true);
    });
  
    test('testing deleting a comment',(){
      comment.deleteComment(meModel, comment);
      expect(meModel.karma!.comments==currentCommentCount-1,true);
    });
  
    test('testing editing a comment',(){
     comment.editComment(meModel, comment, content);
      expect(comment.content==content,true);
    });
  
    test('testing upvoting a comment',(){
      
      if(comment.userVote=='upvote')
      {
        comment.upVoteComment(meModel, comment);
        expect(comment.votes.upvotes==currentUpvoteCount-1,true);
      }
      else
      {
        comment.upVoteComment(meModel, comment);
        expect(comment.votes.upvotes==currentUpvoteCount+1,true);
      }
    });
  
    test('testing downvoting a comment',(){
      
      if(meModel.downvotes!.comments.contains(comment.id))
      {
        comment.downVoteComment(meModel, comment);
        expect(comment.votes.downvotes==currentDownVoteCount-1,true);
      }
      else
      {
        comment.downVoteComment(meModel, comment);
        expect(comment.votes.downvotes==currentDownVoteCount+1,true);
      }
    });
  
 });
  
}
