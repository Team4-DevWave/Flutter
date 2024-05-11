import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';



void main() {
  User me=User(id: 'myId', username: 'myUsername');
  UserModelMe meModel=UserModelMe(karma: Karma(comments: 0,posts:0),id: 'myId',username: 'myUsername',downvotes: Votes(comments: [],posts: []),upvotes: Votes(comments: [],posts: []));
 Post post =Post(id: 'postId', title: 'postTitle', nsfw: false, spoiler: false, locked: false, approved:true, postedTime:DateTime.now(), numViews: 10, commentsCount: 5,votes: VotesList(upvotes: 0, downvotes: 0),userVote: 'none');
 group('testing posts',(){
    test('Upvoting a post',(){
      int currentUpvoteCount=post.votes!.upvotes;
       if(post.userVote=='upvote')
      {
        post.upVotePost(meModel);
        expect(post.votes!.upvotes==currentUpvoteCount-1,true);
      }
      else
      {
        post.upVotePost(meModel);
        expect(post.votes!.upvotes==currentUpvoteCount+1,true);
      }
    });
    test('Downvoting a post',(){
      int currentDownVoteCount=post.votes!.downvotes;
       if(meModel.downvotes!.posts.contains(post.id))
      {
        post.downVotePost(meModel);
        expect(post.votes!.downvotes==currentDownVoteCount-1,true);
      }
      else
      {
        post.downVotePost(meModel);
        expect(post.votes!.downvotes==currentDownVoteCount+1,true);
      }
      
    });
    
 });
  
}
