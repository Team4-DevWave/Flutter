
import 'package:threddit_clone/models/post.dart';

final List<Post> posts = [
  Post(
    id: '1',
    title:
        "I've calling my sister by her full given name when she deadnames my niece ",
    link: 'https://example.com',
    description:
        "nwnedoiwnoqlksndwenfoiewfnoweinfonwkndkwnod neondoiewndfoewnjndneqwondoiewndoiwenfnwenoewnwncnwondoewnewocnownocwneoicwoencowencowencowneodskmcolnwdoenladnciwenkd  owndowneoi",
    communityName: 'Flutter Community',
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
    communityName: 'Flutter Community',
    communityProfilePic: 'another_community_profile_pic_url',
    upvotes: ['user1', 'user3'],
    downvotes: ['user2'],
    commentCount: 0,
    username: 'user2',
    uid: 'user2_uid',
    type: 'type2',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    awards: [],
  ),
];

List<String> reportReasons = [
  'Breaks community rules',
  'Harassment',
  'Threatning Violence',
  'Hate',
  'Minor abuse or sexualization',
  'Sharing personal information',
  'Non-consensual intmate media',
  'Prohibited transaction',
  'Impersonation',
  'Copyright violation',
  'Trademark violation',
  'Self-harm or suicide',
  'Spam'
];
