import 'package:threddit_app/models/comment.dart';
import 'package:threddit_app/models/community.dart';
import 'package:threddit_app/models/post.dart';

final List<Post> posts = [
  Post(
    id: '1',
    title: "I've calling my sister by her full given name when she deadnames my niece ",
    link: 'https://example.com',
    description: "nwnedoiwnoqlksndwenfoiewfnoweinfonwkndkwnod neondoiewndfoewnjndneqwondoiewndoiwenfnwenoewnwncnwondoewnewocnownocwneoicwoencowencowencowneodskmcolnwdoenladnciwenkd  owndowneoi",
    communityName: 'Sample Community',
    communityProfilePic: 'sample_community_profile_pic_url',
    upvotes: ['user1', 'user2'],
    downvotes: ['user3', 'user4'],
    commentCount: 10,
    username: 'user1',
    uid: 'user1_uid',
    type: 'type1',
    createdAt: DateTime.now(),
    awards: ['award1', 'award2'],
  ),
  Post(
    id: '2',
    title: 'Sample Post 2',
    link: 'https://example.com',
    description: 'This is another sample post description.',
    communityName: 'Another Community',
    communityProfilePic: 'another_community_profile_pic_url',
    upvotes: ['user1', 'user3'],
    downvotes: ['user2'],
    commentCount: 0,
    username: 'user2',
    uid: 'user2_uid',
    type: 'type2',
    createdAt: DateTime.now().subtract(Duration(days: 1)),
    awards: [],
  ),
];

final List<Comment> comments = [
  Comment(
    text: 'This is the first comment.',
    createdAt: DateTime.now().subtract(Duration(hours: 1)),
    postId: '1', // Assuming postId
    username: 'User1',
    profilePic: 'profile_pic_url', // Assuming profile picture URL
    upvotes: ['user1', 'user2'],
    downvotes: ['user3', 'user4'],
  ),
  Comment(
    text: 'This is the second comment.',
    createdAt: DateTime.now().subtract(Duration(hours: 2)),
    postId: '1', // Assuming postId
    username: 'User2',
    profilePic: 'profile_pic_url', // Assuming profile picture URL
    upvotes: ['user1', 'user3'],
    downvotes: ['user2'],
  ),
  Comment(
    text: 'This is the third comment.',
    createdAt: DateTime.now().subtract(Duration(hours: 3)),
    postId: '1', // Assuming postId
    username: 'User3',
    profilePic: 'profile_pic_url', // Assuming profile picture URL
    upvotes: ['user1'],
    downvotes: [],
  ),
  // Add more dummy comments as needed
];
