
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threddit_clone/features/home_page/view/screens/main_community_screen.dart';
import 'package:threddit_clone/features/home_page/view/widgets/communities_list.dart';
import 'package:threddit_clone/features/home_page/view/widgets/community_feed_unit.dart';
import 'package:threddit_clone/features/home_page/view/widgets/following_tiles.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/models/subreddit.dart';
import 'package:threddit_clone/theme/photos.dart';

void main() {
  group("getting random subreddit lists", () {
    //Arrange
      UserModel user =
          UserModel(id: 'moderatorId', username: 'moderatorUsername');
      SubredditSettings srSettings = SubredditSettings(
          spamFilterStrength: {
            "posts": "low",
            "comments": "low",
            "links": "low"
          },
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
      SubredditLooks srLooks1 =
          SubredditLooks(banner: "", icon: "", color: "", darkMode: true);
      SubredditLooks srLooks2 =
          SubredditLooks(banner: "", icon: "https://res.cloudinary.com/dxy3lq6gh/image/upload/v1715379980/rcot1gq3yyj5gktr3lv9.jpg", color: "", darkMode: true);
      SubredditUserManagement userManagement =
          SubredditUserManagement(banList: [], mutedList: [], approvedList: []);
      Subreddit subreddit1 = Subreddit(
          id: 'testingId',
          name: 'testingName',
          moderators: [user],
          members: [user],
          status: 'active',
          srSettings: srSettings,
          srLooks: srLooks1,
          userManagement: userManagement,
          rules: [],
          invitedUsers: [],
          version: 0);
      Subreddit subreddit2 = Subreddit(
          id: 'Id2',
          name: 'testingName2',
          moderators: [user],
          members: [user],
          status: '',
          srSettings: srSettings,
          srLooks: srLooks2,
          userManagement: userManagement,
          rules: [],
          invitedUsers: [],
          version: 0);
          Subreddit subreddit3 = Subreddit(
          id: 'Id3',
          name: 'testingName3',
          moderators: [user],
          members: [user],
          status: '',
          srSettings: srSettings,
          srLooks: srLooks2,
          userManagement: userManagement,
          rules: [],
          invitedUsers: [],
          version: 0);
      final List<Subreddit> allSubs = [subreddit1, subreddit2, subreddit3];
    test("The function returns 2 lists", () {
      //Act
      List<List<Subreddit>> dividedSubs = getRandomSubreddits(allSubs);

      //Assert
      expect(dividedSubs.length, 2);
    });
    test("The number of subreddits in the divided lists equals the number of all subreddits", () {
      //Act
      List<List<Subreddit>> dividedSubs = getRandomSubreddits(allSubs);

      //Assert
      expect(dividedSubs[0].length + dividedSubs[1].length, allSubs.length);
    });

     test("Set the image to the default image if there is no link", () {

      // where subreddit1 doesn't have an icon image
      ImageProvider image = setCommunityImage(subreddit1);

      //Assert
      expect(image, const NetworkImage(Photos.communityDefault));
    });

    test("Set the community image to the link image if there is a link", () {

      //Act
      // where the subreddit2 has an icon image
      ImageProvider image = setCommunityImage(subreddit2);

      //Assert
      expect(image, NetworkImage(srLooks2.icon));
    });

  });

  group("Setting the user profile picture in the following tiles", () { 
     //Arrange
      UserModelMe user1 =
          UserModelMe(id: 'moderatorId', username: 'moderatorUsername', profilePicture: "https://res.cloudinary.com/dxy3lq6gh/image/upload/v1715379980/rcot1gq3yyj5gktr3lv9.jpg");
      test("Setting the image to the default profile picture if the variable is empty", () {
        //Act
        ImageProvider image = putUserProfilepic("");
        //Assert
        expect(image, const AssetImage('assets/images/Default_Avatar.png'));
      });

      test("Setting the image to the user's profile pictue", () {
        //Act
        ImageProvider image = putUserProfilepic(user1.profilePicture!);
        
        //Assert
        expect(image, NetworkImage(user1.profilePicture!));
      });

  });

  group("Setting an image for the communities list", () { 
    test("Set the image to the default image if there is no link", () {
      //Act
      ImageProvider image = putProfilepic("");

      //Assert
      expect(image, const NetworkImage("https://st2.depositphotos.com/1432405/8410/v/450/depositphotos_84106432-stock-illustration-saturn-icon-simple.jpg"));
    });

    test("Set the image to the link image if there is a link", () {
      //Arrange
      String imageLink ="https://res.cloudinary.com/dxy3lq6gh/image/upload/v1715379980/rcot1gq3yyj5gktr3lv9.jpg";
      //Act
      ImageProvider image = putProfilepic(imageLink);

      //Assert
      expect(image, NetworkImage(imageLink));
    });
  });

   
}
