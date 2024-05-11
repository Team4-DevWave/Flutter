import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/models/subreddit.dart';

void main() {
  UserModel user = UserModel(id: 'moderatorId', username: 'moderatorUsername');
  SubredditSettings srSettings = SubredditSettings(
      spamFilterStrength: {"posts": "low", "comments": "low", "links": "low"},
      srType: "public",
      nsfw: false,
      postType: 'any',
      allowCrossPosting: true,
      archivePosts: false,
      enableSpoilerTag: true,
      allowImages: true,
      allowMultipleImages: true,
      allowPolls: true,
      postReviewing: false,
      collapseDeletedRemovedComments: true,
      welcomeMessageEnabled: true);
  SubredditLooks srLooks =
      SubredditLooks(banner: "", icon: "", color: "", darkMode: true);
  SubredditUserManagement userManagement =
      SubredditUserManagement(banList: [], mutedList: [], approvedList: []);
  Subreddit subreddit = Subreddit(
      id: 'testingId',
      name: 'testingName',
      moderators: [user],
      members: [user],
      status: 'active',
      srSettings: srSettings,
      srLooks: srLooks,
      userManagement: userManagement,
      rules: [],
      invitedUsers: [],
      version: 0);
      UserModelMe me=UserModelMe(blockedUsers: [],country: '',dateJoined: DateTime.now(),displayName: '',email: 'myEmail',followedPosts: [],followedUsers: [],gender: 'female',id: 'myId',joinedSubreddits: [],username: 'myName');
      UserModel meModel=UserModel(id: 'myId',username: 'myName');
  group('testing subreddits', () {
    test("Joining a community", () {
      subreddit.joinCommunity(user);
      expect(subreddit.members.contains(user), true);
    });
    test('Leaving a community', () {
      subreddit.leaveCommunity(user);
      expect(subreddit.members.contains(user), false);
    });
    test('Creating a community', () {
      Subreddit newSubreddit = Subreddit(
          id: 'newId',
          name: 'newName',
          moderators: [],
          members: [],
          status: 'active',
          srSettings: srSettings,
          srLooks: srLooks,
          userManagement: userManagement,
          rules: [],
          invitedUsers: [],
          version: 0);
      subreddit.createCommunity(me, newSubreddit);

      expect(newSubreddit.moderators.contains(meModel), true);
      expect(newSubreddit.members.contains(meModel), true);
      expect(me.joinedSubreddits!.contains(newSubreddit.name), true);
    });
  });

}
