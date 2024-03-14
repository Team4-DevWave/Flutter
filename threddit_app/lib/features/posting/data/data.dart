
import 'package:threddit_app/features/commenting/model/comment.dart';
import 'package:threddit_app/features/community/models/community.dart';
import 'package:threddit_app/features/posting/model/post.dart';



final List<Post> posts = [
  Post(
    id: '1',
    title: "I've calling my sister by her full given name when she deadnames my niece ",
    link: 'https://example.com',
    description: "nwnedoiwnoqlksndwenfoiewfnoweinfonwkndkwnod neondoiewndfoewnjndneqwondoiewndoiwenfnwenoewnwncnwondoewnewocnownocwneoicwoencowencowencowneodskmcolnwdoenladnciwenkd  owndowneoi",
    date: DateTime.now(),
    community: Community(
      id: '1',
      name: 'Sample Community',
      description: 'This is a sample community.',
    ),
    upvotes: ['user1', 'user2'],
    downvotes: ['user3', 'user4'],
    commentCount: 10,
    username: 'user1',
    uid: 'user1_uid',
    content: 'This is the content of the sample post.',
     
  ),
  Post(
    id: '2',
    title: 'Sample Post 2',
    link: 'https://example.com',
    description: 'This is another sample post description.',
    date: DateTime.now().subtract(Duration(days: 1)),
    community: Community(
      id: '2',
      name: 'Another Community',
      description: 'This is another sample community.',
    ),
    upvotes: ['user1', 'user3'],
    downvotes: ['user2'],
    commentCount: 5,
    username: 'user2',
    uid: 'user2_uid',
    content: 'This is the content of another sample post.',
  ),
];

final List<Comment> comments =[
    Comment(
      id: 'comment_1',
      content: 'This is the first comment.',
      username: 'User1',
      date: DateTime.now().subtract(Duration(hours: 1)),
      
    ),
    Comment(
      id: 'comment_2',
      content: 'This is the second comment.',
      username: 'User2',
      date: DateTime.now().subtract(Duration(hours: 2)),
      
    ),
    Comment(
      id: 'comment_3',
      content: 'This is the third comment.',
      username: 'User3',
      date: DateTime.now().subtract(Duration(hours: 3)),
      
    ),
    // Add more dummy comments as needed
  ];
